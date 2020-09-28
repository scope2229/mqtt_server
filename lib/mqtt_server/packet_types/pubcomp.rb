# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All pubcomp packets follow this convention.
    #
    class Pubcomp < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
