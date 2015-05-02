class EventsController < ApplicationController
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
      redirect_to users_dashboard_path, flash: { success: 'Successfully scheduled an event' }
    else
      @available_hosts = User.subscribed
      flash.now[:warning] = @event.errors.full_messages.join(', ')
      render :edit
    end
  end

  def update
    @event = Event.friendly.find(params.require(:id))

    if @event.update_attributes(event_params)
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
