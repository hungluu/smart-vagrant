class BaseServiceCommand
  def self.lv
    return LampVagrant.instance
  end

  def self.command
    return LampVagrant.instance.command
  end
end
