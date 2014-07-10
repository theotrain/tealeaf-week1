def value_simple (card)
  #returns point value, use for NON-Aces
  car = card.chop
  if car == 'J' || car == 'Q' || car == 'K'
    return 10
  else
    return car.to_i
  end
end

def hand_value(hand)
  hand_aces = hand.select { |c| c.chop == 'A'}
  hand_no_aces = hand.select { |c| c.chop != 'A'} 
  total_no_aces = 0
  #puts "hand_no_aces #{hand_no_aces}"
  #find value of non-aces, return that if there arent any aces
  hand_no_aces.each { |c| total_no_aces += value_simple(c) }
  num_aces = hand_aces.length
  # puts "processing value of #{hand} ----------"
  # puts "hand_aces #{hand_aces}"
  # puts "hand_no_aces #{hand_no_aces}"
  # puts "num_aces #{num_aces}"
  # puts "----------------------"
  #binding.pry
  if num_aces == 0
    return total_no_aces
  end
  #find all possible ace values. ex: 4 aces = [4,14,24,34,44]
  possible_ace_values = [num_aces]
  (1..num_aces).each { |i| possible_ace_values << (10*i)+num_aces }
  possible_totals = possible_ace_values.map { |ace_val|  ace_val + total_no_aces  }
  #return value closest to 21 without going over
  

  t = possible_totals.select { |v| v < 22 }
  puts "possible totals: #{possible_totals}"
  puts "t: #{t}"
  if !t.empty?
    return t.last
  else
    return possible_totals.first
  end
end

puts "hand value: #{hand_value(["Ac", '9d', '7c', 'Ax'])}"

