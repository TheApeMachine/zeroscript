require './lexer/lexcomment'
require './lexer/lexstring'
require './lexer/lexlabel'
require './lexer/lexkeyword'

class Lexer

  def initialize(file)
    @file     = file
    @state    = :start
    @tokens   = []
    @keywords = [
      'goto',
      'stop'
    ]
  end

  def run
    token = []

    @file.each_char do |char|
      case @state
      when :start
        if char == '"'
          token  = []
          @state = :readchar
        else
          if !["\n"].include?(char)
            token << char
            @state = :readchar
          end
        end
      when :readchar
        if char == '"'
          if token.join != '  '
            @tokens << {id: :string, value: token.join}
          end

          token  = []
          @state = :start
        elsif @keywords.include?(token.join)
          @tokens << {id: :keyword, value: token.join}
          token    = []
          @state   = :readarg
        elsif char == ":"
          @tokens << {id: :label, value: token.join}
          token    = []
          @state   = :start
        elsif token.join.to_i.to_s == token.join
          @tokens << {id: :integer, value: token.join.to_i}
          token    = []
        elsif token.join == '+'
          @tokens << {id: :operation, value: :add}
          token    = []
        else
          if !["\n"].include?(char)
            token << char
            @state = :readchar
          end
        end
      when :readarg
        if char == ' '
          @tokens << {id: :arg, value: token.join}
          token    = []
          @state   = :readarg
        else
          if !["\n"].include?(char)
            token << char
            @state = :readarg
          else
            @tokens << {id: :arg, value: token.join}
            token    = []
            @state   = :start
          end
        end
      end
    end

    return @tokens
  end

end
