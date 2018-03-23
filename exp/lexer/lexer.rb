require './lexer/lexcomment'
require './lexer/lexstring'

class Lexer

  def initialize(file)
    @file       = file
    @lexcomment = LexComment.new
    @lexstring  = LexString.new
    @state      = :start
    @tokens     = []
  end

  def run
    token = []

    @file.each_char do |char|
      if @state == :end_string && !token.empty?
        @tokens << {id: :char, value: token.join}
        token = []
      end

      @state        = @lexcomment.handle(@state, char)
      @state, token = @lexstring.handle(@state, char, token)

      if !@tokens.empty?
        puts "\nTOKENS:"
        puts "--------"
        puts @tokens.inspect
        puts "--------\n"
      end
    end

    return @tokens
  end

end
