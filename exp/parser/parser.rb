class Parser

  def initialize(tokens, ast)
    @tokens = tokens
    @ast    = ast
  end

  def run
    @tokens.each do |token|
      if token[:id] == :char
        @ast << {token[:value] => nil}
      end
    end

    puts "\nAST:"
    puts "--------"
    puts @ast
    puts "--------\n\n"

    return @ast
  end

end
