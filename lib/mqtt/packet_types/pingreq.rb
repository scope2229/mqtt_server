# frozen_string_literal: true

module MQTT
  module PacketTypes
    ##
    # All pingreq packets follow this convention.
    #
    class Pingreq < MQTT::BasePacket
      # Create a new Ping Request packet
      def initialize(args = {})
        super(args)
      end

      # Check the body
      def parse_body(buffer)
        super(buffer)

        return if buffer.empty?
        raise ProtocolException, 'Extra bytes at end of Ping Request packet'
      end
    end
  end
end
