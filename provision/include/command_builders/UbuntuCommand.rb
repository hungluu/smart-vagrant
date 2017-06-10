#======================================
# Sweet-Vagrant
# @copyright : Hung Luu (c) 2017
#======================================
# Command builder
require_relative "BaseCommand"

class UbuntuCommand < BaseCommand
  ######################
  # Command generators #
  ######################
  # Generate apt-get install
  def install (package_list, params = '-qq')
    package_names = resolve_packages(package_list.reject(&:empty?).join(" "))
    "apt-get #{params} install #{package_names} >/dev/null 2>/dev/null"
  end

  # Install an apt repo
  def add_repo (repository_name)
    "add-apt-repository -y #{repository_name} >/dev/null 2>/dev/null"
  end

  # Generate apt-get update
  def update (params = '-qq')
    "apt-get #{params} update >/dev/null 2>/dev/null"
  end

  # Generate apt-get update
  def clean_up (params = '-qq')
    "apt-get #{params} autoremove >/dev/null 2>/dev/null"
  end
end
