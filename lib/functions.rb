class Matrix
    def []=(i, j, value)
        @rows[i][j] = value
    end
end

def geta (pattern = " ")
  gets.chomp.split pattern
end

def getv (pattern = " ")
  Vector.elements geta pattern
end