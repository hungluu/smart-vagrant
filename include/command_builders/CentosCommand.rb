#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Command builder
require_relative "BaseCommand"

class CentosCommand < BaseCommand
  ######################
  # Command generators #
  ######################
  # Generate apt-get install
  def install (package_list, params = '-q -y')
    package_names = resolve_packages(package_list.reject(&:empty?).join(" "))
    "yum #{params} install #{package_names} >/dev/null 2>/dev/null"
  end

  # Install an apt repo
  def add_repo (repository_url)
    "rpm -Uvh --quiet #{repository_url} >/dev/null 2>/dev/null"
  end

  # Generate apt-get update
  def update (params = '-q -y')
  end

  # Generate apt-get update
  def clean_up (params = '-q -y')
  end

  # Restart a service
  def restart_service (service_name)
    "systemctl restart #{service_name}"
  end

  # Start a service
  def start_service (service_name)
    "systemctl start #{service_name}"
  end

  # Stop a service
  def stop_service (service_name)
    "systemctl stop #{service_name}"
  end
end
