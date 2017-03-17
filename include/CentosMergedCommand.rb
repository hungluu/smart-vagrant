#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Command builder
require_relative "command_builders/CentosCommand"

class CentosMergedCommand < CentosCommand
  # Resolve packages from ubuntu to centos
  def resolve_packages(package_names)
    package_names
      .gsub(/^apache2$/, 'httpd')
      .gsub(/php5\.6/, 'php56w')
  end
end
