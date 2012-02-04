class ExtQCalculator
  def initialize
    set_context :shell
  end
  def click(command, context = :shell)
    if COMMANDS[context].has_key? command
      set_context context
      send COMMANDS[context][command] if SHELL_COMMANDS.has_key? command
      COMMANDS[context][command]
    else
      command
    end
  end
  def help
    puts HELP_MESSAGES[@context]
  end
  def binary
    first = click dialog(COMMANDS_MESSAGES[:binary]), :binary
    unless first.is_a? Symbol
      first = first.to_ext_q
      operator = click dialog, :binary
      if (COMMANDS[:binary].has_value?(operator) &&
          !SHELL_COMMANDS.has_value?(operator))
        second = click dialog, :binary
        unless second.is_a? Symbol
          second = second.to_ext_q
          puts_result first.send operator, second
        end
      end
    end
  end
  def unary
    operator = click dialog(COMMANDS_MESSAGES[:unary]), :unary
    if (COMMANDS[:unary].has_value?(operator) &&
        !SHELL_COMMANDS.has_value?(operator))
      operand = click dialog, :unary
      unless operand.is_a? Symbol
        operand = operand.to_ext_q
        puts_result operand.send operator
      end
    end
  end
  def quit
    puts 'Всего доброго!'
    :quit
  end
  private
  def set_context(context)
    @context = context if context != :help
  end
end