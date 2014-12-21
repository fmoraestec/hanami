require 'lotus/utils/string'

module Lotus
  module Config
    # Sessions configuration
    #
    # @since 0.2.0
    # @api private
    class Sessions

      # Ruby namespace for Rack session adapters
      #
      # @since 0.2.0
      # @api private
      RACK_NAMESPACE = 'Rack::Session::%s'.freeze

      # Localhost string for detecting localhost host configuration
      #
      # @since x.x.x
      # @api private
      LOCALHOST = 'localhost'.freeze

      # HTTP sessions configuration
      #
      # @param adapter [Symbol,String,Class] the session adapter
      # @param options [Hash] the optional session options
      # @param configuration [Lotus::Configuration] the application configuration
      #
      # @since 0.2.0
      # @api private
      #
      # @see http://www.rubydoc.info/github/rack/rack/Rack/Session/Abstract/ID
      def initialize(adapter = nil, options = {}, configuration = nil)
        @adapter       = adapter
        @options       = options
        @configuration = configuration
      end

      # Check if the sessions are enabled
      #
      # @return [FalseClass,TrueClass] the result of the check
      #
      # @since 0.2.0
      # @api private
      def enabled?
        !!@adapter
      end

      # Returns the Rack middleware and the options
      #
      # @return [Array] Rack middleware and options
      #
      # @since 0.2.0
      # @api private
      def middleware
        middleware = case @adapter
                     when Symbol
                       RACK_NAMESPACE % Utils::String.new(@adapter).classify
                     else
                       @adapter
                     end

        [middleware, options]
      end

      private

      # @since 0.2.0
      # @api private
      def options
        default_options.merge(@options)
      end

      # @since 0.2.0
      # @api private
      def default_options
        if @configuration && !localhost?
          { domain: @configuration.host, secure: @configuration.ssl? }
        else
          {}
        end
      end

      # @since x.x.x
      # @api private
      def localhost?
        @configuration.host.eql? LOCALHOST
      end
    end
  end
end
