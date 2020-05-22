require_relative "mqtt_broker/version"
require_relative 'mqtt_broker/broker'
require 'mqtt_broker/packets/connect'

module MqttBroker

  class Error < StandardError; end

  Broker.new
  
  module Packets
        
  end
  MQTT_PACKET_TYPES = [
    nil,
    ::Packets::Connect,
  ]
end
