class LexLabel

  def handle(state, char, tokens)
    if state == :start
      if char == ':'
        state = :end_label
      else
        tokens << char if char != "\n"
      end
    elsif state == :end_label
      if char == "\n"
        state = :start
      end
    end

    return state, tokens
  end

end
