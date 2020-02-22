def factorial(n)
  return 1 if n == 0
  (1..n).inject(:*)
end

def combinations(total_perks, unique_choices)
  return factorial(total_perks).to_f / (factorial(unique_choices) * factorial(total_perks-unique_choices))
end

def column_probability(weapon, roll, column_key)
  good_perks = roll[column_key].length
  # An empty list of perks means all are acceptable
  return 1.0 if good_perks == 0

  total_perks = weapon['slots'][column_key]['t']
  available_slots = weapon['slots'][column_key]['c']
  
  # If we're gauranteed to get a perk because there are more slots
  # than there are bad perks, bail out
  return 1.0 if (available_slots + good_perks > total_perks)
    
  total = combinations(total_perks, available_slots)
  bad   = combinations(total_perks - good_perks, available_slots)
  (total - bad) / total
end

def calculate_probability(weapon, roll)
  columnar_probabilities = []
  TRAITS.each do |t|
    columnar_probabilities << column_probability(weapon, roll, t[:key])
  end
  columnar_probabilities.reduce(:*) * 100
end
