class Evaluator

  attr_reader :state

  def initialize(state)
    @state = state
  end

  def run(ast)
    ast.each do |inst|
      send(inst.keys[0], inst.values[0])
    end
  end

  def operate(values)
    @state = send(values[1], values[0], values[2])
  rescue TypeError
  end

  def add(x, y)
    return x + y
  end

end
