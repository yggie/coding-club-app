class StaticPagesController < ApplicationController
  def home_page
    @todays_event = Event.where(date: Date.today).first
    @upcoming_events = Event.upcoming
  end
end
