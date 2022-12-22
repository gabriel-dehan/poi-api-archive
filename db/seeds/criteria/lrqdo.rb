lrqdo = Criterium.create({
  uid: 'lrqdo',
  name: "LRQDO",
  category: 'consumption'
})

lrqdo.sub_criteria.create({
  uid: "lrqdo.generic_purchase",
  name: "generic_purchase",
  impact_coefficient: 2.5
})