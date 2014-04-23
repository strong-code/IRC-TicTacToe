require 'socket'
require_relative 'ttt.rb'

class CheckersBot

  attr_reader :nick, :chan, :in_game
  attr_accessor :in_game

  def initialize(nick, chan)
    @nick = nick
    @chan = chan
    @in_game = false
  end

  def say(str)
    return if str.nil?
    @socket.puts(str + "\n")
  end

  def say_to_chan(str)
    say("PRIVMSG ##{self.chan} :#{str.strip}")
  end

  def join_chan
    say("JOIN ##{self.chan}")
  end

  def leave_chan(chan)
    say("PART ##{self.chan}")
  end

  def handle_msg(msg)
    text = msg[3..-1].join(" ")[1..-1]

    if text == "!start game"
      new_game()
      self.in_game = true
    elsif self.in_game
      case text
      when /^\!vote\s(\d,\d)$/
        return if !@game.registered_player?(msg[0])
        @game.record_vote(msg[0], /^\!vote\s(\d,\d)/.match(text)[1])
      when /^\!join\s(o|x)$/
        return if @game.registered_player?(msg[0])
        @game.add_player(msg[0], text[-1])
      end
    end

  end

  def new_game()
    @game = TicTacToe.new()
    say_to_chan("New game started! Type !join <x|o> to join a team and !vote [x,y] to vote for a move")
    #
  end

  def run(host, port)
    @socket = TCPSocket.open(host, port)
    say("USER #{self.nick} 0 * #{self.nick}")
    say("NICK #{self.nick}")

    until @socket.eof? do

      msg = @socket.gets
      puts msg
      msg = msg.split

      if msg[0] == "PING"
        say("PONG :pingis")
      elsif msg[1] == "376"
        join_chan
      elsif msg[1] == "PRIVMSG"
        handle_msg(msg)
      end

    end
  end

end

bot = CheckersBot.new("TicTacToeBot", "testchan")
bot.run("irc.rizon.net", 6667)