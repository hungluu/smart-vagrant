class BaseServiceCommand
  def self.sweet
    return SmartVagrant::SmartVagrant.instance
  end

  def self.command
    return sweet.command
  end
end
