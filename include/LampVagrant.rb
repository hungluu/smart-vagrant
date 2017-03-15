#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Command builder
require "yaml"
require_relative "command_builders/UbuntuCommand"
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
    @command = UbuntuCommand.new
    @settings = YAML::load_file(File.join(".", "config", machine_name + ".yaml"))
    repositories = @settings['repositories']
    if repositories.nil?
      repositories = []
    end
    @settings['repositories'] = repositories
  end

  def command
    @command
  end

  def settings
    @settings
  end

  def require_apt_repo(repo_name)
    repositories = @settings['repositories']
    unless repositories.include? repo_name
      repositories.push(repo_name)
    end
    @settings['repositories'] = repositories
  end

  def push_install_message(package_list)
    package_names = package_list.reject(&:empty?).join(", ")
    command.push_message("Installing: %s ...", package_names)
  end

  def push_install(package_list, params = '-qq')
    push_install_message(package_list)
    command.push(command.install(package_list, params))
  end

  # Queue copying a file when provisioning
  # file should be placed in config/copy folder
  def queue_copy(source_path)
    dest_path = "/#{source_path}"
    vm_source_path = "/vagrant/config/copy/#{source_path}"
    command.push_message("Copying %s ...", [dest_path])
    command.push(
      command.make_if(command.check_file_existence(vm_source_path),
        command.sudo(command.copy(vm_source_path, dest_path)),
      command.warning("File not exists")),
    false)
  end
end
