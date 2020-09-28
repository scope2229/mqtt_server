# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All pingresp packets follow this convention.
    #
    class Pingresp < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
