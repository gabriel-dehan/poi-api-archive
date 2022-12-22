mobility = Criterium.create({
  uid: 'transport',
  name: "Transport",
  category: 'mobility'
})

mobility.sub_criteria.create({
  uid: "transport.walk",
  name: "walk",
  impact_coefficient: 5, 
  data: {
    distance: {
      thresholds: [200, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 205,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.bike",
  name: "bike",
  impact_coefficient: 5, 
  data: {
    distance: {
      thresholds: [500, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 200,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.kickscooter",
  name: "kick scooter",
  impact_coefficient: 5, 
  data: {
    distance: {
      thresholds: [500, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 200,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.skate",
  name: "skate",
  impact_coefficient: 5, 
  data: {
    distance: {
      thresholds: [500, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 200,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.rollerblade",
  name: "rollerblade",
  impact_coefficient: 5, 
  data: {
    distance: {
      thresholds: [500, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 200,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.metro",
  name: "metro",
  impact_coefficient: 1, 
  data: {
    distance: {
      thresholds: [1000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 195,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.tram",
  name: "tram",
  impact_coefficient: 1, 
  data: {
    distance: {
      thresholds: [1000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 195,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.suburbantrain",
  name: "suburban train",
  impact_coefficient: 1, 
  data: {
    distance: {
      thresholds: [1000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 195,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.train",
  name: "train",
  impact_coefficient: 2, 
  data: {
    distance: {
      thresholds: [20000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 190,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.electrickickscooter",
  name: "electric kick scooter",
  impact_coefficient: 1, 
  data: {
    distance: {
      thresholds: [1000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 185,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.electricskate",
  name: "electric skate",
  impact_coefficient: 1, 
  data: {
    distance: {
      thresholds: [1000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 185,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.carpool",
  name: "carpool",
  impact_coefficient: 1, 
  data: {
    distance: {
      thresholds: [50000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 145,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.bus",
  name: "bus",
  impact_coefficient: 0.5, 
  data: {
    distance: {
      thresholds: [1000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 105,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.scooter",
  name: "scooter",
  impact_coefficient: 0.5, 
  data: {
    distance: {
      thresholds: [10000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 95,
      unit: 'grams'
    }
  }
})

mobility.sub_criteria.create({
  uid: "transport.electriccar",
  name: "electric car",
  impact_coefficient: 0.5, 
  data: {
    distance: {
      thresholds: [10000, nil],
      unit: 'meters'
    },
    saved_co2: {
      value: 95,
      unit: 'grams'
    }
  }
})