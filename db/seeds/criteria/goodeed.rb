goodeed = Criterium.create({
  uid: 'goodeed',
  name: "Goodeed",
  category: 'citizenship'
})

goodeed.sub_criteria.create({
  uid: "goodeed.donation",
  name: "donation",
  impact_coefficient: 1,
  data: {
    donated_money_coeff: 0.1
  }
})