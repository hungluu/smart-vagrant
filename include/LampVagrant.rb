#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Command builder
require "yaml"
require_relative "LinuxCommand"
#======================================
class LampVagrant < LinuxCommand
  ########################
  # Lamp-Vagrant Helpers #
  ########################
  # Create a shared command for files
  def self.create_command
    @command = new
  end

  # Get shared command
  def self.command
    @command
  end

  def push_install_message(package_list)
    package_names = package_list.reject(&:empty?).join(", ")
    push_message("Installing: %s ...", package_names)
  end

  def push_install(package_list, params = '-qq')
    push_install_message(package_list)
    push(install(package_list, params))
  end

  # Queue copying a file when provisioning
  # file should be placed in config/copy folder
  def queue_copy(source_path)
    dest_path = "/#{source_path}"
    vm_source_path = "/vagrant/config/copy/#{source_path}"
    push_message("Copying %s ...", [dest_path])
    push(
      make_if(check_file_existence(vm_source_path),
        sudo(copy(vm_source_path, dest_path)),
      warning("File not exists")),
    false)
  end
end
