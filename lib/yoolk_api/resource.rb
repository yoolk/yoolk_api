require 'hashie/mash'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/wrap'
require 'active_support/concern'

module YoolkApi
  module Resource
    autoload :HasManyAssociation, 'yoolk_api/resource/has_many_association'
    autoload :Base,               'yoolk_api/resource/base'
  end
end