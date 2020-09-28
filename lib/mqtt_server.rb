#!/usr/bin/env ruby

require 'mqtt_server/version'

module MqttServer
  # autoload the server and basePacket due to the dynamic 
  # nature of the application.
  autoload :Server,        'mqtt_server/server'
  autoload :BasePacket,    'mqtt_server/base_packet'

  # Super-class for other Mqtt related exceptions
  class Exception < StandardError
  end

  # A ProtocolException will be raised if there is a
  # problem with data received from a remote host
  class ProtocolException < MqttServer::Exception
  end

  # A NotConnectedException will be raised when trying to
  # perform a function but no connection has been
  # established
  class NotConnectedException < MqttServer::Exception
  end

  ##
  # MqttServer::PacketTypes
  # This module holds all the configurations for the 
  # packets required by the mqtt protocol to function.
  module PacketTypes
    autoload :Connack,     'mqtt_server/packet_types/connack'
    autoload :Connect,     'mqtt_server/packet_types/connect'
    autoload :Disconnect,  'mqtt_server/packet_types/disconnect'
    autoload :Pingreq,     'mqtt_server/packet_types/pingreq'
    autoload :Pingresp,    'mqtt_server/packet_types/pingresp'
    autoload :Puback,      'mqtt_server/packet_types/puback'
    autoload :Pubcomp,     'mqtt_server/packet_types/pubcomp'
    autoload :Publish,     'mqtt_server/packet_types/publish'
    autoload :Pubrec,      'mqtt_server/packet_types/pubrec'
    autoload :Pubrel,      'mqtt_server/packet_types/pubrel'
    autoload :Suback,      'mqtt_server/packet_types/suback'
    autoload :Subscribe,   'mqtt_server/packet_types/subscribe'
    autoload :Unsuback,    'mqtt_server/packet_types/unsuback'
    autoload :Unsubscribe, 'mqtt_server/packet_types/unsubscribe'
  end

  ##
  # MqttServer::Actions 
  # Module handles actions needed to be executed on the
  # server. E.g storring client information, handle ping resp,
  # **ack packets, etc 
  module Actions
    autoload :ConnectClient, 'mqtt_server/actions/connect_client'
  end
end
