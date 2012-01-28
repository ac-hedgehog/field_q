require 'config/require_all'

describe ExtQ do
  before(:each) do
    @q = ExtQ.new
    #@d = 2; @n = 3
    #@def_comp = [ 0, 0, 0 ]
    @comp = [ 0, 1, 2 ]
    #@def_prop = { :d => @d, :n => @n }
    #@prop = @def_prop
    @def_denom = 1
    @denom = 2
  end

  describe "корректность создания" do

    describe "пустого элемента поля" do
      it "элемент должен иметь знаменатель по умолчанию равный единице" do
        @q.denom.eql? @def_denom
      end
    end

    describe "нового элемента поля с параметрами" do
      should_correctly = "элемент должен корректно принимать "
      it should_correctly + "знаменатель - целое число" do
        @q = ExtQ.new [], @denom
        @q.denom.eql? @denom
      end
      it should_correctly + "знаменатель - вещественное число" do
        @q = ExtQ.new [], 2.5
        @q.denom.eql? 2
      end
      it should_correctly + "знаменатель строкового типа" do
        @q = ExtQ.new [], '2 - str'
        @q.denom.eql? 2
      end
    end

  end

  describe "корректность работы" do

    describe "статических методов" do
      # Пока без них
    end

    describe "публичных методов" do
      before(:each) do
        @q = ModQ.new @comp, @denom
      end
      should_return = "метод должен вернуть "
      it should_return + "численное значение элемента поля при подстановке в него d, n и denom" do
        @q.value.to_s.should == '2.21736157691563'
      end
      it "метод должен конвертировать элемент поля в строку" do
        @q.to_s.should == "< 0, 1, 2 >/<2>"
      end
      it "метод должен конвертировать элемент поля в полную строку" do
        @q.to_full_s.should == "(1/2)*(0*(w^0) + 1*(w^1) + 2*(w^2))"
      end
    end

    describe "операций над элементами поля" do
      it "операция должна вернуть сумму элементов поля"
      it "операция должна вернуть разность элементов поля"
      it "операция должна вернуть произведение элементов поля"
      it "операция должна вернуть частное элементов поля"
    end

  end

end

