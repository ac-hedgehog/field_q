class ExtQCalculator
  HELP_MESSAGES = {
    :shell  => "
==================================================
Базовые команды калькулятора:
u\t- выполнить некоторую операцию в поле ExtQ с одним операндом
b\t- выполнить некоторую операцию в поле ExtQ с двумя операндами
h\t- вызвать справку с перечнем возможностей текущего окружения
q\t- выйти из калькулятора

Формат ввода элементов поля:
a[1] a[2] ... a[n] / d
Где a[i] - целые компоненты элемента, а d - целый положительный знаменатель
==================================================
    ",
    :unary  => "
==================================================
Возможные операции калькулятора для одного элемента из поля ExtQ:
V()\t- значение элемента при подстановке в него D и n
N()\t- норма элемента
M()\t- матрица, соответствующая элементу
C()\t- сопряжённый данному элемент

Синтаксис ввода операции:
%операция%
%операнд%
==================================================
    ",
    :binary => "
==================================================
Возможные операции калькулятора для двух элементов q и p из поля ExtQ:
q + p\t- сумма элементов поля
q - p\t- разность элементов поля
q * p\t- произведение элементов поля
q / p\t- частное элементов поля

Синтаксис ввода операции:
%первый операнд%
%операция%
%второй операнд%
==================================================
    "
  }
  SHELL_COMMANDS = {
    'h' => :help,
    'u' => :unary,
    'b' => :binary,
    'q' => :quit
  }
  COMMANDS = {
    :shell => SHELL_COMMANDS,
    :unary => SHELL_COMMANDS.merge({
      'V()' => :value,
      'N()' => :norm,
      'M()' => :matrix_for_norm,
      'C()' => :conjugate
    }),
    :binary => SHELL_COMMANDS.merge({
      '+' => :+,
      '-' => :-,
      '*' => :*,
      '/' => :/
    })
  }
  COMMANDS_MESSAGES = {
    :shell  => 'Введите команду:',
    :unary  => 'Введите унарное выражение:',
    :binary => 'Введите бинарное выражение:'
  }
end