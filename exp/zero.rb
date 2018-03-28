#!/usr/bin/ruby -w

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

    if !@tokens.empty?
      puts "\nTOKENS:"
      puts "--------"
      puts @tokens
      puts "--------\n"
    end
  end

  def parser
    parser = Parser.new(@tokens, @ast)
    @ast   = parser.run

    puts "\nAST:"
    puts "--------"
    puts @ast
    puts "--------\n\n"
  end

  def run(ast=@ast)
    if ast.class == Array
      ast.each do |a|
        if a.class == Hash
          key = a.keys[0]
          val = a.values[0]

          send(key, val)
        end
      end
    elsif ast.class == Hash
      if ast.values[0].class == Array
        run(ast.values[0])
      end
    end
  end

  def goto(label)
    run(@ast.select{|a| a[label]}.first)
  end

  def stop(code)
    exit
  end

  def method_missing(m, *args)
    puts "#{m} #{args.join(' ')}".strip
  end

end

zero = ZeroScript.new(ARGV[0])
zero.lexer()
zero.parser()

puts "RUNTIME:"
puts "--------"
zero.run()
puts "--------\n\n"
