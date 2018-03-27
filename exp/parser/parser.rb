class Parser

  def initialize(tokens, ast)
    @tokens = tokens
    @ast    = ast
  end

  def run
    @tokens.each do |token|
      if token[:id] == :string
        @ast << {token[:value] => nil}
      elsif token[:id] == :keyword
        @ast << {token[:value] => nil}
      end
    end

    return @ast
  end

end
