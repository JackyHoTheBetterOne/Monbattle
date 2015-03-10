class LiveInternetFtwController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:dick_count] = 0
  end

  def dick_love
    if message[:dick_count] > 0
      new_message = {
        :message => 'Counting dicks',
        :count => message[:dick_count]
      }
      broadcast_message(:dick_love, new_message)
    end
  end
end
