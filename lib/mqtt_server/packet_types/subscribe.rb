# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All subscribe packets follow this convention.
    #
    class Subscribe < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
