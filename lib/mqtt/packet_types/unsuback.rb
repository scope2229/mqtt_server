# frozen_string_literal: true

module MQTT
  module PacketTypes
    ##
    # All unsuback packets follow this convention.
    #
    class Unsuback < MQTT::BasePacket
      # Create a new Unsubscribe Acknowledgment packet
      def initialize(args = {})
        super(args)
      end

      # Get serialisation of packet's body
      def encode_body
        encode_short(@id)
      end

      # Parse the body (variable header and payload) of a packet
      def parse_body(buffer)
        super(buffer)
        @id = shift_short(buffer)

        return if buffer.empty?
        raise ProtocolException, 'Extra bytes at end of Unsubscribe Acknowledgment packet'
      end

      # Returns a human readable string, summarising the properties of the packet
      def inspect
        "\#<#{self.class}: 0x%2.2X>" % id
      end
    end
  end
end
