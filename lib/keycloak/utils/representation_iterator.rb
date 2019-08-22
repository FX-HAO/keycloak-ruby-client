module Keycloak
  module Utils
    # RepresentationIterator provides ability to enable lazy loading if necessary.
    #
    # NOTE: It's worth noting that `to_a` may be costly if you have a large dataset of users,
    # which could cause out-of-memory, but using `each` instead of `to_a` could save you if
    # you really want iterate all users.
    class RepresentationIterator
      DEFAULT_PER_PAGE = 30

      include Enumerable

      attr_accessor :first, :per_page, :till
      attr_reader :cursor

      def initialize(client, params, per_page: DEFAULT_PER_PAGE, till: nil, &block)
        @client = client
        @params = params
        @params[:first] ||= 0
        @first = @params[:first]
        @till = @params[:max] || till
        @per_page = per_page
        @block = block

        @data = []
        @cursor = 0
      end

      def first=(num)
        @first = num
        @cursor = 0
        @data = []
      end

      def each
        while true
          return if at_end?
          _fetch_next if @data.empty? || @cursor >= @data.size
          return if @data.empty?

          yield @data[@cursor]
          @cursor += 1
        end
      end

      private

      def _fetch_next
        @params[:first] = @first
        @params[:max] = @per_page
        @data = @client.instance_eval(&@block)

        @first += @per_page
        @cursor = 0
      end

      def at_end?
        @till && @till <= @params[:first] + @cursor
      end
    end
  end
end
