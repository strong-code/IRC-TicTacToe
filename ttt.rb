require 'time'

class TicTacToe

  attr_reader :turn, :board_url

  def initialize
    @team1 = Team.new("x")
    @team2 = Team.new("o")
    @board = build_board
    @game_players = {}
    @turn = @team1
    @board_url
  end

  def build_board
    [
      ["-", "-", "-"],
      ["x", "-", "-"],
      ["x", "-", "-"]
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

  def print_board_to_file
    File.open('board.txt', 'w') do |f|
      @board.each do |row|
        row.each do |cell|
          f.write("#{cell} ")
        end
        f.write("\n")
      end
    end
    @board_url = `cat board.txt | curl -F 'sprunge=<-' http://sprunge.us`
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

  def not_enough_players?
    return true if @team1.players == {} || @team2.players == {}
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
    return make_random_move! if @turn.move_votes.empty?
    move = @turn.move_votes.sort_by{|k,v| v}.reverse.first
    place_mark!(move[0])
  end

  def make_random_move!
    move = [Random.rand(3), Random.rand(3)]
    until valid_move?(move)
      move[0], move[1] = Random.rand(3), Random.rand(3)
    end
    place_mark!(move)
  end

  def place_mark!(pos)
    @board[pos.first][pos.last] = @turn.mark
    @turn.move_votes.clear
    print_board_to_file
  end

  def valid_move?(pos)
    return true if @board[pos.first][pos.last] == "-"
    false
  end

  def won?
    if (vertical_win? || horizontal_win? || diag_win?)
      end_game
      return true
    end
    @turn = (@turn == @team1 ? @team2 : @team1)
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
    @board.each.any?{|row| all_values_equal?(row)}
  end

  def diag_win?
    diags = [ [@board[0][0], @board[1][1], @board[2][2]], 
              [@board[0][2], @board[1][1], @board[2][0]] ]

    diags.any?{|arr| all_values_equal?(arr)}
  end

  def all_values_equal?(array)
    return true if array.all?{|i| i.eql?(@turn.mark)}
    false
  end

  def end_game
    @team1.players.clear
    @team1.move_votes.clear
    @team2.players.clear
    @team2.move_votes.clear
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