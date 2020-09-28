# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All pubrec packets follow this convention.
    #
    class Pubrec < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
