require "./mqtt_broker/version"
require './mqtt_broker/broker'

module MqttBroker
  class Error < StandardError; end
  
  autoload :Broker, 'mqtt_broker'  
  
  module Packets
    autoload :Connect, 'mqtt_broker/packets/connect'
  end
end
