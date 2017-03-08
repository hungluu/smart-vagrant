#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Provider config
class Providers
  # Config VirtualBox
  def virtualbox(box, vm)
    # Display the VirtualBox GUI when booting the machine
    box.gui = false
    # Customize the amount of memory on the VM:
    box.memory = 1024
  end

  def self.select(config, provider)
    puts "* Selecting provider #{provider}"
    provider_control = new
    config.vm.provider provider do |box, vm|
      case provider
      when "virtualbox"
        provider_control.virtualbox(box, vm)
      end
    end
  end
end
