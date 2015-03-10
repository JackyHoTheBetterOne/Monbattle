class LiveInternetFtwController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:dick_count] = 0
  end

  


end
