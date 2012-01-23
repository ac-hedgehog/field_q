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