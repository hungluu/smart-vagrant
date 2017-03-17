# -*- mode: ruby -*-
# vi: set ft=ruby :
#======================================
# Lamp-Vagrant
# @author : HR
# @version : 0.1.1
# @copyright : Dumday (c) 2017
#======================================
require_relative "include/LampVagrant"
require_relative "config/Providers"
ssh_port = 2400

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version
Vagrant.configure("2") do |config|
  Dir.glob("config/*.yaml") do |file|
    machine_name = File.basename(file, File.extname(file))
    puts "!Reading file #{file} ..."
    config.vm.define machine_name do |machine|
      puts "***************************************"
      puts "* Configuring '#{machine_name}' ... "

      ssh_port += 1
      machine.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true
      machine.vm.network :forwarded_port, guest: 22, host: ssh_port, auto_correct: true

      lv = LampVagrant.init(machine_name)
      command = lv.command
      # Load configuration
      settings = lv.settings

      ip_prefix = settings["ip_prefix"]

      # The most common configuration options are documented and commented below.
      # For a complete reference, please see the online documentation at
      # https://docs.vagrantup.com.

      # Every Vagrant development environment requires a box. You can search for
      # boxes at https://atlas.hashicorp.com/search.
      machine.vm.box = settings["box"]

      # Disable automatic box update checking. If you disable this, then
      # boxes will only be checked for updates when the user runs
      # `vagrant box outdated`. This is not recommended.
      machine.vm.box_check_update = settings["box_check_update"]

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine. In the example below,
      # accessing "localhost:8080" will access port 80 on the guest machine.
      # machine.vm.network "forwarded_port", guest: 80, host: 8080

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      # machine.vm.network "private_network", ip: "#{ip_prefix}.254"

      # Using ip
      hosts = {}
      private_network_ips = settings["private_network_ips"]
      unless private_network_ips.nil?
        private_network_ips.each do |ip_last_number, host_name|
          ip = "#{ip_prefix}.#{ip_last_number}"
          machine.vm.network "private_network", ip: ip
          unless host_name.nil?
            puts "* #{machine_name}: Using custom private ip #{ip} for #{host_name}"
            hosts[ip] = [host_name]
          else
            puts "* #{machine_name}: Using custom private ip #{ip}"
          end
        end
      end

      ultilities_ip = settings["ultilities_ip"]
      if settings["use_ultilities"] === true
        ip = "#{ip_prefix}.#{ultilities_ip}"
        puts "* #{machine_name}: Using private ip #{ip} for ultilities"
        machine.vm.network "private_network", ip: ip
      end

      # unless machine.multihostsupdater.nil?
      #   machine.multihostsupdater.aliases = hosts
      #   machine.multihostsupdater.remove_on_suspend = true
      # end

      # machine.hostmanager.enabled = true
      # machine.hostmanager.manage_host = true
      # machine.hostmanager.aliases = %w(millionet.dev)

      # Create a public network, which generally matched to bridged network.
      # Bridged networks make the machine appear as another physical device on
      # your network.
      # machine.vm.network "public_network"

      # Share an additional folder to the guest VM. The first argument is
      # the path on the host to the actual folder. The second argument is
      # the path on the guest to mount the folder. And the optional third
      # argument is a set of non-required options.
      machine.vm.synced_folder '.', '/vagrant', disabled: true
      machine.vm.synced_folder '.', '/lamp-vagrant'
      # machine.vm.synced_folder "./config/apache2/sites", "/etc/apache2/sites-available"
      synced_folders = settings["synced_folders"]
      unless synced_folders.nil?
        synced_folders.each do |local_path, vm_path|
          puts "* #{machine_name}: Using synced folder #{local_path}"
          machine.vm.synced_folder local_path, vm_path , mount_options: ["dmode=775", "fmode=664"]
        end
      end
      machine.vm.synced_folder './config/ultilities', '/var/www/ultilities' , mount_options: ["dmode=775", "fmode=664"]

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
      # machine.push.define "atlas" do |push|
      #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
      # end

      require_relative "provision/provision"
      ########################
      # INSTALL DEPENDENCIES #
      ########################

      # Update packages
      command.push_message("Updating packages, please wait...")
      command.push(command.update)

      # Install required packages by scripts
      dependencies = settings["dependencies"]
      unless dependencies.nil?
        dependencies.each do |package_name|
          install_script = File.join(".", "provision", "install", "install_#{package_name}")
          if File.file?("#{install_script}.rb")
            require_relative "#{install_script}"
          elsif File.file?("#{install_script}.sh")
            command.pushFile("#{install_script}.sh")
          else
            lv.push_install_message([package_name])
            command.push(command.install([package_name]))
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
            lv.queue_copy(dest_path)
          end
        end
      end
      # Every scripts after done provisioning should be placed in this file
      require_relative "provision/provision-post"

      command.begin_transaction
        repositories = settings["repositories"]
        unless repositories.nil?
          repositories.each do |repository_name|
            install_script = File.join(".", "provision", "apt-repo", "add_repo_#{repository_name}")
            if File.file?("#{install_script}.rb")
              require_relative "#{install_script}"
            elsif File.file?("#{install_script}.sh")
              command.pushFile("#{install_script}.sh")
            else
              command.push_message("Adding apt-repo #{repository_name} ...")
              command.push(command.add_repo(repository_name))
            end
          end
        end

        command.commit_transaction(1)
      command.end_transaction

      if command.has_commands
        machine.vm.provision "run-commands", type: "shell" do |s|
          s.privileged = true
          # Build final command
          # puts command.to_array
          # exit
          s.inline = command.get
        end

        if dependencies.is_a?(Array) && dependencies.include?("apache2")
          machine.vm.provision "install-apache2-sites", type: "shell", run: "always" do |s|
            s.privileged = true
            # Build final command
            lv = LampVagrant.init(machine_name)
            command = lv.command
            require_relative File.join(".", "provision", "scripts", "install-apache2-sites.rb")
            # puts command.to_array
            # exit
            s.inline = command.get
          end
        end
      else
        puts "* #{machine_name}: [Warning] No command to run"
      end

      puts "*"
    end
  end
end
