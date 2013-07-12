module YoolkApi
  class Account < SubResource

    def yoolk_admin?
      roles.find { |role| role.name == 'Yoolk Admin' }.present?
    end

    def has_portal_role?(role_name)
      roles.find do |role|
        role.name == role_name and role.resource_type == "Portal" and
        role.resource.domain_name == YoolkApi.client.domain_name
      end.present?
    end

    def has_listing_role?(role_name)
      roles.find do |role|
        role.name == role_name and role.resource_type == "Listing"
      end.present?
    end

    class << self
      
      def me(query={})
        begin
          response = YoolkApi.client.get(api_path(query))
        rescue JsonError, NetworkError, BadRequestError => exception
          raise NotFoundError.new(exception.response_body, exception.response_status, exception.url)
        end
        member response
      end

      def api_path(query={})
        "/me?#{query.to_query}".gsub(/\?$/, '')
      end
    end
  end
end