#
# Класс ошибок, возникающих при работе с классами поля FieldQ
#
class FieldQError

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
  # <div>Операнды принадлежат модулям разного типа</div>
  #
  def self.op_diff_modules
    raise ArgumentError.new "Операнды принадлежат модулям разного типа"
  end

  #
  # <div><i>Ошибка:</i></div>
  # <div>Операнды принадлежат полям разного типа</div>
  #
  def self.op_diff_fields
    raise ArgumentError.new "Операнды принадлежат полям разного типа"
  end

end
