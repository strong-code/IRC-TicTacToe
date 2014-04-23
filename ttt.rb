require 'time'

class TicTacToe

  def initialize
    @team1 = Team.new(:x)
    @team2 = Team.new(:o)
    @board = build_board
    @game_players = {}
    @turn = @team1
  end

  def build_board
    [
      ["-", "-", "-"],
      ["-", "-", "-"],
      ["-", "-", "-"]
    ]
  end

  def print_board
    @board.each do |row|
      row.each do |cell|
        print "#{cell} "
      end
      puts
    end
  end

  def add_player(nick, mark)
    player = (mark == "x" ? Player.new(nick, @team1) : Player.new(nick, @team2))
    @game_players[player] = false
  end

  def registered_player?(nick)
    @game_players.keys.each do |player|
      return true if player.nick == nick
    end
    false
  end

  def get_player(nick)
    @game_players.keys.each {|p| return p if p.nick == nick}
    nil
  end

  def record_vote(nick, pos)
    pos = [pos[0].to_i, pos[2].to_i]
    player = get_player(nick)
    team = player.team

    return if !valid_move?(pos)
    return if player.move
    team.add_vote(pos)
    player.move = pos
    puts "vote recorded!"
  end

  def make_popular_move!
    move = @turn.move_votes.sort_by{|k,v| v}.reverse.first
    place_mark!(move[0], @turn.mark)
    @turn = (@turn == @team1 ? @team2 : @team1)
  end

  def place_mark!(pos, mark)
    @board[pos.first][pos.last] = mark
    print_board
  end

  def valid_move?(pos)
    return if @board[pos.first].nil? || @board[pos.last].nil?
    return true if @board[pos.first][pos.last] == "-"
    false
  end

  def game_won?
    @board.each do |row|
      row.each do |cell|
        return false if cell == "-"
      end
    end

    return true if vertical_win? || horizontal_win? || diag_win?
    false
  end

  def vertical_win?
    #
  end

  def horizontal_win?
    #
  end

  def diag_win?
    #
  end

end

class Team

  attr_reader :mark, :move_votes
  attr_accessor :players

  def initialize(mark)
    @mark = mark
    @players = {}
    @move_votes = {}
  end

  def add_vote(pos)
    if @move_votes[pos]
      @move_votes[pos] += 1
    else
      @move_votes[pos] = 1
    end
  end

end

class Player

  attr_accessor :nick, :team, :move

  def initialize(nick, team)
    @nick = nick
    @team = team
    @move = nil
  end

end