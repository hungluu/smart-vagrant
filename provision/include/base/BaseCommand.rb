#======================================
# Sweet-Vagrant
# @copyright : Hung Luu (c) 2017
#======================================
# Command builder
class BaseCommand
  def initialize
    # Store commands
    @commands = []
    # Store position in INSERT mode
    @inserting_position = false
    # Store transaction
    @transaction = nil
  end

  ######################
  # Command generators #
  ######################
  # Generate create file command
  def create_file (file_path)
    "touch '#{file_path}'"
  end

  # Generate copy command
  def copy (source_path, dest_path)
    "cp -arf '#{source_path}' '#{dest_path}'"
  end

  # Generate copy command
  def remove (remove_path)
    "rm -rf '#{remove_path}'"
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
  def echo (message, params = [])
    sprintf("echo '#{message}'", *params)
  end

  # Generate echo command
  def warning (message, params = [])
    echo("WARNING: #{message}", params)
  end

  # Create command with privileged
  def sudo (command)
    "sudo #{command}"
  end

  # Check if file exists
  def check_file_existence (file_path)
    "[ -f '#{file_path}' ]"
  end

  # Join multiple commands
  def join_commands(params, glue = " && ")
    params.reject(&:empty?).join(glue)
  end

  # Quote a command
  def quote(command)
    "'#{command}'"
  end

  # Build if statements
  def make_if(if_condtion, if_statement, else_statement = nil, elseif_statements = {})
    commands = []
    commands.push(" if #{if_condtion}; then #{if_statement}; ")

    elseif_statements.each do |condition, statement|
      commands.push(" elif #{condition}; then #{statement}; ")
    end

    if else_statement.to_str.empty?
      commands.push(" fi ")
    else
      commands.push(" else #{else_statement}; fi ")
    end

    commands.join
  end

  ###################
  # Builder methods #
  ###################
  # Get final command
  def get
    to_array.join("\r\n")
  end

  # Convert to array
  def to_array
    @commands.reject(&:empty?)
  end

  # Alias of get
  def to_str
    get
  end

  # Add a message into queue
  def push_warning (message, params = [])
    push(warning(message, params), false)
  end

  # Add a message into queue
  def push_message (message, params = [])
    push(echo(message, params), false)
  end

  # Add a command into queue
  def push (command, sudo = true)
    if command.nil? || command.empty?
      return
    end

    if sudo === true
      str_command = "sudo #{command}"
    else
      str_command = "#{command}"
    end

    if @transaction.is_a? BaseCommand
      @transaction.push(str_command, sudo)
    elsif @inserting_position === false
      @commands.push(str_command)
    else
      @commands.insert(@inserting_position, str_command)
    end

    return str_command
  end

  # Add a file into queue
  def pushFile (file_path)
    if File.file?(file_path)
      file = File.open(file_path, "rb") # read file contents into string
      @commands.push(file.read)
      file.close # release the file
    end
  end

  # Start INSERT mode
  def begin_insert(position)
    @inserting_position = position
  end

  # End INSERT mode
  def end_insert
    @inserting_position = false
  end

  # Start transaction
  def begin_transaction
    @transaction = self.class.new
  end

  # End transaction
  def end_transaction
    @transaction = nil
  end

  # Get current transaction
  def transaction
    @transaction
  end

  # Commit transaction
  def commit_transaction (position = nil)
    merge(@transaction, position)
  end

  # Merge with other command builder
  def merge (other_command, position = nil)
    if (position.nil?)
      injected_commands = other_command.to_array
      injected_commands.each do |injected_command|
        @commands.push(injected_command);
      end
    else
      injected_commands = other_command.to_array.reverse
      injected_commands.each do |injected_command|
        @commands.insert(position, injected_command);
      end
    end
  end

  # Check if not empty
  def has_commands
    @commands.length > 0
  end

  # Resolve package names
  def resolve_packages(package_names)
    package_names
  end

  # Stop a service
  def stop_service (service_name)
    resolved_service_name = resolve_packages(service_name)
    "service #{resolved_service_name} stop"
  end

  # Start a service
  def start_service (service_name)
    resolved_service_name = resolve_packages(service_name)
    "service #{resolved_service_name} start"
  end

  # Restart a service
  def restart_service (service_name)
    resolved_service_name = resolve_packages(service_name)
    "service #{resolved_service_name} restart"
  end

  # Clean up apts
  def clean_up (params = '-qq')
  end

  # Update apts
  def update (params = '-qq')
  end

  # Upgrade apts
  def upgrade (params = '-qq')
  end
end
