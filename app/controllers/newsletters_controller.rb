class NewslettersController < ApplicationController
  before_action :authenticate_user!

  def new
    @newsletter = Newsletter.new(
      subject: 'This Week',
      body: <<-MARKDOWN
# Welcome to this week's Coding Club

*****************************

# This’s Week’s Talk
[Details of the talk]

*****************************

# What People are up to

## [Person]
[What “Person” is planning to do]

*****************************

Closing remarks

**Alliants Coding Club Committee**
      MARKDOWN
    )

    render :show
  end

  def show
    @newsletter = Newsletter.find(params[:id])
  end

  def index
    @newsletters = Newsletter.drafts.order(created_at: :desc).includes(:author)
    @archived = Newsletter.archived.order(created_at: :desc).includes(:author)
  end

  def create
    @newsletter = current_user.newsletters.build(newsletter_params)

    if @newsletter.save
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully saved email draft' }
    else
      flash.now[:danger] = @newsletter.errors.full_messages.join(', ')
      render :show
    end
  end

  def update
    @newsletter = Newsletter.find(params[:id])

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

    render template: 'app_mailer/prepare_newsletter', layout: false
  end

  def confirm
    @newsletter = Newsletter.find(params.require(:newsletter_id))

    render template: 'newsletters/confirm'
  end

  def send_to_test_group
    @newsletter = Newsletter.find(params[:newsletter_id])

    if @newsletter.readonly?
      redirect_to newsletter_path(@newsletter), flash: { warning: 'This newsletter can no longer be sent because it has been marked as read only' }
    else
      SendNewsletterJob.perform_later(@newsletter, true)
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully sent newsletter to the test group' }
    end
  end

  def send_to_subscribed_group
    @newsletter = Newsletter.find(params[:newsletter_id])

    if @newsletter.readonly?
      redirect_to newsletter_path(@newsletter), flash: { warning: 'This newsletter can no longer be sent because it has been marked as read only' }
    elsif @newsletter.update_attributes(sent_at: Time.now)
      SendNewsletterJob.perform_later(@newsletter, false)
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully delivered newsletter' }
    else
      redirect_to newsletter_path(@newsletter), flash: { danger: 'The action failed unexpected' }
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:subject, :body)
  end
end
