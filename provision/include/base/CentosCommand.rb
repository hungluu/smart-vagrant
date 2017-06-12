#======================================
# Smart-Vagrant
# @copyright : Hung Luu (c) 2017
#======================================
# Command builder
require_relative "BaseCentosCommand"

module SmartVagrant
  module Include
    module Base
      class CentosCommand < BaseCentosCommand
        # Resolve packages from ubuntu to centos
        def resolve_packages(package_names)
          package_names
            .gsub(/^apache2$/, 'httpd')
            .gsub(/php5\.6/, 'php56w')
        end
      end
    end
  end
end
