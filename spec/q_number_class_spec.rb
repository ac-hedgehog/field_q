require 'config/require_all'

describe QNumber do

  before(:each) do
    @q = QNumber.new
    @d = 2; @n = 3
    @def_comp = [ 0, 0, 0 ]
    @comp = [ 0, 1, 2 ]
    @def_prop = { :d => @d, :n => @n }
    @prop = @def_prop
  end
  
  describe "корректность создания" do

    describe "пустого элемента поля" do
      it "элемент должен иметь корректный набор компонент" do
        @q.comp.eql? @def_comp
      end
      it "поле должно иметь корректные параметры (свойства)" do
        @q.get_properties.eql? @def_prop
      end
    end
    
    describe "нового элемента поля с параметрами" do
      before(:each) do
        @new_comp = @comp
        @new_prop = { :d => 0, :n => 1 }
      end
      should_correctly = "элемент должен корректно принимать "
      it should_correctly + "массив целых компонент" do
        @q = QNumber.new @new_comp
        @q.comp.eql? @new_comp
      end
      it should_correctly + "вектор целых компонент" do
        @q = QNumber.new Vector[*@new_comp]
        @q.comp.eql? @new_comp
      end
      it should_correctly + "неполный массив целых компонент" do
        @q = QNumber.new @new_comp.delete_at @new_comp.count - 1
        @q.comp.eql? @new_comp.fill @new_comp.count - 1, 0, 1
      end
      it should_correctly + "переполненный массив целых компонент" do
        @q = QNumber.new @new_comp.concat [ 3 ]
        @q.comp.eql? @new_comp
      end
      it should_correctly + "массив не целых компонент" do
        @q = QNumber.new [ nil, 1.5, "2 - str" ]
        @q.comp.eql? @new_comp
      end
      it should_correctly + "хеш целых свойств поля" do
        @q = QNumber.new [], @new_prop
        @q.get_properties.eql? @new_prop
      end
      it should_correctly + "неполный хеш целых свойств поля" do
        @q = QNumber.new [], @new_prop.delete(:n)
        @q.get_properties.eql? @new_prop.merge :n => @n
      end
      it should_correctly + "переполненный хеш целых свойств поля" do
        @q = QNumber.new [], @new_prop.merge({ :p => 2 })
        @q.get_properties.eql? @new_prop
      end
      it should_correctly + "хеш не целых свойств поля" do
        @q = QNumber.new [], :d => nil, :n => "1 - str"
        @q.get_properties.eql? @new_prop
      end
    end

  end

  describe "корректность работы" do

    describe "статических методов" do
      it "метод должен изменить размерность поля n" do
        QNumber.set_new_default_property :n, @n + 1
        QNumber.new.get_properties[:n].should == @n + 1
      end
      it "метод не должен добавлять полю никакого нового свойства" do
        QNumber.set_new_default_property :p, 0
        QNumber.new.get_properties[:p].should == nil
      end
      it "метод должен заменить свойства поля на новые" do
        QNumber.set_new_default_properties @prop.update :n => @n + 1
        QNumber.new.get_properties.should == @prop
      end
      it "метод не должен добавлять полю никаких новых свойств" do
        QNumber.set_new_default_properties @prop.merge :p => 0
        QNumber.new.get_properties.should == @prop
      end
    end

    describe "публичных методов" do
      before(:each) do
        @q = QNumber.new @comp
      end
      should_return = "метод должен вернуть "
      it should_return + "массив всех свойств поля" do
        @q.get_properties.should == @prop
      end
      it should_return + "матрицу элемента поля" do
        @q.matrix_for_norm.should == Matrix[*[[0, 4, 2], [1, 0, 4], [2, 1, 0]]]
      end
      it should_return + "норму элемента поля" do
        @q.norm.should == 34
      end
      it "метод должен конвертировать элемент поля в строку" do
        @q.to_s.should == "< 0, 1, 2 >"
      end
      it "метод должен конвертировать элемент поля в полную строку" do
        @q.to_full_s.should == "0*(w^0) + 1*(w^1) + 2*(w^2)"
      end
      it should_return + "true при сравнении свойств поля элемента с соответствующим хэшем свойств" do
        @q.prop_is_equal?(@prop).should be_true
      end
      it should_return + "false при сравнении свойств поля элемента с несооветствующим хэшем свойств" do
        @q.prop_is_equal?(@prop.merge :d => @d + 1).should be_false
      end
      it should_return + "false при сравнении свойств поля элемента с неполным хэшем свойств" do
        @q.prop_is_equal?(@prop.delete :d ).should be_false
      end
      it should_return + "false при сравнении свойств поля элемента с переполненным хэшем свойств" do
        @q.prop_is_equal?(@prop.merge :p => 0).should be_false
      end
    end

    describe "операций над элементами поля" do
      before(:each) do
        @q = QNumber.new @comp
        @p = QNumber.new @comp
        @r = QNumber.new [], @prop.merge({ :d => @d + 1 })
      end
      it "операция должна вернуть сумму элементов поля" do
        (@q + @p).comp.should == @comp.map { |comp| comp * 2 }
      end
      it "операция должна вернуть противоположный данному элемент поля" do
        (-@q).comp.should == @comp.map { |comp| -comp }
      end
      it "операция должна вернуть разность элементов поля" do
        (@q - @p).comp.should == @def_comp
      end
      it "операция должна вернуть произведение элементов поля" do
        (@q * @p).comp.should == [ 8, 8, 1 ]
      end
      it "операция должна создать исключение если элементы принадлежат различным полям" do
        expect{@q + @r}.to raise_error ArgumentError
      end
    end

  end
  
end

