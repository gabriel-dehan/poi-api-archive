tgtg = Criterium.create({
  uid: 'toogoodtogo',
  name: "toogoodtogo",
  category: 'consumption'
})

# For each cart we do quantity * saved_co2 * (impact_coefficient + coefficient_modifier)
tgtg.sub_criteria.create({
  uid: "toogoodtogo.restaurant",
  name: "restaurant",
  impact_coefficient: 3, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0,
        saved_co2: 2.7,
      }
    }
  }
})