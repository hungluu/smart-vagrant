#======================================
# Sweet-Vagrant
# @copyright : Hung Luu (c) 2017
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
end
