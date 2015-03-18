require 'json'
require 'digest'
require 'uri'
require 'net/http'

class User::Tracking
  include Virtus.model

  attribute :user, User
  attribute :battle, Battle
  attribute :session_id
  attribute :event_id
  attribute :value
  attribute :user_id

  attribute :game_key, String, default: ENV["GAME_KEY"]
  attribute :secret_key, String, default: ENV["GAME_SECRET"]
  attribute :endpoint_url, String, default: "http://api.gameanalytics.com/1"
  attribute :category, String, default: "design"
  attribute :message, Hash, default: {}

  def user_side_pick
    self.message["event_id"] = event_id
    message["user_id"] = user.user_name
    message["session_id"] = session_id
    message["build"] = "1.00"
    message["value"] = self.value
  end


  def battle_side_tracking
    self.message["event_id"] = event_id
    message["user_id"] = user_id
    message["session_id"] = session_id
    message["build"] = "1.00"
    message["value"] = self.value
    message["area"] = battle.battle_level.name.gsub(" ", "_")
  end

  def call
    json_message = message.to_json
    json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
    url = "#{endpoint_url}/#{game_key}/#{category}"
    uri = URI(url)
    req = Net::HTTP::Post.new(uri.path)
    req.body = json_message
    req['Authorization'] = json_authorization

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    p "======================================================================="
    p "#{event_id} tracking: #{res.body}"
    p "======================================================================="
  end
end