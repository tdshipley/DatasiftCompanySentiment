class DatasiftHelper

  @data = nil
  @conn = nil

  def data
    @data
  end

  def gather_data(company_name)
    config = getConfig
    @datasift = DataSift::Client.new(config)

    # Declare a filter in CSDL, looking for content mentioning brands
    csdl = "interaction.content contains_any \"#{company_name}\""

    # Compile the filter
    filter = @datasift.compile csdl

    @data = Array.new

    # Handler: Message (i.e. a new Tumblr post) is received
    on_message = lambda do |message, stream, hash|
      if @data.count >= 2
        stream.unsubscribe(hash)
      elsif
        @data << message
        puts 'Got some data'
      end
    end

    # Handler: Message deleted by user
    on_delete = lambda { |stream, message| @data.delete message }

    # Handler: An error occurred
    on_error = lambda { |stream, e| stream.exit }

    # Handler: Connected to DataSift
    on_connect = lambda do |stream|
      puts 'Connected to DataSift'
      stream.subscribe(filter[:data][:hash], on_message)
    end

    on_close = lambda do |stream,msg|
      # This is called when a connection is closed; you should probably log this event
      puts 'connection closed'
    end

    # Create stream object, and start streaming data
    @conn = DataSift::new_stream(config, on_delete, on_error, on_connect, on_close)
    @conn.stream.read_thread.join
  end

  protected

    def getConfig
      username = Rails.application.secrets['datasift_username']
      api_key = Rails.application.secrets['datasift_key']
      return { username: username, api_key: api_key, enable_ssl: true }
    end
end