require 'config/require_all'

#
# Сделать некоторый интерфейс для простейшего калькулятора в поле
# с вычислением цепных дробей и стеком, работающим через методы
# push и pull
#

ModQ.set_new_default_properties :d => 2, :n => 3

q = ModQ.new [0, 1, 2]

puts q