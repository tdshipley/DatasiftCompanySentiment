class SentimentController < ApplicationController
  def new
  end

  def show
    @company_name = params[:company_name]
  end
end
