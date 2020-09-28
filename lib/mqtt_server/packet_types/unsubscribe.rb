# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All ubsubscribe packets follow this convention.
    #
    class Unsubscribe < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
