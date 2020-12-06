class Probability

  def self.factorial(n)
    return 1 if n == 0
    (1..n).inject(:*)
  end
  
  def self.combinations(total_perks, unique_choices)
    return factorial(total_perks).to_f / (factorial(unique_choices) * factorial(total_perks-unique_choices))
  end

  def self.roll_probability(weapon, roll)
    columnar_probabilities = []
    TRAITS.each do |t|
      columnar_probabilities << column_probability(weapon, roll, t[:key])
    end
    columnar_probabilities.reduce(:*) * 100
  end

  def self.column_probability(good_perks, total_perks, available_slots)
    # No good perks means everything is acceptable
    return 1.0 if good_perks == 0
  
    # If we're gauranteed to get a perk because there are more slots
    # than there are bad perks, bail out
    return 1.0 if (available_slots + good_perks > total_perks)
      
    total = combinations(total_perks, available_slots)
    bad   = combinations(total_perks - good_perks, available_slots)
    (total - bad) / total
  end

end