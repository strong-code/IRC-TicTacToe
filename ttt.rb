require 'time'

class TicTacToe

  def initialize
    @team1 = Team.new(:x)
    @team2 = Team.new(:o)
    @board = build_board
    @last_round = Time.now()
    @game_players = {}
  end

  def build_board
    [
      ["-", "-", "-"],
      ["-", "-", "-"],
      ["-", "-", "-"]
    ]
  end

  def add_player(nick, mark)
    if mark == "x"
      @team1.players << nick
      @game_players[nick] == "x"
    else
      @team12.players << nick
      @game_players[nick] == "o"
    end
  end

  def registered_player?(nick)
    @team1.players.include?(nick) || @team2.players.include?(nick)
  end

  def record_vote(nick, pos)
    pos = [pos[0].to_i, pos[2].to_i]
    mark = @game_players[nick]

    return if !valid_move?(pos)
    place_mark!(pos, mark)
  end

  def place_mark!(pos, mark)
    @board[pos.first][pos.last] = mark
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
    @players = []
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