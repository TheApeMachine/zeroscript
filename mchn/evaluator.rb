class Evaluator

  attr_reader :state, :memory, :icebox

  def initialize(state, terminal)
    @innerstate = :start
    @state      = state
    @terminal   = terminal
    @memory     = []
    @icebox     = []
    @cur_sub    = -1
  end

  def interpret(char)
    case @innerstate
    when :start
      if char == '+'
        @state  = send(char)
        @memory = []
      elsif char == '-'
        @innerstate = :subzero
      else
        if char != ' '
          if char.to_i.to_s == char
            @memory << char.to_i
          else
            @memory << char
          end
        end

        @state = @memory.join
      end
    when :subzero
      if char == '>'
        subzero
        @cur_sub += 1
        @memory   = []
      end
    end
  end

  def subzero
    @icebox << @memory.join

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

  def +
    @memory.inject(0, :+)
  end

end
