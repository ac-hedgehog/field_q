require 'config/require_all'

describe ExtQ do
  before(:each) do
    @q = ExtQ.new
    @comp = [0, 1, 2]
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
      should_correctly = "элемент должен корректно "
      it should_correctly + "принимать знаменатель - целое число" do
        @q = ExtQ.new [], @denom
        @q.denom.eql? @denom
      end
      it should_correctly + "принимать знаменатель - вещественное число" do
        @q = ExtQ.new [], 2.5
        @q.denom.eql? 2
      end
      it should_correctly + "принимать знаменатель строкового типа" do
        @q = ExtQ.new [], '2 - str'
        @q.denom.eql? 2
      end
      it should_correctly + "сокращать числитель и знаменатель, если это возможно" do
        @q = ExtQ.new [-2, 0, 4], 2
        @q.comp.should == [-1, 0, 2]
        @q.denom.should == 1
      end
    end

  end

  describe "корректность работы" do

    describe "статических методов" do
      # Пока без них
    end

    describe "публичных методов" do
      before(:each) do
        @q = ExtQ.new @comp, @denom
      end
      should_return = "метод должен вернуть "
      it should_return + "численное значение элемента поля при подстановке в него d, n и denom" do
        @q.value.to_s.should == '2.21736157691564'
      end
      it "метод должен конвертировать элемент поля в строку" do
        @q.to_s.should == "< 0, 1, 2 >/< 2 >"
      end
      it "метод должен конвертировать элемент поля в полную строку" do
        @q.to_full_s.should == "(1/2)*(0*(w^0) + 1*(w^1) + 2*(w^2))"
      end
    end

    describe "операций над элементами поля" do
      before(:each) do
        @q = ExtQ.new @comp, @denom
        @p = ExtQ.new [1, 0, -1], 3
      end
      should_return = "операция должна вернуть "
      it "операция никак не должна поменять элемент поля" do
        (+@q).comp.should == @comp
        (+@q).denom.should == @denom
      end
      it should_return + "противоположный элемент поля" do
        (-@q).comp.should == @comp.map { |component| -component }
        (-@q).denom.should == @denom
      end
      it should_return + "сумму элементов поля" do
        (@q + @p).comp.should == [2, 3, 4]
        (@q + @p).denom.should == 6
      end
      it should_return + "разность элементов поля" do
        (@q - @p).comp.should == [-2, 3, 8]
        (@q - @p).denom.should == 6
      end
      it should_return + "произведение элементов поля" do
        (@q * @p).comp.should == [-2, -3, 2]
        (@q * @p).denom.should == 6
      end
      it should_return + "частное элементов поля" do
        (@q / @p).comp.should == [-10, -5, -4]
        (@q / @p).denom.should == 2
      end
    end

  end

end

