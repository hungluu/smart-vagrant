# -*- mode: ruby -*-
# vi: set ft=ruby :
#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
require 'yaml';

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  # Load configuration
  settings = YAML::load_file("./config/main.yaml")
  ipPrefix = settings["ipPrefix"]

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = settings["box"]

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = settings["boxCheckUpdate"]

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "#{ipPrefix}.254"

  # Using ip
  ipPostfixes = settings["ipPostfixes"]
  ipPostfixes.each do |postFix|
    ip = "#{ipPrefix}.#{postFix}"
    puts "* Adding custom ip #{ip}"
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
  config.vm.synced_folder "./config", "/var/lampVagrant/config", :mount_options => [ "dmode=777", "fmode=666" ]
  syncedFolders = settings["syncedFolders"]
  syncedFolders.each do |localFolder, vmFolder|
    config.vm.synced_folder localFolder, vmFolder
  end
  config.vm.synced_folder "./config/apache2/sites", "/etc/apache2/sites-enabled", :mount_options => [ "dmode=777", "fmode=666" ]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  provider = settings["provider"]
  providerSettings = settings["providers"][provider]
  puts "* Selecting provider #{provider}"
  config.vm.provider provider do |box|
    box.gui = providerSettings["gui"]
    box.memory = providerSettings["memory"]
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Run special commands
  config.vm.provision "run-commands", type: "shell" do |s|
    s.privileged = true
    commands = [
      # Fix tty warning
      "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile",
      # Hide apache2 ServerName warning and custom apache2 config
      "sudo cp /var/lampVagrant/config/apache2/lampVagrant.conf /etc/apache2/conf-available/lampVagrant.conf",
      "sudo a2enconf lampVagrant 2>/dev/null",
      "sudo mkdir -p /usr/lib/php5/20131226"
    ]
    # Build final command
    command = commands.reject(&:empty?).join(' && ') + " && echo 'Copying necessary files ...'"

    # Copy necessary files
    copiedFiles = settings["copy"]
    copiedFiles.each do |copiedFilePath|
      if File.file?(File.join("config", "copy", copiedFilePath))
        originalPath = File.join("var", "lampVagrant", "config", "copy", copiedFilePath)
        command += " && sudo cp /#{originalPath} /#{copiedFilePath}"
      end
    end
    s.inline = command
  end
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "Provision", type: "shell", path: File.join("provision", "provision.sh")
  #======================================
  # Command to install dependencies
  command = "echo '* Checking dependencies ...'"
  # Add custom repositories
  repositories = settings["repositories"]
  repositories.each do |repositoryName|
    command += " && echo 'Adding apt-repo #{repositoryName}' && sudo add-apt-repository -y #{repositoryName} 2>/dev/null"
  end
  # Update packages
  command += " && echo 'Updating packages, please wait...' && sudo apt-get -y update 2>dev>null"
  # Install required packages by scripts
  dependencies = settings["dependencies"]
  dependencies.each do |packageName|
    scriptPath = File.join("provision", "scripts", "install_#{packageName}.sh")
    if File.file?(scriptPath)
      file = File.open(scriptPath, "rb")
      command += file.read
    end
  end
  config.vm.provision "install-dependencies", type: "shell" do |s|
    s.privileged = true
    # Build final command
    s.inline = command
  end
  #======================================
  # End Install required packages by scripts
  # Every scripts after done provisioning should be placed in this file
  config.vm.provision "Post-provision", type: "shell", path: File.join("provision", "provision-post.sh")
end
