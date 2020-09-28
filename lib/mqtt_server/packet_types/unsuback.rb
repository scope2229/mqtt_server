# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All unsuback packets follow this convention.
    #
    class Unsuback < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
