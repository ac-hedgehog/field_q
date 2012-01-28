require 'config/require_all'

describe Object do
  describe "корректность работы" do
    describe "публичных методов" do
      get_method_should = "метод должен считывать введённую с клавиатуры строку элементов, разделённых separator и возвращать их в виде"
      it get_method_should + "массива" #geta
      it get_method_should + "вектора" #getv
    end
  end
end
