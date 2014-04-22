class TicTacToe

  def initialize
    @team1 = Team.new(:x)
    @team2 = Team.new(:o)
    @board = build_board
  end

  def self.registered_player?(nick)
    return true if @team1.players.include?(nick) || @team2.players.include?(nick)
    false
  end

  def self.build_board
    [
      ["-", "-", "-"],
      ["-", "-", "-"],
      ["-", "-", "-"]
    ]
  end

  def record_vote(nick, pos)

  end

  def self.place_mark!(pos, mark)
    self.board[pos1, pos2] = mark if valid_move?(pos)
  end

  def valid_move?(pos)
    return true if self.board[pos1, pos2] == "-"
    false
  end

  def game_won?
    self.board.each do |row|
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

  attr_reader :players, :mark, :move_votes

  def initialize(mark)
    @mark = mark
    @players = []
    @move_votes = {}
  end

  def add_player(nick)
    self.players << nick
  end

  def add_vote(pos)
    if self.move_votes[pos]
      self.move_votes[pos] += 1
    else
      self.move_votes[pos] = 1
    end
  end

end