#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
# Command builder
class CommandBuilder
  def initialize
    @commands = []
  end

  ######################
  # Command generators #
  ######################
  # Generate apt-get install
  def install (package_name, message = false)
    if message != true
      "apt-get -y -qq install #{package_name} 2>/dev/null"
    else
      "apt-get -y install #{package_name}"
    end
  end

  # Generate apt-get update
  def update (message = false)
    if message != true
      "apt-get -y -qq update 2>/dev/null"
    else
      "apt-get -y update"
    end
  end

  # Generate copy folder command
  def copy_folder (source_path, dest_path)
    "cp -a '#{source_path}/.' '#{dest_path}'"
  end

  # Generate copy command
  def copy (source_path, dest_path)
    "cp -rf '#{source_path}' '#{dest_path}'"
  end

  # Generate create folder command
  def create_folder (folder_path, params = "-p")
    "mkdir #{params} '#{folder_path}'"
  end

  # Generate a move command
  def move (source_path, dest_path)
    "mv '#{source_path}' '#{dest_path}'"
  end

  # Generate echo command
  def echo (message)
    "echo '#{message}'"
  end

  # Generate create file command
  def create_file (file_path)
    "touch '#{file_path}'"
  end

  ###################
  # Builder methods #
  ###################
  # Get final command
  def get
    @commands.reject(&:empty?).join("\r\n")
  end

  # Alias of get
  def to_str
    get
  end

  # Add a message into queue
  def pushMessage (message)
    push(echo(message), false)
  end

  # Add a command into queue
  def push (command, sudo = true)
    if sudo === true
      str_command = "sudo #{command}"
    else
      str_command = "#{command}"
    end

    @commands.push(str_command)
    return str_command
  end

  # Add a file into queue
  def pushFile (file_path)
    if File.file? file_path
      file = File.open(file_path, "rb") # read file contents into string
      @commands.push(file.read)
      file.close # release the file
    end
  end
end
