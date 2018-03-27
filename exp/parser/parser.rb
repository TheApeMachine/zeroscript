class Parser

  def initialize(tokens, ast)
    @tokens = tokens
    @ast    = ast
    @state  = :start
    @parent = nil
  end

  def run
    @tokens.each_with_index do |token, index|
      case @state
      when :start
        if token[:id] == :keyword
          @ast << {token[:value] => @tokens[index + 1][:value]}
          @state == :skip
        elsif token[:id] == :label
          @ast    << {token[:value] => []}
          @parent  = token[:value]
          @state   = :start
        elsif token[:id] == :string
          if @parent
            @ast.select{
              |a| a[@parent]
            }[0][@parent] << {token[:value] => nil}
          else
            @ast << {token[:value] => nil}
          end
        end
      when :skip
        @state == :start
      end

      # if token[:id] == :string
      #   @ast << {token[:value] => nil}
      # elsif token[:id] == :keyword
      #   @ast << {token[:value] => nil}
      # elsif token[:id] == :label
      #   @ast << {token[:value] => nil}
      # elsif token[:id] == :arg
      #   @ast << {token[:value] => nil}
      # end
    end

    return @ast
  end

end
