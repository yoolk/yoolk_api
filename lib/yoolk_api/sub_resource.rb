module YoolkApi
  class SubResource < Resource
    class << self
      undef_method :find
    end
  end
end