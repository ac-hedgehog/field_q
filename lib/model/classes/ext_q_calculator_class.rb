def puts_result(result = nil)
  puts "Результат выражения: #{result}"
end

def dialog(message = nil)
  puts message unless message.nil?
  gets.chomp
end

#
# 2) возможность добавления своих настроек для D и n у поля
#

class ExtQCalculator
  def initialize
    set_context :shell
    @stek = []
  end
  def click(command, context = :shell, operand = nil)
    if COMMANDS[context].has_key? command
      set_context context
      if SHELL_COMMANDS.has_key? command
        send COMMANDS[context][command], operand
      else
        COMMANDS[context][command]
      end
    else
      command
    end
  end
  def help(context = nil)
    puts HELP_MESSAGES[@context]
    :help
  end
  def stek(join = nil)
    puts 'Элементы стека:'
    puts @stek.join('; ')
    :stek
  end
  def get_operand(context, message = nil)
    operand = click dialog(message), context
    return operand if operand.is_a? ExtQ
    if !operand.is_a? Symbol
      operand.to_ext_q
    else
      get_operand context, message
    end
  end
  def get_operator(context, message = nil)
    operator = click dialog(message), context
    if (COMMANDS[context].has_value?(operator) &&
        !SHELL_COMMANDS.has_value?(operator))
      operator
    else
      get_operator context, message
    end
  end
  def push(element = nil)
    if element.nil?
      element = get_operand :shell, COMMANDS_MESSAGES[:push]
    end
    puts "Элемент #{element} положен в стек"
    @stek.push element
    :push
  end
  def pop(message = nil)
    element = @stek.pop
    puts element
    element
  end
  def use_result(result, context = :shell)
    use = click dialog(COMMANDS_MESSAGES[:uses])
    if use == 'y'
      result = result.to_ext_q
      puts "Используемый элемент: #{result}"
      click dialog(COMMANDS_MESSAGES[:shell]), :shell, result
    else
      context
    end
  end
  def binary(first = nil)
    if first.nil?
      first = get_operand :binary, COMMANDS_MESSAGES[:binary]
    else
      puts first
    end
    operator = get_operator :binary
    second = get_operand :binary
    result = first.send operator, second
    puts_result result
    use_result result, :binary
  end
  def unary(operand = nil)
    operator = get_operator :unary, COMMANDS_MESSAGES[:unary]
    if operand.nil?
      operand = get_operand :unary
    else
      puts operand
    end
    result = operand.send operator
    puts_result result
    use_result result, :unary
  end
  def quit(message = nil)
    if @context == :shell
      puts 'Всего доброго!'
    else
      puts 'Пожалуйста, завершите операцию!'
    end
    :quit
  end
  private
  def set_context(context)
    @context = context if context != :help
  end
end