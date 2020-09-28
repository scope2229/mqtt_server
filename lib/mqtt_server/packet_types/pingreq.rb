# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All pingreq packets follow this convention.
    #
    class Pingreq < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
