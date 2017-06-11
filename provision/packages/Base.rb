#======================================
# Smart-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
module SmartVagrantPackage
  class Base
    def name
      "Base"
    end

    def initialize(smart)
      @smart = smart
      @command = smart.command
      @os = smart.os
      @config = smart.settings
    end

    def config
      @config
    end

    def smart
      @smart
    end

    def command
      @command
    end

    def os
      @os
    end

    def bind(package_name)
    end

    def resolve(package_name)
      Util.resolve(package_name)
    end

    def require(package_name, package_version)
      smart.require_package(package_name, package_version)
    end

    def before_install
      smart.push_install_message([name])
    end

    def acquire(package_name)
      command.push(command.install([package_name]))
    end

    def acquire_list(package_list)
      command.push(command.install(package_list))
    end

    def install
    end

    def after_install
    end

    def do_install
      before_install
      install
      after_install
    end

    def before_remove
    end

    def remove
    end

    def after_remove
    end

    def do_remove
      before_remove
      remove
      after_remove
    end

    def get_dependencies
      []
    end

    def package
    end
  end
end
