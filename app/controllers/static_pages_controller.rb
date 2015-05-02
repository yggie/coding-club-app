class StaticPagesController < ApplicationController
  def home_page
    @upcoming_events = Event.upcoming
  end
end
