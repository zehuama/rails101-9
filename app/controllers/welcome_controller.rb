class WelcomeController < ApplicationController
  def index
    flash[:notice] = "Hello!Hello!Hello!"
  end
end
