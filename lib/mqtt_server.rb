require_relative "mqtt_server/version"
require_relative 'mqtt_server/server'

module MqttServer

  class Error < StandardError; end

  Server.new
  
  module Packets
        
  end
end
