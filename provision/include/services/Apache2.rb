require_relative "BaseServiceCommand"

class Apache2 < BaseServiceCommand
  # Restart apache2
  def self.restart
    command.push(command.restart_service("apache2"))
  end

  # Start apache2
  def self.start
    command.push(command.start_service("apache2"))
  end

  # Stop apache2
  def self.stop
    command.push(command.stop_service("apache2"))
  end

  # Enable mod
  def self.enable_mod(mod_name)
  end

  # Enable site
  def self.enable_site(site_name)
    apache2_folder = command.resolve_packages("apache2")
    command.push(command.copy("/sweet-vagrant/config/apache2/sites/#{site_name}.conf", "/etc/#{apache2_folder}/sites-enabled/#{site_name}.conf"))
  end
end
