# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All pubrel packets follow this convention.
    #
    class Pubrel < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
