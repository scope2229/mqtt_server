# frozen_string_literal: true

require 'socket'
require './packets/connect'

module MqttBroker
  ##
  # MqttBroker::Broker creates a non-blocking multithreaded TCPServer
  # The server follows the MQTT protocol outlined here
  # http://mqtt.org/documentation
  #
  # == Usage
  # 
  # You can import the project into an existing project,
  # and create a new MqttBroker::Broker object.
  #
  # == Configuration
  #
  # Defaults settings have been configured to use device's local
  # IP address e.g. 192.169.0.111. For non SSL communication the
  # default port is 1883, with 8883 being used for SSL communication.
  #
  # To change the default options you can export local env variables
  # as below. If using ENV['VARS'] do not pass arguments with 
  # RMqtt::Broker.new as this will override the values.
  #
  # MQTT_SERVER_HOST for the host ip/address.
  # MQTT_SERVER_PORT for the port.
  # MQTT_SERVER_SSL_PORT for the ssl socket port
  #
  # == Arguments
  #
  # The Broker class takes in a hash as params with host: and port:
  # both are optional and if either are left out defaults are used.
  # MqttBroker::Broker.new(host: 'localhost', port: 1883)
  class Broker
    attr_accessor :host
    attr_accessor :port
    attr_accessor :ssl_port

    ##
    # Max size of packet to receive
    MAX_REQUEST_SIZE = 1024

    ATTR_DEFAULTS = {
      port: ENV['MQTT_SERVER_PORT'] || 1883,
      ssl_port: ENV['MQTT_SERVER_SSL_PORT'],
      host: ENV['MQTT_SERVER_HOST'] ||
            Socket.ip_address_list.detect(&:ipv4_private?)
                  .ip_address
    }

    def initialize(**args)
      puts "Server created"
      ATTR_DEFAULTS.merge(args).each_pair do |k, v|
        send("#{k}=", v)
      end
      @server = begin
                  TCPServer.new(@host, @port)
                rescue SystemCallError => e
                  raise "Cannot initialize tcp server for
                         host:port #{@host}:#{@port} ::
                         ERROR :: #{e}"
                end
      @socket = nil
      start_listening
    end

    ##
    # Main loop for server. All incomming connection are handled here
    def start_listening
      puts "Im listening"
      loop do
        Thread.start(@server.accept) do |client|
          puts "HOW MANY TIMES #{@socket}"
          puts "HOW MANY TIMES CLIENT #{@client}"
          @socket = client
          puts " HOW MANY SOCKETS #{@socket}"
          read_packet_type unless (@socket = client).nil?
          raise 'Error server connection with empty client information' if client.nil?
        end
      end
    end

    ##
    # Used to determine which packet has been sent
    # Each packet has a fixed header 
    # ( MQTT CPT = Control Packet Type )
    # Bit     | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
    # byte 1  |    MQTT CPT   | Flags specific to each MQTT CPT  
    # byte 2  |         Remaining length      |
    # 
    # Name        |  Value  |  Direction of flow | Description
    # ------------------------------------------------------------
    # Reserved    |    0    |      Forbidden     |    Reserved
    # CONNECT     |    1    |  Client to Server  | Client request to connect to Server
    # CONNACK     |    2    | Server to Client   | Connect acknowledgment
    # PUBLISH     |    3    | Client to Server or Server to Client | Publish message
    # PUBACK      |    4    | Client to Server or Server to Client | Publish acknowledgment
    # PUBREC      |    5    | Client to Server or Server to Client | Publish received (assured delivery part 1)
    # PUBREL      |    6    | Client to Server or Server to Client | Publish release (assured delivery part 2)
    # PUBCOMP     |    7    | Client to Server or Server to Client | Publish complete (assured delivery part 3)
    # SUBSCRIBE   |    8    | Client to Server    | Client subscribe request
    # SUBACK      |    9    | Server to Client    | Subscribe acknowledgment
    # UNSUBSCRIBE |    10   | Client to Server    | Unsubscribe request
    # UNSUBACK    |    11   | Server to Client    | Unsubscribe acknowledgment
    # PINGREQ     |    12   | Client to Server    | PING request
    # PINGRESP    |    13   | Server to Client    | PING response
    # DISCONNECT  |    14   | Client to Server    | Client is disconnecting
    # Reserved    |    15   | Forbidden           | Reserved
    # 
    # A CONNECT packets first byte returns as \x10 or 16 with unpack('C')
    # Performing a bit shift right by 4 bits after bit matching (&) returning 
    # The value 1
    def read_packet_type
      puts "Read the first byte to determine packet_type"
      byte = @socket.read(1)
      raise ProtocolException, 'Failed to read byte from socket' if byte.nil?
      type_id = ((byte.unpack('C').first & 0xF0) >> 4)
      # Now we have the packet type asign defined packet to packet_class
      packet_class = MqttBroker::MQTT_PACKET_TYPES[type_id]
      
      flags = (0..3).map { |i| byte & (2**i) != 0 }
      puts "What is the first byte #{type_id} :: #{byte.unpack('C').first} :: #{byte.inspect} :: #{byte.to_s} :: #{flags}"
    end

    def validate_flags
      return if flags == [false, false, false, false]

      raise ProtocolException, "Invalid flags in #{type_name} packet header"
    end

  end

  MQTT_PACKET_TYPES = [
    nil, # a return of 0 is invalid 
    MqttBroker::Packets::Connect,
    MqttBroker::Packets::Connack,
    nil,
  ]
end