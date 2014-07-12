def initialize_decks
  #make a deck
  suits = ['D', 'H', 'S', 'C']
  cards = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
  deck1 = cards.product(suits)
  # 4 copies
  @decks = deck1.concat(deck1).concat(deck1)
  @decks.shuffle!
  puts @decks.to_s
  puts "total cards: #{@decks.length}"
end

def clear_hands 
  @player_hand = []
  @dealer_hand = []
end

def deal_card(hand)
  hand << @decks.pop
end

def show_cards
  system 'clear'
  puts '----------- Dealer Cards ----------- '
  display_hand(@dealer_hand)
  puts ''
  puts '----------- Player Cards ----------- '
  display_hand(@player_hand)
  puts ''
end

def display_hand (hand)
  #hand is array like [["A", "D"], ["K", "S"], ["10", "H"]]
  c1 = c2 = c3 = c4 = c5 = ""
  hand.each do |h|
    spacer = h[0].length < 2 ? " " : ""
    c1 += "+----+  "
    c2 += "|    |  "
    c3 += "|#{spacer}#{h[0]}#{h[1].downcase} |  "
    c4 += "|    |  "
    c5 += "+----+  "
  end
  puts c1, c2, c3, c4, c5
end

def hand_value(hand)
  total = 0
  #add 10 for face cards and face value for number cards and 11 for aces
  cards = hand.map{|c| c[0]}
  cards.each do |c|
    if c == "A"
      total += 11
    elsif c.to_i == 0
      total += 10
    else
      total += c.to_i 
    end
  end
  cards.select! { |c| c == "A"}
  cards.each do |c|
    if total > 21
      total -= 10
    end
  end
  total
end

def display_values
  puts "You have #{hand_value(@player_hand)}"
  if @dealer_hand.length > 1
    puts "Dealer has #{hand_value(@dealer_hand)}"
  end
end

def play_again
  begin
  puts "play again? (y/n)"
  answer = gets.chomp.downcase
  if answer == 'y'
    game_loop
  elsif answer == 'n'
    puts "Thanks for nothing."
    exit
  end
  puts "type y or n.  its not that difficult."
  end until (answer == 'y' || answer == 'n')
end

def game_loop
  clear_hands
  deal_card(@player_hand)
  deal_card(@dealer_hand)
  deal_card(@player_hand)
  #deal 2 cards to player, and one card to dealer
  show_cards
  display_values
  #puts hand_value([["A", "D"], ["K", "S"], ["4", "H"], ["A", "H"], ["3", "H"]])
  player_value = hand_value(@player_hand)
  if player_value == 21 
    puts "You got blackjack!"
    play_again
  end

  begin
    puts "Would you like to (1)hit or (2)stay?"
    answer = gets.chomp
    if answer == '1'
      deal_card(@player_hand)
      show_cards
      display_values
    end
    if hand_value(@player_hand) >= 21
      break
    end
  end until answer == '2'

  player_value = hand_value(@player_hand)
  if player_value == 21 
    puts 'You got 21!'
    play_again
  elsif player_value > 21
    puts 'You busted.'
    play_again
  end

  #dealer's turn 
  while hand_value(@dealer_hand) < 17
     deal_card(@dealer_hand)
  end

  show_cards
  display_values

  dealer_value = hand_value(@dealer_hand)

  if dealer_value > 21
    puts 'Dealer busted, you win!'
  elsif dealer_value == player_value
    puts "It's a tie.  You lose sucka."
  elsif dealer_value > player_value
    puts "You lose, loser."
  else
    puts "You WIN!"
  end
  play_again
end

initialize_decks
game_loop
play_again

