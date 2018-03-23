class LexComment

  def handle(state, char)
    if state == :start
      if char == '/'
        state = :comment
      end
    elsif state == :comment
      if char == '/'
        state = :comment_single_line
      elsif char == '*'
        state = :comment_block
      end
    elsif state == :comment_single_line
      if char == "\n"
        state = :start
      end
    elsif state == :comment_block
      if char == '*'
        state = :comment_block_closing
      end
    elsif state == :comment_block_closing
      if char == '/'
        state = state
      elsif char == "\n"
        state = :start
      end
    end

    return state
  end

end
