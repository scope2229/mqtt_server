#!/usr/bin/env ruby

require 'mqtt/version'

module MQTT
  # autoload the server and basePacket due to the dynamic 
  # nature of the application.
  autoload :Server,        'mqtt/server'
  autoload :BasePacket,    'mqtt/base_packet'

  # Super-class for other Mqtt related exceptions
  class Exception < StandardError
  end

  # A ProtocolException will be raised if there is a
  # problem with data received from a remote host
  class ProtocolException < MQTT::Exception
  end

  # A NotConnectedException will be raised when trying to
  # perform a function but no connection has been
  # established
  class NotConnectedException < MQTT::Exception
  end

  ##
  # MQTT::PacketTypes
  # This module holds all the configurations for the 
  # packets required by the mqtt protocol to function.
  module PacketTypes
    autoload :Connack,     'mqtt/packet_types/connack'
    autoload :Connect,     'mqtt/packet_types/connect'
    autoload :Disconnect,  'mqtt/packet_types/disconnect'
    autoload :Pingreq,     'mqtt/packet_types/pingreq'
    autoload :Pingresp,    'mqtt/packet_types/pingresp'
    autoload :Puback,      'mqtt/packet_types/puback'
    autoload :Pubcomp,     'mqtt/packet_types/pubcomp'
    autoload :Publish,     'mqtt/packet_types/publish'
    autoload :Pubrec,      'mqtt/packet_types/pubrec'
    autoload :Pubrel,      'mqtt/packet_types/pubrel'
    autoload :Suback,      'mqtt/packet_types/suback'
    autoload :Subscribe,   'mqtt/packet_types/subscribe'
    autoload :Unsuback,    'mqtt/packet_types/unsuback'
    autoload :Unsubscribe, 'mqtt/packet_types/unsubscribe'
  end
end
