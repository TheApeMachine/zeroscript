#!/usr/bin/ruby -w

require './terminal'

class ZeroMachine

  def initialize(filename=nil)
    @file = File.open(filename) if filename
  end

  def run
    if @file
      # Do the file thing
    else
      terminal = Terminal.new
      terminal.clear_screen
      terminal.color(:magenta, :black)
      terminal.show_cursor
      terminal.color(:yellow, :black)
      terminal.echo("(")
      terminal.move_to(3, 0)
      terminal.echo(")")
      terminal.move_to(2, 3)
      terminal.color(:white, :black)
      terminal.run
      terminal.clear_screen
    end
  end

end

zeromachine = ZeroMachine.new
zeromachine.run
