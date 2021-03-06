class LexString

  def handle(state, char, tokens)
    if state == :start
      if char == '"'
        state = :start_string
      end
    elsif state == :start_string
      if char == '"'
        state = :end_string
      else
        tokens << char if char != "\n"
      end
    elsif state == :end_string
      if char == "\n"
        state = :start
      end
    end

    return state, tokens
  end

end
