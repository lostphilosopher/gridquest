class Engine
  BASE_NUMBER = 100

  def critical?
    r = rand(1..BASE_NUMBER)
    r == BASE_NUMBER
  end
end
