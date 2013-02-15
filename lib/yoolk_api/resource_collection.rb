module YoolkApi
  class ResourceCollection
    attr_reader :klass, :api_path, :response, :query, :resources

    def initialize(klass, api_path, response={})
      @klass        = klass
      @api_path     = api_path
      self.response = response
      @query        = {}
    end

    def q(value)
      query.merge!(q: value)
      self
    end

    def fields(value)
      query[:fields] = query[:fields].to_s + ",#{value}"
      query[:fields] = query[:fields].gsub(/^,/, '')
      self
    end

    def page(value)
      query.merge!(page: value)
      self
    end

    def per_page(value=nil)
      if value.nil?
        response['paging']['per_page']
      else
        query.merge!(per_page: value)
        self
      end
    end

    def inspect
      to_a.inspect
    end

    def to_a
      return @resources if loaded?

      self.response = YoolkApi.client.get(to_api_path)
      @resources
    end
    alias :to_ary :to_a

    def response=(response)
      @response  = response
      @resources = @response['data'].collect { |item| klass.new(item) } if response.present? and response.key?('data')
    end

    def to_api_path
      "#{api_path}?#{query.to_query}".gsub(/\?$/, '')
    end

    def present?
      to_a.present?
    end

    def loaded?
      @resources.present?
    end

    def current_page
      response['paging']['current_page']
    end

    def next_page
      current_page < total_pages ? (current_page + 1) : nil
    end

    def previous_page
      current_page > 1 ? (current_page - 1) : nil
    end

    def total_entries
      response['paging']['total_entries']
    end
    alias :total_count :total_entries
    alias :count :total_entries

    def total_pages
      response['paging']['total_pages']
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