require 'config/require_all'

#
# Класс для работы с элементами модуля алгебраического
# расширения поля рациональных чисел вида Q(root^n(D))
#
class ModQ
  
  #============================================================
  # Константы и статические переменные
  #============================================================
  
  #
  # Размерность поля Q(корень n степени из D) по дефолту
  #
  N = 3
  #
  # Собственно, дефолтное значение D для поля Q
  #
  D = 2
  #
  # Массив свойств поля, которые присваиваются каждому
  # новому созданному элементу по-дефолту
  #
  @@default_prop = {:n => N, :d => D}
  #
  # Массив компонент элемента поля
  #
  attr_accessor :comp
  
  #============================================================
  # Конструктор модуля
  #============================================================

  #
  # <div>Создание элемента модуля</div>
  # <div><i>components</i> - коэффициенты при различных степенях
  # корня n-ной степени из D</div>
  # <div><i>properties</i> - общие свойства модуля, которому принадлежит
  # данный элемент</div>
  #
  def initialize(components = Vector[], properties = @@default_prop)
    # Заполняем свойства нового элемента модуля
    self.set_properties properties
    # Заполняем массив компонент элемента модуля
    self.set_components components
  end

  #============================================================
  # Операции в модуле
  #============================================================

  #
  # Не меняет знака элемента
  #
  def +@
    ModQ.new @comp, @prop
  end

  #
  # Противоположный элемент
  #
  def -@
    ModQ.new @comp.map { |component| -component }, @prop
  end

  #
  # Операция сложения
  #
  def +(q)
    operation q, :addition
  end

  #
  # Операция вычитания
  #
  def -(q)
    operation q, :subtraction
  end

  #
  # Операция умножения
  #
  def *(q)
    operation q, :multiplication
  end
  
  #============================================================
  # Статические методы модуля
  #============================================================

  #
  # Изменяет одно из дефолтных свойств
  #
  def self.set_new_default_property(key, property)
    @@default_prop.update key => property.to_i if @@default_prop.has_key? key
  end

  #
  # Изменяет все дефолтные свойства
  #
  def self.set_new_default_properties(properties)
    if properties.is_a? Hash
      properties.each do |key, property|
        self.set_new_default_property key, property
      end
    end
  end
  
  #============================================================
  # Публичные методы модуля
  #============================================================
  public

  #
  # Возвращает все свойства поля
  #
  def get_properties
    @prop
  end
  
  #
  # Возвращает матрицу, определитель которой равен норме элемента
  #
  def matrix_for_norm
    n_matr = Matrix.scalar @prop[:n], @comp.first
    for i in 0..@prop[:n] - 1
      for j in 0..@prop[:n] - 1
        case i
        when 0..j - 1
          n_matr[i, j] = @comp[@prop[:n] + i - j] * @prop[:d]
        when j
          n_matr[i, j] = @comp[0]
        when j+1..@prop[:n] - 1
          n_matr[i, j] = @comp[i - j]
        end
      end
    end
    return n_matr
  end

  #
  # Возвращает норму элемента модуля
  #
  def norm
    self.matrix_for_norm.determinant
  end

  #
  # Численное значение элемента модуля при подстановке d и n
  #
  def value
    value = Rational.new! 0
    d = Rational.new! @prop[:d]
    ind = 0
    @comp.each do |component|
      value += component * d.power2((ind/@prop[:n]).to_f)
      ind += 1
    end
    value
  end

  #
  # Получить сопряжённый элемент для данного
  # (т.е. такой элемент, при умножении на который
  # получается целое число - норма элемента)
  #
  def conjugate
    components = self.matrix_for_norm.inverse *
      Vector.elements(Array.new(@prop[:n]).
      map{ |i| 0 }.fill(self.norm, 0, 1))
    ModQ.new components, @prop
  end

  #
  # Конвертирует элемент модуля в строку
  #
  def to_s
    "< #{@comp.join(", ")} >"
  end

  #
  # Конвертирует элемент модуля в строку (подробная запись)
  #
  def to_full_s
    str = ""
    for i in 0..@prop[:n] - 1
      str += "#{@comp[i]}*(w^#{i}) + "
    end
    str = str.slice(0, str.length - 3)
  end

  #
  # Проверяет, совпадают ли свойства поля с
  # заданным хэшем свойств <i>properties</i>
  #
  def prop_is_equal?(properties)
    return false if !properties.is_a? Hash
    properties.each do |key, property|
      return false if property != @prop[key]
    end
    return true
  end
  
  #============================================================
  # Защищённые методы поля
  #============================================================
  protected

  #
  # Добавляет компоненты новому элементу поля
  #
  def set_components(components = Vector[])
    if (components.is_a?(Vector)||components.is_a?(Array))
      @comp = components.to_a.first @prop[:n]
      for i in 0..@prop[:n] - 1
        @comp[i] = @comp[i].to_i
      end
    else
      @comp = Array.new(@prop[:n]){0}
    end
  end

  #
  # Добавляет свойства поля (только допустимые по-дефолту)
  #
  def set_properties(properties = @@default_prop)
    if properties.is_a? Hash
      @prop = {}
      @@default_prop.each do |key, property|
        @prop[key] = properties[key].nil? ? property : properties[key].to_i
      end
    else
      @prop = @@default_prop
    end
  end

  #============================================================
  # Приватные методы модуля
  #============================================================
  private

  #
  # Процедура складывания в общем виде
  #
  def accession(operation, operand)
    ModQ.new Vector.elements(@comp).send(operation,
      Vector.elements(operand.comp)), @prop
  end

  #
  # Умножение элементов на уровне компонент
  #
  def comp_mult(operand)
    self.matrix_for_norm * Vector.elements(operand.comp)
  end

  #
  # Процедура сложения двух элементов модуля
  #
  def addition(operand)
    accession :+, operand
  end

  #
  # Процедура вычитания двух элементов модуля
  #
  def subtraction(operand)
    accession :-, operand
  end

  #
  # Процедура умножения двух элементов модуля
  #
  def multiplication(operand)
    ModQ.new comp_mult(operand), @prop
  end

  #
  # Некоторая бинарная операция с элементом модуля
  # и некоторым другим произвольным элементом
  #
  def operation(operand, operation = :addition)
    case operand
    when Fixnum, Bignum
      operand = ModQ.new [ operand ], @prop
    when ModQ
      if !self.prop_is_equal? operand.get_properties
        FieldQError.op_diff_modules
      end
    else
      FieldQError.op_diff_types
    end
    send operation, operand
  end

end