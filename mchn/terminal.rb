require "io/console"
require "io/wait"

require './lexer'
require './parser'
require './evaluator'

class Terminal

  attr_accessor :cur_pos

  def initialize
    @lstate    = nil
    @cstate    = :null
    @lexer     = Lexer.new
    @parser    = Parser.new
    @evaluator = Evaluator.new(@cstate, self)
    @csi       = "\e["
    @cursor    = "zero -> "
    @cur_pos   = [0, 0]
    @colors    = {
      black:   0,
      red:     1,
      green:   2,
      yellow:  3,
      blue:    4,
      magenta: 5,
      cyan:    6,
      white:   7
    }
  end

  def interpret(char)
    case char.ord
    when 13
      move_to(@cur_pos[0] + 1, 0)
      color(:black, :black)
      echo " "
      move_to(@cur_pos[0] + 1, 0)
      color(:yellow, :black)
      echo ")"

      color(:green, :black)
      echo " => "
      color(:white, :black)
      echo @cstate

      move_to(@cur_pos[0] - 1, 3)
      clear_line
      color(:white, :black)
    when 127
      move_to(@cur_pos[0], @cur_pos[1] - 1)
      echo ' '
      move_to(@cur_pos[0], @cur_pos[1])
    else
      echo(char)
      @cur_pos = [@cur_pos[0], @cur_pos[1] + 1]

      # @lexer.add_char(char)
      # # debug(@lexer.tokens)
      #
      # @parser.build_ast(@lexer.tokens.pop)
      # debug(@parser.ast)

      # @evaluator.run(@parser.ast)

      @evaluator.interpret(char)
      @cstate = @evaluator.state
      debug(@evaluator.icebox)
    end
  end

  def run
    $stdin.raw do |io|
      loop do
        char = io.ready? && io.sysread(1)

        if char
          interpret(char)
          break if char == ?\003
        else
          @evaluator.icebox.each do |subzero|
            debug(subzero)
          end

          if @cstate != @lstate
            rows, cols = $stdout.winsize
            move_to(@cur_pos[0] + 1, 3, false)
            color(:green, :black)
            echo "=> "
            color(:white, :black)
            clear_line
            echo @cstate
            move_to(@cur_pos[0], @cur_pos[1])
            @lstate = @cstate
          end
        end
      end
    end
  end

  def debug(message)
    rows, cols = $stdout.winsize
    move_to(rows, 0, false)
    color(:white, :red)
    echo message
    color(:white, :black)
    move_to(@cur_pos[0], @cur_pos[1])
  end

  def echo(char)
    $stdout.write char
  end

  def clear_screen
    $stdout.write "#{@csi}2J"
    move_to 1, 1
  end

  def clear_line
    $stdout.write "#{@csi}0K"
  end

  def line_feed
    move_to(@cur_pos[0] + 1, 0, false)
    clear_line
    move_to(@cur_pos[0] + 3, 0, false)
    color(:yellow, :black)
    echo ")"
    color(:green, :black)
    echo " => "
    color(:white, :black)
    echo @cstate

    move_to(@cur_pos[0], @cur_pos[1])
  end

  def reset
    $stdout.write("#{@csi}0m")
  end

  def show_cursor
    $stdout.write @cursor
  end

  def move_to(top, left, save=true)
    $stdout.write "#{@csi}#{top};#{left}H"
    @cur_pos = [top, left] if save
  end

  def color(fore, back)
    f = @colors[fore] + 30
    b = @colors[back] + 40

    $stdout.write "#{@csi}#{f};#{b}m"
  end

end
