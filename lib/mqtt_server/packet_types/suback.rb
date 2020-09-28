# frozen_string_literal: true

module MqttServer
  module PacketTypes
    ##
    # All suback packets follow this convention.
    #
    class Suback < MqttServer::BasePacket
      def initialize(args = {}); end
    end
  end
end
