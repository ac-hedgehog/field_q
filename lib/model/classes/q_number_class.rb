require 'config/require_all'

#
# Класс для работы с элементами алгебраических
# расширений поля рациональных чисел вида Q(root^n(D))
#
class QNumber
  
  #============================================================
  # Константы и статические переменные
  #============================================================

  N = 3 # Размерность поля Q(корень n степени из D) по дефолту
  D = 2 # Собственно, дефолтное значение D для поля Q
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
  # Конструктор поля
  #============================================================

  #
  # <div>Создание элемента поля</div>
  # <div><i>components</i> - коэффициенты при различных степенях
  # корня n-ной степени из D</div>
  # <div><i>properties</i> - общие свойства поля, которому принадлежит
  # данный элемент</div>
  #
  def initialize (components = Vector[], properties = @@default_prop)
    # Заполняем свойства нового элемента поля
    self.set_properties properties
    # Заполняем массив компонент элемента поля
    self.set_components components
  end

  #============================================================
  # Операции в поле
  #============================================================

  #
  # Не меняет знака элемента
  #
  def +@
    QNumber.new @comp, @prop
  end

  #
  # Противоположный элемент поля
  #
  def -@
    QNumber.new @comp.map { |component| -component }, @prop
  end

  #
  # Операция сложения в поле
  #
  def +(q)
    operation q, :addition
  end

  #
  # Операция вычитания в поле
  #
  def -(q)
    operation q, :subtraction
  end

  #
  # Операция умножения в поле
  #
  def *(q)
    operation q, :multiplication
  end
  
  #============================================================
  # Статические методы поля
  #============================================================

  #
  # Изменяет одно из дефолтных свойств поля
  #
  def self.set_new_default_property (key, property)
    @@default_prop.update key => property.to_i if @@default_prop.has_key? key
  end

  #
  # Изменяет все дефолтные свойства поля
  #
  def self.set_new_default_properties (properties)
    if properties.is_a? Hash
      properties.each do |key, property|
        QNumber.set_new_default_property key, property
      end
    end
  end
  
  #============================================================
  # Публичные методы
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
  # Возвращает норму элемента поля
  #
  def norm
    self.matrix_for_norm.determinant
  end

  #
  # Численное значение элемента поля при подстановке d и n
  #
  def value
    value = Rational.new! 0
    d = Rational.new! @prop[:d]
    ind = 0
    @comp.each do |component|
      value += component * d.power2((ind/@prop[:n]).to_f)
      ind += 1
    end
    return value
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
    QNumber.new components, @prop
  end

  #
  # Конвертирует элемент поля в строку
  #
  def to_s
    "< #{@comp.join(", ")} >"
  end

  #
  # Конвертирует элемент поля в строку (подробная запись)
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
  def prop_is_equal? (properties)
    return false if !properties.is_a? Hash
    properties.each do |key, property|
      return false if property != @prop[key]
    end
    return true
  end
  
  #============================================================
  # защищённые методы поля
  #============================================================
  protected

  #
  # Добавляет компоненты новому элементу поля
  #
  def set_components (components = Vector[])
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
  def set_properties (properties = @@default_prop)
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
  # Приватные методы поля
  #============================================================
  private

  #
  # Второй операнд бинарной операции над элементами
  # поля, который в обязательном порядке надо сохранить
  # в этой переменной прежде чем выполнять операции
  # с помощью приватных методов addition, subtraction, ...
  #
  @@other_operand = nil

  #
  # Сохранение операнда для бинарных
  # операций между элементами поля
  #
  def set_other_operand(operand)
    @@other_operand = operand
  end

  #
  # Процедура сложения двух элементов поля
  #
  def addition
    return QNumberError.std_error if !@@other_operand.is_a? QNumber
    QNumber.new Vector.elements(@comp) + Vector.elements(@@other_operand.comp), @prop
  end

  #
  # Процедура вычитания двух элементов поля
  #
  def subtraction
    return QNumberError.std_error if !@@other_operand.is_a? QNumber
    QNumber.new Vector.elements(@comp) - Vector.elements(@@other_operand.comp), @prop
  end

  #
  # Процедура умножения двух элементов поля
  #
  def multiplication
    return QNumberError.std_error if !@@other_operand.is_a? QNumber
    QNumber.new self.matrix_for_norm * Vector.elements(@@other_operand.comp), @prop
  end

  #
  # Некоторая бинарная операция с элементом поля
  # и некоторым другим произвольным элементом
  #
  def operation (operand, operation = :addition)
    case operand
    when Numeric
      set_other_operand QNumber.new [ operand ], @prop
      method(operation).call
    when QNumber
      if self.prop_is_equal? operand.get_properties
        set_other_operand operand
        method(operation).call
      else
        QNumberError.op_diff_fields
      end
    else
      QNumberError.op_diff_types
    end
  end

end

#
# Класс ошибок, возникающих при работе с элементами поля QNumber
#
class QNumberError

  #
  # <div><i>Ошибка:</i></div>
  # <div>Стандартная ошибка, если не известно
  # конкретно что именно пошло не так</div>
  #
  def self.std_error
    raise NameError.new "Что-то пошло не так"
  end

  #
  # <div><i>Ошибка:</i></div>
  # <div>Типы операндов не соответствуют друг-другу</div>
  #
  def self.op_diff_types
    raise ArgumentError.new "Типы операндов не соответствуют друг-другу"
  end

  #
  # <div><i>Ошибка:</i></div>
  # <div>Операнды принадлежат полям разного типа</div>
  #
  def self.op_diff_fields
    raise ArgumentError.new "Операнды принадлежат полям разного типа"
  end

end