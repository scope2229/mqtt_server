# frozen_string_literal: true

require 'socket'

module MqttServer
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
  class Server
    attr_accessor :host
    attr_accessor :port
    attr_accessor :ssl_port
    attr_accessor :packet
    ##
    # Max size of packet to receive
    MAX_REQUEST_SIZE = 1024
    SELECT_TIMEOUT = 0.5
    ATTR_DEFAULTS = {
      port: ENV['MQTT_SERVER_PORT'] || 1883,
      ssl_port: ENV['MQTT_SERVER_SSL_PORT'],
      host: ENV['MQTT_SERVER_HOST'] ||
            Socket.ip_address_list.detect(&:ipv4_private?)
                  .ip_address
    }

    def initialize(**args)
      puts 'Server created'
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
      @packet = nil
      @flags = []
    end

    ##
    # Main loop for server. All incomming connection are handled here
    def start_listening
      puts "The server is listening at HOST:PORT #{@host}:#{@port}"
      loop do
        Thread.start(@server.accept) do |client|
          puts "what is the client #{client}"
          receive_packet unless (@socket = client).nil?
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
    #
    # FLAGS
    #  Table 2.2 - Flag Bits (Flags are returned as true or false)
    # Control Packet | Fixed header flags | Bit 3 | Bit 2 | Bit 1 | Bit 0 |
    # CONNECT        | Reserved           |   0   |   0   |   0   |   0   |
    # CONNACK        | Reserved           |   0   |   0   |   0   |   0   |
    # PUBLISH        | Used in MQTT 3.1.1 |  DUP1 | QoS2  | QoS2  |RETAIN3|
    # PUBACK         | Reserved           |   0   |   0   |   0   |   0   |
    # PUBREC         | Reserved           |   0   |   0   |   0   |   0   |
    # PUBREL         | Reserved           |   0   |   0   |   1   |   0   |
    # PUBCOMP        | Reserved           |   0   |   0   |   0   |   0   |
    # SUBSCRIBE      | Reserved           |   0   |   0   |   1   |   0   |
    # SUBACK         | Reserved           |   0   |   0   |   0   |   0   |
    # UNSUBSCRIBE    | Reserved           |   0   |   0   |   1   |   0   |
    # UNSUBACK       | Reserved           |   0   |   0   |   0   |   0   |
    # PINGREQ        | Reserved           |   0   |   0   |   0   |   0   |
    # PINGRESP       | Reserved           |   0   |   0   |   0   |   0   |
    # DISCONNECT     | Reserved           |   0   |   0   |   0   |   0   |
    #
    # As per 4.8 Handling errors any error at this stage with the packet or flags
    # should disconnect the client for which the protocol failure occurred 
    def receive_packet
      result = IO.select([@socket],[],[],SELECT_TIMEOUT)
      unless result.nil?
        packet = MqttServer::BasePacket.read(@socket)
        handle_packet(packet)
      end
    rescue StandardError => e
      unless @socket.nil?
        @socket.close
        @socket = nil
        puts "error found #{e}"
        # handle_close
      end
    end

    def handle_packet(packet)
      # What Class is the packet
      case packet
      when MqttServer::PacketTypes::Connect
        puts "CONNECT PACKET"
      when MqttServer::PacketTypes::Connack
        puts "CONNACK PACKET"
      end
      # if packet.class == MQTT::Packet::Publish
      #   # Add to queue
      #   @read_queue.push(packet)
      # elsif packet.class == MQTT::Packet::Pingresp
      #   @last_ping_response = Time.now
      # elsif packet.class == MQTT::Packet::Puback
      #   @pubacks_semaphore.synchronize do
      #     @pubacks[packet.id] << packet
      #   end
      # end
      # Ignore all other packets
      # FIXME: implement responses for QoS  2
    end
  end
end
