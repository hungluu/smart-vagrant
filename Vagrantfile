# -*- mode: ruby -*-
# vi: set ft=ruby :
#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
require "yaml"
require File.join(".", "include", "CommandBuilder")
require File.join(".", "config", "providers")

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

  command = CommandBuilder.new

  #####################
  # SEPECIAL COMMANDS #
  #####################
  # Hide tty warning
  command.push("sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile")
  # Enable sites
  # command.push(command.copy("/vagrant/config/apache2/sites", "/etc/apache2/sites-enabled"))
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/vagrant/config/apache2/lampVagrant.conf", "/etc/apache2/conf-available/lampVagrant.conf"))
  command.push("a2enconf lampVagrant 2>/dev/null")
  # Ensure xdebug directory exists
  command.push(command.create_folder("/usr/lib/php5/20131226"))

  #####################
  #     COPY FILES    #
  #####################
  command.pushMessage("Copying necessary files ...")
  copied_files = settings["copy"]
  copied_files.each do |dest_path|
    if File.file?(File.join("config", "copy", dest_path))
      source_path = File.join("vagrant", "config", "copy", dest_path)
      command.push(command.copy("/#{source_path}", "/#{dest_path}"))
    end
  end

  command.pushFile(File.join(".", "provision", "provision.sh"))
  ########################
  # INSTALL DEPENDENCIES #
  ########################
  repositories = settings["repositories"]
  repositories.each do |repository_name|
    command.pushMessage("Adding apt-repo #{repository_name}")
    command.push("add-apt-repository -y #{repository_name} 2>/dev/null")
  end

  # Update packages
  command.pushMessage("Updating packages, please wait...")
  command.push(command.update)
  # puts command.update
  # puts "======"
  # puts command.get
  # exit

  # Install required packages by scripts
  dependencies = settings["dependencies"]
  dependencies.each do |package_name|
    command.pushFile(File.join(".", "provision", "scripts", "install_#{package_name}.sh"))
  end
  #======================================
  # End Install required packages by scripts
  # Every scripts after done provisioning should be placed in this file
  command.pushFile(File.join(".", "provision", "provision-post.sh"))

  config.vm.provision "run-commands", type: "shell" do |s|
    s.privileged = true
    # Build final command
    s.inline = command.get
  end
end
