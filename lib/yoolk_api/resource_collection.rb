module YoolkApi
  class ResourceCollection
    attr_reader :klass, :api_path, :query, :resources,
                :current_page, :total_entries, :total_pages, :per_page

    def initialize(klass, api_path)
      @klass        = klass
      @api_path     = api_path
      @query        = {}
    end

    def q(value)
      @query.merge!(q: value)
      self
    end

    def fields(value)
      @query[:fields] = @query[:fields].to_s + ",#{value}"
      @query[:fields] = @query[:fields].gsub(/^,/, '')
      self
    end

    def page(value)
      @query.merge!(page: value)
      self
    end

    def per_page(value=nil)
      if value.nil?
        @per_page
      else
        @query.merge!(per_page: value)
        self
      end
    end

    def reset_query
      @query = {}
    end

    def inspect
      to_a.inspect
    end

    def to_a
      return @resources if loaded?

      set_response(YoolkApi.client.get(to_api_path))
      @resources
    end
    alias :to_ary :to_a

    def set_response(response)
      return if response.blank?

      @query_cache    = @query.dup
      @resources      = response['data'].collect { |item| klass.new(item) }
      @current_page   = response['paging']['current_page']
      @total_entries  = response['paging']['total_entries']
      @total_pages    = response['paging']['total_pages']
      @per_page       = response['paging']['per_page']
    end

    def to_api_path
      "#{api_path}?#{query.to_query}".gsub(/\?$/, '')
    end

    def present?
      to_a.present?
    end

    def loaded?
      @query_cache == @query
    end

    def count
      total_entries
    end

    def next_page
      current_page < total_pages ? (current_page + 1) : nil
    end

    def previous_page
      current_page > 1 ? (current_page - 1) : nil
    end

    def offset
      (current_page == 1) ? 1 : (current_page-1) * per_page
    end

    def page_offset
      current_offset = (offset == 1) ? 1 : offset + 1
      end_point      = per_page * current_page
      end_point      = total_entries if end_point > total_entries

      [current_offset, end_point]
    end

    private
    def method_missing(method, *args, &block)
      if Array.method_defined?(method)
        to_a.send(method, *args, &block)
      else
        super
      end
    end
  end
end