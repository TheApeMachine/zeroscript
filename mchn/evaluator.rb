class Evaluator

  attr_reader :state

  def initialize(state, terminal)
    @state    = state
    @terminal = terminal
  end

  def run(ast)
    return if !ast
    
    ast.each do |inst|
      send(inst.keys[0], inst.values[0])
    end
  # rescue => error
  #   @state = error.class
  end

  def operate(values)
    @state = send(values[1], values[0], values[2])
  rescue TypeError
    @state = 'TypeError'
  end

  def add(x, y)
    return x + y
  end

  def method_missing(m, *args)
    @terminal.line_feed

    @terminal.move_to(
      @terminal.cur_pos[0],
      @terminal.cur_pos[1] + 1,
      false
    )

    @terminal.color(:yellow, :black)
    @terminal.echo "("

    @terminal.line_feed

    @terminal.move_to(
      @terminal.cur_pos[0] + 2,
      3,
      false
    )

    @terminal.color(:yellow, :black)
    @terminal.echo ")"
    @terminal.color(:green, :black)
    @terminal.echo ' => '
    @terminal.color(:white, :black)
    @terminal.echo 'null'

    @terminal.move_to(
      @terminal.cur_pos[0] + 1,
      5
    )
  end

end
