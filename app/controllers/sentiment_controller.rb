class SentimentController < ApplicationController
  require 'DatasiftHelper'

  def new
  end

  def show
    @company_name = params[:company_name]

    helper = DatasiftHelper.new
    helper.gather_data(@company_name)
    puts "Count of items #{helper.data.count}"

    @data_gathered = helper.data
  end
end
