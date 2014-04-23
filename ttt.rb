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
    return if !valid_move?(pos)

    player = get_player(nick)
    return if player.move

    player.team.add_vote(pos)
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
    cols = []
    (0..2).each do |i|
      cols << [@board[0][i], @board[1][i], @board[2][i]]
    end
    cols.any?{|col| all_values_equal?(col)}
  end

  def horizontal_win?
    @board.rows.any?{|row| all_values_equal?(row))}
  end

  def diag_win?
    diags = [ [@board[0][0], @board[1][1], @board[2][2]], 
              [@board[0][2], @board[1][1], @board[2][0]] ]

    diags.any?{|arr| all_values_equal?(arr)}
  end

  def all_values_equal?(array)
    init_val = array[0]
    (1..array.length-1).each do |i|
      return false if i != init_val
    end
    false
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