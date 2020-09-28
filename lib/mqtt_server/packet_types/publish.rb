# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All publish packets follow this convention.
    #
    class Publish < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
