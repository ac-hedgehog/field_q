class String
  
  #
  # Конвертировать строку в элемент модуля ModQ
  #
  def to_mod_q(pattern = ' ')
    comp = self.split pattern
    prop = ModQ.get_default_properties
    ModQ.new comp, prop
  end
  
  #
  # Конвертировать строку в элемент поля ExtQ
  # Пока что рассчитано на формат ввода X X X / X
  #
  def to_ext_q(pattern = ' ')
    comp = self.split pattern
    prop = ExtQ.get_default_properties
    denom = comp[prop[:n] + 1].to_i
    denom = (denom == 0)? 1 : denom
    ExtQ.new comp, denom, prop
  end
end

=begin
class Object

  #
  # Считывает введённые с клавиатуры данные в массив
  #
  def geta (separator = " ")
    gets.chomp.split separator
  end

  #
  # Считывает введённые с клавиатуры данные в вектор
  #
  def getv (separator = " ")
    Vector.elements geta separator
  end

end
=end