require 'config/require_all'

puts "h\t- справка\n\n"
calculator = ExtQCalculator.new
begin
  command = calculator.click dialog(ExtQCalculator.const_get(:COMMANDS_MESSAGES)[:shell])
end until command == :quit