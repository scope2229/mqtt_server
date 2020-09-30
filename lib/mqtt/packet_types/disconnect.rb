# frozen_string_literal: true

module MQTT
  module PacketTypes
    ##
    # All disconnect packets follow this convention.
    #
    class Disconnect < MQTT::BasePacket
      # Create a new Client Disconnect packet
      def initialize(args = {})
        super(args)
      end

      # Check the body
      def parse_body(buffer)
        super(buffer)

        return if buffer.empty?
        raise ProtocolException, 'Extra bytes at end of Disconnect packet'
      end
    end
  end
end
