# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All disconnect packets follow this convention.
    #
    class Disconnect < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
