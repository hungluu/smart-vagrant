#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Command builder
require "yaml"
require_relative "command_builders/UbuntuCommand"
require_relative "CentosMergedCommand"
require_relative "ServicesLoader"
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
    @machine_name = machine_name
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

  def machine_name
    @machine_name
  end

  # Return current os
  def os
    @settings["os"]
  end

  # Return current version
  def version
    @settings["version"]
  end

  # Get command
  def command
    @command
  end

  # Get current settings
  def settings
    @settings
  end

  def run_script(script_name)
    install_script = File.join(".", "provision", "scripts", "#{script_name}");
    custom_install_script = File.join(".", "scripts", "#{script_name}");

    if File.file?("#{custom_install_script}.rb")
      require "#{custom_install_script}"
    elsif File.file?("#{custom_install_script}.sh")
      command.pushFile("#{custom_install_script}.sh")
    elsif File.file?("#{install_script}.rb")
      require "#{install_script}"
    elsif File.file?("#{install_script}.sh")
      command.pushFile("#{install_script}.sh")
    else
      puts "* #{machine_name}: [Warning] No script found for '#{script_name}'"
    end
  end

  def install_package(package_name)
    install_script = File.join(".", "provision", "install", "install_#{package_name}")
    custom_install_script = File.join(".", "scripts", "install_#{package_name}")

    if File.file?("#{custom_install_script}.rb")
      require "#{custom_install_script}"
    elsif File.file?("#{custom_install_script}.sh")
      command.pushFile("#{custom_install_script}.sh")
    elsif File.file?("#{install_script}.rb")
      require "#{install_script}"
    elsif File.file?("#{install_script}.sh")
      command.pushFile("#{install_script}.sh")
    else
      puts "* #{machine_name}: [Warning] No installation script found for '#{package_name}', using default command..."
      push_install_message([package_name])
      command.push(command.install([package_name]))
    end
  end

  def install_apt_repo(repository_name)
    install_script = File.join(".", "provision", "apt-repo", "add_repo_#{repository_name}")
    custom_install_script = File.join(".", "scripts", "add_repo_#{repository_name}")

    if File.file?("#{custom_install_script}.rb") # custom add_repo_{name}.rb
      require "#{custom_install_script}"
    elsif File.file?("#{custom_install_script}.sh") # custom add_repo_{name}.sh
      command.pushFile("#{custom_install_script}.sh")
    elsif File.file?("#{install_script}.rb") # add_repo_{name}.sh
      require "#{install_script}"
    elsif File.file?("#{install_script}.sh") # add_repo_{name}.sh
      command.pushFile("#{install_script}.sh")
    else
      puts "* #{machine_name}: [Warning] No installation script found for repo '#{repository_name}', using default command..."
      command.push_message("Adding apt-repo #{repository_name} ...")
      command.push(command.add_repo(repository_name))
    end
  end

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

  def require_package(package_name)
    packages = @settings['dependencies']
    if packages.nil?
      packages = []
    end

    unless packages.include? package_name
      packages.push(package_name)
      install_package(package_name)
    end
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
