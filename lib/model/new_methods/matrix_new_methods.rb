class Matrix

  #
  # <div>Позволяет обращаться к элементам матрицы и изменять их
  # путём присваивания следующим образом:</div>
  # <div>matrix[i, j] = value</div>
  #
  def []=(i, j, value)
    @rows[i][j] = value
  end
  
end