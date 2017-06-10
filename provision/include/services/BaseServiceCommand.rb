class BaseServiceCommand
  def self.sweet
    return SweetVagrant.instance
  end

  def self.command
    return sweet.command
  end
end
