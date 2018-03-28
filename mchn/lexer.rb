class Lexer

  attr_reader :tokens, :cur_token

  def initialize
    @cur_token = ""
    @tokens    = []
    @state     = :start
    @keywords  = [
      'stop'
    ]
  end

  def add_char(char)
    case @state
    when :start
      if char.to_i.to_s == char
        build_token(:integer, char.to_i)
      elsif char == '+'
        build_token(:operator, :add)
      end
    end
  end

  def build_token(type, value)
    @tokens << {id: type, value: value}
    @state   = :start
  end

end
