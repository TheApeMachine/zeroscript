class Parser

  attr_reader :ast

  def initialize
    @ast    = []
    @state  = :start
  end

  def build_ast(token)
    if token
      case @state
      when :start
        if token[:id] == :integer
          @ast   << {operate: [token[:value]]}
          @state  = :operate
        elsif token[:id] == :subzero
          @ast   << {token[:value] => []}
          @state  = :subzero
        end
      when :operate
        if token[:id] == :operator
          @ast[0][:operate] << token[:value]
        elsif token[:id] == :integer
          @ast[0][:operate] << token[:value]
        end
      else
        @state = :start
      end
    end
  end

end
