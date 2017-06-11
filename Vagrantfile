# -*- mode: ruby -*-
# vi: set ft=ruby :
#======================================
# Smart-Vagrant
# @author : HR
# @version : 0.1.4
# @copyright : Hung Luu (c) 2017
#======================================
require_relative File.join(".", "provision", "include", "SmartVagrant")
require_relative File.join(".", "config", "Providers")
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

      lv = SmartVagrant.init(machine_name)
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
      # machine.vm.network "private_network", ip: "192.168.1.100"

      # Using ip
      private_network_ips = settings["private_network_ips"]
      unless private_network_ips.nil?
        private_network_ips.each do |ip_last_number, hostname|
          ip = "#{ip_prefix}.#{ip_last_number}"
          machine.vm.network "private_network", ip: ip
          unless hostname.nil?
            puts "* #{machine_name}: Using custom private ip #{ip} for #{hostname}"
            machine.vm.hostname = hostname # May require vagrant-hostsupdater for /etc/hosts auto updated
          else
            puts "* #{machine_name}: Using custom private ip #{ip}"
          end
        end
      end

      public_network_ips = settings["public_network_ips"]
      unless public_network_ips.nil?
        public_network_ips.each do |ip_last_number|
          ip = "#{ip_last_number}"
          machine.vm.network "public_network", ip: ip
          puts "* #{machine_name}: Using custom public ip #{ip}"
        end
      end

      ultilities_ip = settings["ultilities_ip"]
      if settings["use_ultilities"] === true
        ip = "#{ip_prefix}.#{ultilities_ip}"
        puts "* #{machine_name}: Using private ip #{ip} for ultilities"
        machine.vm.network "private_network", ip: ip
      end

      # Create a public network, which generally matched to bridged network.
      # Bridged networks make the machine appear as another physical device on
      # your network.
      # machine.vm.network "public_network"

      # Share an additional folder to the guest VM. The first argument is
      # the path on the host to the actual folder. The second argument is
      # the path on the guest to mount the folder. And the optional third
      # argument is a set of non-required options.
      machine.vm.synced_folder ".", "/vagrant", disabled: true
      machine.vm.synced_folder ".", "/smart-vagrant"
      # machine.vm.synced_folder "./config/apache2/sites", "/etc/apache2/sites-available"
      synced_folders = settings["synced_folders"]
      unless synced_folders.nil?
        synced_folders.each do |local_path, vm_path|
          puts "* #{machine_name}: Using synced folder #{local_path}"
          machine.vm.synced_folder local_path, vm_path , mount_options: ["dmode=775", "fmode=664"]
        end
      end
      machine.vm.synced_folder File.join(".", "config", "ultilities"), "/var/www/ultilities" , mount_options: ["dmode=775", "fmode=664"]

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

      require_relative File.join(".", "provision", "provision")
      ########################
      # INSTALL DEPENDENCIES #
      ########################

      # Update packages
      command.push_message("Updating packages, please wait...")
      command.push(command.update)

      require_relative "provision/packages/Apache2"
      require_relative "provision/packages/Php"
      test = SmartVagrantPackage::Apache2.new(lv)
      test.do_install
      test = SmartVagrantPackage::Php.new(lv)
      test.do_install
      puts command.to_array
      exit

      # Install required packages by scripts
      dependencies = settings["dependencies"]
      unless dependencies.nil?
        dependencies.each do |package_name|
          lv.install_package(package_name)
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
      require_relative File.join(".", "provision", "provision-post")

      command.begin_transaction
        repositories = settings["repositories"]
        unless repositories.nil?
          repositories.each do |repository_name|
            lv.install_apt_repo(repository_name)
          end
        end

        command.commit_transaction(1)
      command.end_transaction

      if command.has_commands
        machine.vm.provision "install-dependencies", type: "shell" do |s|
          s.privileged = true
          # Build final command
          # puts command.to_array
          # exit
          s.inline = command.get
        end

        lv = SmartVagrant.init(machine_name)
        command = lv.command

        # Run all scripts
        scripts = settings["scripts"]
        unless scripts.nil?
          scripts.each do |script_name|
            lv.run_script(script_name)
          end
        end

        if dependencies.is_a?(Array) && dependencies.include?("apache2")
          lv.run_script("install-apache2-sites")
        end
        machine.vm.provision "run-scripts", type: "shell", run: "always" do |s|
          s.privileged = true
          # Build final command
          s.inline = command.get
        end
      else
        puts "* #{machine_name}: [Warning] No command to run"
      end

      puts "*"
    end
  end
end
