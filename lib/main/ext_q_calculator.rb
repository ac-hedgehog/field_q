require 'config/require_all'

def puts_result(result = nil)
  puts "Результат выражения: #{result}"
end

def dialog(message = nil)
  puts message unless message.nil?
  gets.chomp
end

puts "h\t- справка\n\n"
calculator = ExtQCalculator.new
begin
  command = calculator.click dialog('Введите команду:')
end until command == :quit