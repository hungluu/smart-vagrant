#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Command builder
require "yaml"
require_relative "command_builders/UbuntuCommand"
require_relative "CentosMergedCommand"
#======================================
class LampVagrant
  ########################
  # Lamp-Vagrant Helpers #
  ########################
  # Create a shared command for files
  def self.init(machine_name)
    @instance = new(machine_name)
  end

  # Get shared command
  def self.instance
    @instance
  end

  def initialize(machine_name)
    @settings = YAML::load_file(File.join(".", "config", machine_name + ".yaml"))
    repositories = @settings['repositories']
    if repositories.nil?
      repositories = []
    end
    @settings['repositories'] = repositories

    ultilities_ip = @settings["ultilities_ip"]
    if ultilities_ip.nil?
      @settings["use_ultilities"] = false
    else
      @settings["use_ultilities"] = true
    end

    @command = case os
      when "ubuntu" then UbuntuCommand.new
      else CentosMergedCommand.new
    end
  end

  def os
    @settings["os"]
  end

  def version
    @settings["version"]
  end

  def command
    @command
  end

  def settings
    @settings
  end

  def apache2_restart
    case os
    when "centos"
      command.push(command.restart_service("httpd"))
    else
      command.push(command.restart_service("apache2"))
    end
  end

  # def apache2_enable_site(site_name)
  #   case os
  #   when "centos"
  #     command.push("sudo ln /etc/httpd/sites-available")
  #   else
  #     command.push("service apache2 restart")
  #   end
  # end

  def require_apt_repo(repo_name)
    repositories = @settings['repositories']
    if repositories.nil?
      repositories = []
    end

    unless repositories.include? repo_name
      repositories.push(repo_name)
    end
    @settings['repositories'] = repositories
  end

  def push_install_message(package_list, level = 0)
    package_names = package_list.reject(&:empty?).join(", ")
    message_pattern = "Installing: %s ..."
    if (level > 0)
      pad_str = "=" * level * 2
      message_pattern = pad_str + "> " + message_pattern
    end

    command.push_message(message_pattern, package_names)
  end

  # Queue copying a file when provisioning
  # file should be placed in config/copy folder
  def queue_copy(source_path, dest_path = nil)
    if dest_path.nil?
      dest_path = "/#{source_path}"
    else
      dest_path = "/#{dest_path}"
    end
    vm_source_path = "/lamp-vagrant/config/copy/#{source_path}"
    command.push_message("Copying %s ...", [dest_path])
    command.push(
      command.make_if(command.check_file_existence(vm_source_path),
        command.sudo(command.copy(vm_source_path, dest_path)),
      command.warning("File not exists")),
    false)
  end
end
