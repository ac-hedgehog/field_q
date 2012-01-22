require "mathn"
require "functions"

class QNumber
  
  #============================================================
  # Константы и статические переменные
  #============================================================

  N = 3 # Размерность поля Q(корень n степени из D) по дефолту
  D = 2 # Собственно, дефолтное значение D для поля Q
  @@default_prop = {:n => N, :d => D} # Дефолтный массив свойств
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
  # Операция сложения в поле
  #
  def +(q)
    # Операция производится только для элементов одного поля
    if self.prop_is_equal? q.get_properties
      # Складываем и возвращаем результат
      QNumber.new Vector.elements(@comp) + Vector.elements(q.comp), @prop
    else
      raise ArgumentError.new "An attempt to add elements of different types"
    end
  end

  #
  # Операция умножения в поле
  #
  def *(q)
    # Операция производится только для элементов одного поля
    if self.prop_is_equal? q.get_properties
      # Складываем и возвращаем результат
      QNumber.new self.matrix_for_norm * Vector.elements(q.comp), @prop
    else
      raise ArgumentError.new "An attempt to add elements of different types"
    end
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

end