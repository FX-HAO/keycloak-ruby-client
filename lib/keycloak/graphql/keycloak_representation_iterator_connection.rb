module GraphQL
  module Relay
    class KeycloakRepresentationIteratorConnection < BaseConnection
      def cursor_from_node(item)
        item_index = paged_nodes.index(item)
        if item_index.nil?
          raise("Can't generate cursor, item not found in connection: #{item}")
        else
          offset = item_index + (paged_nodes_offset || 0)

          encode(offset.to_s)
        end
      end

      # TODO: support `before`
      def has_next_page
        sliced_nodes_count >= (first || max_page_size)
      end

      # TODO: support `before`
      def has_previous_page
        false
      end

      def first
        return @first if defined? @first

        @first = get_limited_arg(:first)
        @first = max_page_size if @first && max_page_size && @first > max_page_size
        @first
      end

      def last
        return @last if defined? @last

        @last = get_limited_arg(:last)
        @last = max_page_size if @last && max_page_size && @last > max_page_size
        @last
      end

      private

      # apply first / last limit results
      # @return [Array]
      def paged_nodes
        return @paged_nodes if defined? @paged_nodes

        items = sliced_nodes

        if first
          items.till = items.first + first
        end

        if max_page_size && !first && !last
          items.till = items.first + max_page_size
        end

        @paged_nodes_offset = items.first

        @paged_nodes = items.to_a
      end

      def paged_nodes_offset
        paged_nodes && @paged_nodes_offset
      end

      def relation_offset(iterator)
        iterator.first
      end

      def relation_limit(iterator)
        iterator.till
      end

      # Apply cursors to edges
      def sliced_nodes
        return @sliced_nodes if defined? @sliced_nodes

        @sliced_nodes = nodes

        if after
          @sliced_nodes.first = offset_from_cursor(after) + 1
        end

        @sliced_nodes
      end

      def sliced_nodes_count
        return @sliced_nodes_count if defined? @sliced_nodes_count

        @sliced_nodes_count = paged_nodes.size
      end

      def offset_from_cursor(cursor)
        decode(cursor).to_i
      end
    end

    BaseConnection.register_connection_implementation(Keycloak::Utils::RepresentationIterator, KeycloakRepresentationIteratorConnection)
  end
end
