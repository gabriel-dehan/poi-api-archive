phenix = Criterium.create({
  uid: 'phenix',
  name: "Phenix",
  category: 'consumption'
})

# For each cart we do quantity * saved_co2 * (impact_coefficient + coefficient_modifier)
phenix.sub_criteria.create({
  uid: "phenix.supermarket",
  name: "supermarket",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0,
        saved_co2: 6.75,
      },
      vegetables:  {
        coefficient_modifier: 0.4,
        saved_co2: 13.5,
      },
      greens:  {
        coefficient_modifier: 0.6,
        saved_co2: 2.25,
      }
    }
  }
})

# Epicerie
phenix.sub_criteria.create({
  uid: "phenix.local_shop",
  name: "local_shop",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.4,
        saved_co2: 6.75,
      }
    }
  }
})

# Artisan
phenix.sub_criteria.create({
  uid: "phenix.artisan_shop",
  name: "artisan_shop",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.6,
        saved_co2: 2.25,
      }
    }
  }
})

# Flower
phenix.sub_criteria.create({
  uid: "phenix.florist",
  name: "florist",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.2,
        saved_co2: 4.5,
      }
    }
  }
})

# Hotel
phenix.sub_criteria.create({
  uid: "phenix.hotel",
  name: "hotel",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.4,
        saved_co2: 4.5,
      }
    }
  }
})

# Boulangerie
phenix.sub_criteria.create({
  uid: "phenix.bakery",
  name: "bakery",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.6,
        saved_co2: 4.5,
      }
    }
  }
})

# Restaurant
phenix.sub_criteria.create({
  uid: "phenix.restaurant",
  name: "restaurant",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.4,
        saved_co2: 4.5,
      }
    }
  }
})

# Traiteur
phenix.sub_criteria.create({
  uid: "phenix.caterer",
  name: "caterer",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.6,
        saved_co2: 2.25,
      }
    }
  }
})

# Foodtech
phenix.sub_criteria.create({
  uid: "phenix.foodtech",
  name: "foodtech",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.4,
        saved_co2: 4.5,
      }
    }
  }
})

# Primeur
phenix.sub_criteria.create({
  uid: "phenix.greengrocer",
  name: "greengrocer",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.6,
        saved_co2: 13.5,
      }
    }
  }
})

# Salon de thé
phenix.sub_criteria.create({
  uid: "phenix.tea_house",
  name: "tea_house",
  impact_coefficient: 1, 
  data: {
    cart_type: {
      default: {
        coefficient_modifier: 0.4,
        saved_co2: 2.25,
      }
    }
  }
})
