class EventsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update]

  def new
    @available_hosts = User.subscribed
  end

  def edit
    @event = Event.friendly.find(params.require(:id))
    @available_hosts = User.subscribed
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      NotifyEventCreatedJob.new.perform(@event.id)
      redirect_to users_dashboard_path, flash: { success: 'Successfully scheduled an event' }
    else
      @available_hosts = User.subscribed
      flash.now[:warning] = @event.errors.full_messages.join(', ')
      render :edit
    end
  end

  def archived
    @archived_events = Event.archived
  end

  def update
    @event = Event.friendly.find(params.require(:id))

    old_user_id = @event.user_id
    if @event.update_attributes(event_params)
      if @event.user_id != old_user_id
        AppMailer.event_created_for_you_notification(@event, @event.user).deliver_later
      end
      redirect_to users_dashboard_path, flash: { success: 'Successfully updated event' }
    else
      @available_hosts = User.subscribed
      flash.now[:warning] = @event.errors.full_messages.join(', ')
      render :edit
    end
  end


  private

  def event_params
    params.require(:event).permit(:title, :technologies, :summary, :date, :user_id)
  end
end
