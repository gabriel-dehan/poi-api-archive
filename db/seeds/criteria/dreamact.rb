dreamact = Criterium.create({
  uid: 'dreamact',
  name: "Dreamact",
  category: 'consumption'
})

dreamact.sub_criteria.create({
  uid: "dreamact.generic_purchase",
  name: "generic_purchase",
  impact_coefficient: 0,
  data: {
    labels_count_coefficient: 0.1,
    saved_co2_per_label: 0 # TODO: Need actual impact data
  }
})