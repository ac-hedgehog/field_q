require 'config/require_all'

#
# Класс для работы с элементами алгебраических
# расширений поля рациональных чисел вида Q(root^n(D))
#
class ExtQ < ModQ

  #============================================================
  # Константы и статические переменные
  #============================================================

  #
  # Знаменатель элементов поля Q(корень n степени из D) по дефолту
  #
  DENOM = 1
  #
  # Знаменатель элемента поля
  #
  attr_accessor :denom

  #============================================================
  # Конструктор поля
  #============================================================

  #
  # <div>Создание элемента поля</div>
  # <div><i>components</i> - коэффициенты при различных степенях
  # корня n-ной степени из D</div>
  # <div><i>denominator</i> - знаменатель элемента поля</div>
  # <div><i>properties</i> - общие свойства поля, которому принадлежит
  # данный элемент</div>
  #
  def initialize(components = Vector[], denominator = DENOM, properties = @@default_prop)
    # Заполняем свойства нового элемента модуля
    self.set_properties properties
    # Добавляем знаменатель
    self.set_denominator denominator
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
    ExtQ.new @comp, @denom, @prop
  end

  #
  # Противоположный элемент
  #
  def -@
    ExtQ.new @comp.map { |component| -component }, @denom, @prop
  end

  #
  # Операция деления
  #
  def /(q)
    operation q, :division
  end

  #============================================================
  # Статические методы модуля
  #============================================================

  # Пока не нужны

  #============================================================
  # Публичные методы модуля
  #============================================================
  public

  #
  # Численное значение элемента модуля при подстановке d и n
  #
  def value
    q = ModQ.new @comp, @prop
    return q.value / @denom
  end

  #
  # Конвертирует элемент модуля в строку
  #
  def to_s
    "< #{@comp.join(", ")} >/< #{@denom} >"
  end

  #
  # Конвертирует элемент модуля в строку (подробная запись)
  #
  def to_full_s
    q = ModQ.new @comp, @prop
    return "(1/#{@denom})*(" + q.to_full_s + ")"
  end

  #============================================================
  # Защищённые методы поля
  #============================================================
  protected

  #
  # Добавляет знаменатель элементу поля
  #
  def set_denominator(denominator = DENOM)
    if (denominator.is_a?(Fixnum)||denominator.is_a?(Bignum))
      @denom = denominator
    else
      @denom = DENOM
    end
  end

  #============================================================
  # Приватные методы модуля
  #============================================================
  private

  #
  # Процедура сложения двух элементов поля
  #
  def addition
    self #ExtQ.new Vector.elements(@comp) + Vector.elements(@@other_operand.comp), @denom, @prop
  end

  #
  # Процедура вычитания двух элементов поля
  #
  def subtraction
    self #ExtQ.new Vector.elements(@comp) - Vector.elements(@@other_operand.comp), @denom, @prop
  end

  #
  # Процедура умножения двух элементов поля
  #
  def multiplication
    self #ExtQ.new self.matrix_for_norm * Vector.elements(@@other_operand.comp), @denom * @@other_operand.denom, @prop
  end

  #
  # Процедура деления одного элемента поля на другой
  #
  def division
    self
  end

  #
  # Некоторая бинарная операция с элементом модуля
  # и некоторым другим произвольным элементом
  #
  def operation(operand, operation = :addition)
    case operand
    when Fixnum, Bignum
      set_other_operand ExtQ.new [ operand * @denom ], @denom, @prop
      method(operation).call
    when ModQ, ExtQ
      # Если умножаем элемент поля на элемент модуля
      # - приводим элемент модуля к элементу поля
      if operand.is_a? ModQ
        operand *= @denom
        operand = ExtQ.new operand.comp, @denom, operand.get_properties
      end
      if self.prop_is_equal? operand.get_properties
        set_other_operand operand
        method(operation).call
      else
        FieldQError.op_diff_fields
      end
    else
      FieldQError.op_diff_types
    end
  end

end
