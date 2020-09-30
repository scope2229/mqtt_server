# frozen_string_literal: true

module MQTT
  module PacketTypes
    ##
    # All pingresp packets follow this convention.
    #
    class Pingresp < MQTT::BasePacket
      # Create a new Ping Response packet
      def initialize(args = {})
        super(args)
      end

      # Check the body
      def parse_body(buffer)
        super(buffer)

        return if buffer.empty?
        raise ProtocolException, 'Extra bytes at end of Ping Response packet'
      end
    end
  end
end
