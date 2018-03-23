require './lexer/lexer'
require './parser/parser'

class ZeroScript

  def initialize(filename)
    @file   = File.open(filename)
    @tokens = []
    @ast    = []
  end

  def lexer
    lexer   = Lexer.new(@file)
    @tokens = lexer.run
  end

  def parser
    parser = Parser.new(@tokens, @ast)
    @ast   = parser.run
  end

  def run
    puts "RUNTIME:"
    puts "--------"

    @ast.each do |ast|
      if ast.class == Hash
        ast.each do |key, value|
          send(key)
        end
      end
    end

    puts "--------\n\n"
  end

  def method_missing(m)
    puts m
  end

end

zero = ZeroScript.new(ARGV[0])
zero.lexer()
zero.parser()
zero.run()
