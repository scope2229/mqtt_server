# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All puback packets follow this convention.
    #
    class Puback < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
