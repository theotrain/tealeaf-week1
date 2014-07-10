def initialize_decks
  #shove 4 decks of cards into one big filthy array
  @decks = []
  suits = ['h','d','s','c']
  faces = ['A','J','Q','K']
  4.times do |i|
    (2..10).each { |n| @decks << n.to_s + suits[i] }
  end
  4.times do |i|
    faces.each { |f| @decks << f + suits[i] }
  end
  @decks.concat(@decks).concat(@decks)
  @decks.shuffle!
end

def reset_hands
  @dealer_hand = []
  @player_hand = []
end

def deal_card (hand)
  hand << @decks.shift
end

def deal_first_cards 
  deal_card @dealer_hand
  deal_card @player_hand
  deal_card @player_hand
end

def hand_value(hand)
  #divide hand into aces and not aces
  hand_aces = hand.select { |c| c.chop == 'A'}
  hand_no_aces = hand.select { |c| c.chop != 'A'} 
  total_no_aces = 0
  #find value of non-aces, return that if there arent any aces
  hand_no_aces.each { |c| total_no_aces += value_simple(c) }
  num_aces = hand_aces.length
  if num_aces == 0
    return total_no_aces
  end
  #find all possible ace values. ex: 4 aces = [4,14,24,34,44]
  possible_ace_values = [num_aces]
  (1..num_aces).each { |i| possible_ace_values << (10*i)+num_aces }
  possible_totals = possible_ace_values.map { |ace_val|  ace_val + total_no_aces  }
  #return possible value closest to 21
  t = possible_totals.select { |v| v < 22 }
  if !t.empty?
    return t.last
  else
    return possible_totals.first
  end
end

def value_simple (card)
  #returns point value, use for NON-Aces
  car = card.chop
  if car == 'J' || car == 'Q' || car == 'K'
    return 10
  else
    return car.to_i
  end
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
  #hand is array like ["10c", "4h", "As"]
  c1 = c2 = c3 = c4 = c5 = ""
  hand.each do |h|
    spacer = h.length < 3 ? " " : ""
    c1 += "+----+  "
    c2 += "|    |  "
    c3 += "|#{spacer}#{h} |  "
    c4 += "|    |  "
    c5 += "+----+  "
  end
  puts c1, c2, c3, c4, c5
end

def player_turn
  begin
    puts "would you like to (h)it or (s)tay?"
    choice = gets.chomp.downcase
    if choice == 'h'
      deal_card(@player_hand)
      show_cards
      if hand_value(@player_hand) > 21
        puts "That makes #{hand_value(@player_hand)}. You Sir, are BUSTED!"
        play_again
      elsif hand_value(@player_hand) == 21
        puts "You got BLACKJACK!\nI bet you think you're pretty special."
        play_again
      end
    end
  end until choice == 's'
end

def dealer_turn
  #player = hand_value(@player_hand)
  #amount_to_beat = ( player > 17 ? player : 17 )
  begin
    deal_card(@dealer_hand)
  end until hand_value(@dealer_hand) >= hand_value(@player_hand)
  show_cards
end

def check_decks
  #make fresh decks if cards get low.
  if @decks.length < 50
    initialize_decks
  end
end

def determine_winner
  dealer = hand_value(@dealer_hand)
  player = hand_value(@player_hand)
  puts "Dealer has #{dealer}"
  puts "Player has #{player}"
  if dealer > 21  || player > dealer
    puts "YOU WIN!\n10 million karma bitcoins have been hyperdimensionally transferred to you"
  elsif (dealer == player)
    puts "Its a tie!  But since we own the joint, we win and you LOSE!!!"
  else
    puts "Dealer wins.  Suck it!"
  end
end

def play_again
  begin
    puts "you wanna play again (y/n)?"
    choice = gets.chomp.downcase
    if choice == 'y'
      game_loop
    end
  end until choice == 'n'
  puts "hit the bricks deadbeat"
  exit
end

def game_loop
  check_decks
  reset_hands
  deal_first_cards
  show_cards
  if hand_value(@player_hand) == 21
    puts "You got BLACKJACK!.. Just for sitting there."
    play_again
  end
  player_turn
  dealer_turn
  determine_winner
  play_again
end

initialize_decks
game_loop
