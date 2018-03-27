class LexKeyword

  def initialize
    @keywords = [
      'goto'
    ]
  end

  def handle(state, char, tokens)
    if state == :start
      tokens << char
    elsif state == :end_keyword
      state = :start
    end

    if @keywords.include?(tokens)
      state = :end_keyword
    end

    return state, tokens
  end

end
