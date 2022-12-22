lilo = Criterium.create({
  uid: 'lilo',
  name: "Lilo",
  category: 'citizenship'
})

lilo.sub_criteria.create({
  uid: "lilo.search",
  name: "search",
  impact_coefficient: 0.1,
  data: {
    donated_money_coeff: 0.04,
  }
})