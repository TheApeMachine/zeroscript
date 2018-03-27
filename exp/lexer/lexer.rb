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
      'goto'
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
          @tokens << {id: :string, value: token.join}
          token    = []
          @state   = :start
        elsif @keywords.include?(token.join)
          @tokens << {id: :keyword, value: token.join}
          token    = []
          @state   = :start
        elsif char == ":"
          @tokens << {id: :label, value: token.join}
          token    = []
          @state   = :start
        else
          if !["\n"].include?(char)
            token << char
            @state = :readchar
          end
        end
      end
    end

    return @tokens
  end

end
