require_relative "BaseServiceCommand"

class Composer < BaseServiceCommand
  def self.install(path = nil)
    if path.nil?
      command.push("(sudo composer install)", false)
    else
      command.push("(cd /#{path} && sudo composer install)", false)
    end
  end
end
