class NewslettersController < ApplicationController
  before_action :authenticate_user!

  def new
    @newsletter = Newsletter.new(subject: 'This Week',
      body: "# Preview\n\nClick “Generate Preview” to generate a preview of the email template")

    render :show
  end

  def show
    @newsletter = Newsletter.find(params[:id])
  end

  def index
    @newsletters = Newsletter.order(created_at: :desc).includes(:author)
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

    if @newsletter.update_attributes(newsletter_params)
      redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully sent email' }
    else
      flash.now[:danger] = @newsletter.errors.full_messages.join(', ')
      render :show
    end
  end

  def preview
    @newsletter = Newsletter.new(newsletter_params)

    render template: 'app_mailer/send_newsletter', layout: false
  end

  def send_to_test_group
    @newsletter = Newsletter.find(params[:newsletter_id])

    AppMailer.send_newsletter(@newsletter, group: :test).deliver
    redirect_to newsletter_path(@newsletter), flash: { success: 'Successfully sent newsletter to the test group' }
  end

  def send_to_subscribed_group
    @newsletter = Newsletter.find(params[:newsletter_id])

    redirect_to newsletter_path(@newsletter), flash: { info: 'Sorry this action has not yet been implemented!' }
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:subject, :recipients, :body)
  end
end
