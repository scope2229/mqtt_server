# frozen_string_literal: true

module MqttBroker
  module Packets
    ##
    # All connect packets follow this convention.
    #
    class Connect
      def initialize
        puts "Connect packet"
      end
    end
  end
end