class BaseServiceCommand
  def self.lv
    return SweetVagrant.instance
  end

  def self.command
    return SweetVagrant.instance.command
  end
end
