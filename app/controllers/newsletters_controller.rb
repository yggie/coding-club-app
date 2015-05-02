class NewslettersController < ApplicationController
  before_action :authenticate_user!

  def show
    @newsletter = Newsletter.friendly.find(params[:id])
  end

  def new
  end

  def create
    @newsletter = Newsletter.draft(
      target_date: params.require(:newsletter).permit(:target_date).fetch('target_date')
    )

    if @newsletter.save
      NewsletterDraftCreatedNotificationJob.new.perform(@newsletter.id)
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully created newsletter draft' }
    else
      errors = @newsletter.errors.full_messages.reject { |message| message.match(/(?:subject|body)/i) }
      flash.now[:warning] = errors.join(', ')
      render :new
    end
  end

  def archived
    @archived = Newsletter.archived.order(created_at: :desc)
  end

  def update
    PaperTrail.whodunnit = current_user.id
    @newsletter = Newsletter.friendly.find(params[:id])

    if @newsletter.readonly?
      flash.now[:warning] = 'This draft can no longer be modified'
      render :show
    elsif @newsletter.update_attributes(newsletter_params)
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully updated the draft' }
    else
      flash.now[:danger] = @newsletter.errors.full_messages.join(', ')
      render :show
    end
  end

  def preview
    @newsletter = Newsletter.new(newsletter_params)
    @user = current_user

    render template: 'app_mailer/newsletter', layout: 'app_mailer'
  end

  def confirm
    @newsletter = Newsletter.friendly.find(params.require(:newsletter_id))

    render template: 'newsletters/confirm'
  end

  def send_to_test_group
    @newsletter = Newsletter.friendly.find(params[:newsletter_id])

    if @newsletter.readonly?
      redirect_to newsletter_path(@newsletter), flash: { warning: 'This newsletter can no longer be sent because it has been marked as read only' }
    else
      SendNewsletterJob.perform_later(@newsletter, true)
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully sent newsletter to the test group' }
    end
  end

  def send_to_subscribed_group
    PaperTrail.whodunnit = current_user.id
    @newsletter = Newsletter.friendly.find(params[:newsletter_id])

    if @newsletter.readonly?
      redirect_to newsletter_path(@newsletter), flash: { warning: 'This newsletter can no longer be sent because it has been marked as read only' }
    elsif @newsletter.update_attributes(sent_at: Time.now)
      SendNewsletterJob.perform_later(@newsletter, false)
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully delivered newsletter' }
    else
      redirect_to newsletter_path(@newsletter), flash: { danger: @newsletter.errors.full_messages.join(', ') }
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:subject, :body)
  end
end
