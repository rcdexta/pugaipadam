class ActivityController < ApplicationController
  def index
    @activity = Activity.recent
    render layout: false
  end
end