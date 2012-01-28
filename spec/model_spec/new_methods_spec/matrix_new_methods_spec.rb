require 'config/require_all'

describe Matrix do
  before(:each) do
    @matrix = Matrix[*[[0, 0], [0, 0]]]
  end
  
  describe "корректность работы" do
    describe "публичных методов" do
      it "метод должен сделать удобным присваивание значения элементам матрицы" do
        @matrix[0, 0] = 1
        @matrix[0, 0].should == 1
      end
    end
  end
end