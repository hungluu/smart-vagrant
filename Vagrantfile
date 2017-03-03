# -*- mode: ruby -*-
# vi: set ft=ruby :
#======================================
# Lamp-Vagrant
# @author : HR
# @version : 0.0.2
# @copyright : Dumday (c) 2017
#======================================
require_relative "include/LVCommand"
require_relative "config/providers"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version
Vagrant.configure("2") do |config|
  # Load configuration
  settings = YAML::load_file(File.join(".", "config", "main.yaml"))
  ip_prefix = settings["ip_prefix"]

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = settings["box"]

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = settings["box_check_update"]

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "#{ip_prefix}.254"

  # Using ip
  private_network_ips = settings["private_network_ips"]
  private_network_ips.each do |ip_last_number|
    ip = "#{ip_prefix}.#{ip_last_number}"
    puts "* Using custom private ip #{ip}"
    config.vm.network "private_network", ip: ip
  end

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./config/apache2/sites", "/etc/apache2/sites-enabled", :mount_options => [ "dmode=777", "fmode=666" ]
  synced_folders = settings["synced_folders"]
  synced_folders.each do |local_path, vm_path|
    puts "* Using synced folder #{local_path}"
    config.vm.synced_folder local_path, vm_path
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  Providers.select(config, settings["provider"])

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  command = LVCommand.create_shared_command

  require_relative "provision/provision"
  ########################
  # INSTALL DEPENDENCIES #
  ########################
  repositories = settings["repositories"]
  repositories.each do |repository_name|
    command.push_message("Adding apt-repo #{repository_name}")
    command.push("add-apt-repository -y #{repository_name} 2>/dev/null")
  end
  # Ensure postgresql 9.5 installable
  command.push_message("Adding apt-repo for postgresql 9.5")
  command.queue_copy("etc/apt/sources.list.d/pgdg.list")

  # Update packages
  command.push_message("Updating packages, please wait...")
  command.push(command.update)

  # Install required packages by scripts
  dependencies = settings["dependencies"]
  unless dependencies.nil?
    dependencies.each do |package_name|
      install_script = File.join(".", "provision", "scripts", "install_#{package_name}")
      if File.file? "#{install_script}.rb"
        require_relative "#{install_script}"
      else
        command.pushFile("#{install_script}.sh")
      end
    end
  end

  #####################
  #     COPY FILES    #
  #####################
  command.push_message("Copying necessary files ...")
  copied_files = settings["copy"]
  unless copied_files.nil?
    copied_files.each do |dest_path|
      if File.file?(File.join("config", "copy", dest_path))
        command.queue_copy(dest_path)
      end
    end
  end
  # Every scripts after done provisioning should be placed in this file
  require_relative "provision/provision-post"

  config.vm.provision "run-commands", type: "shell" do |s|
    s.privileged = true
    # Build final command
    s.inline = command.get
  end
end
