require 'pry'

def initialize_board
	@b = {} #board
	(1..9).each {|i| @b[i] = ' '}
end

def play_again
	puts "play again (y/n)?"
	a = gets.chomp
	if a.downcase == 'y'
		initialize_board
		draw_board
	else
		exit
	end
end

def empty_spots
	#returns array of numbers representing empty spots on the board
	@b.select {|k,v| v == ' '}.keys
end

def player_turn
	puts 'pick a spot (1-9)'
	spot = gets.chomp.to_i
	if !spot.between?(1, 9)
		puts "What the hell was that?"
		puts "Choose one of these numbers: #{empty_spots}"
		return false
	end

	if empty_spots.include?(spot)
		@b[spot] = "X"
		return true
	else
		puts "THAT SPOT IS ALREADY TAKEN YOU CHEATER"
		return false
	end
end

def hal_turn
	@b[empty_spots.sample] = "O"
end


def game_over?
	winning_lines = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
	winning_lines.each do |line|
		if line.all? {|num| @b[num] == 'X'}
			puts "YOU WIN!"
			return true
		elsif line.all? {|num| @b[num] == 'O'}
			puts "You just lost to a random number generator."
			return true
		end	
	end
	#check if board is full
	if @b.none? {|k,v| v == ' '}
		puts "its a tie!"
		return true
	end
	false
end

def draw_board
	# binding.pry
	system "clear"
	puts " #{@b[1]} | #{@b[2]} | #{@b[3]} "
	puts "---+---+---"
	puts " #{@b[4]} | #{@b[5]} | #{@b[6]} "
	puts "---+---+---"
	puts " #{@b[7]} | #{@b[8]} | #{@b[9]} "
	puts ""
	if game_over?
		play_again
	end
end

initialize_board()

while (true) do
	draw_board
	
	begin
		go = player_turn()
	end until go

	draw_board
	hal_turn
end
