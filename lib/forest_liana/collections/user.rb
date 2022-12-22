class Forest::User
  include ForestLiana::Collection

  collection :User

  action 'POI Static Giveaway', type: "single", fields: [
    {
      type: 'Enum',
      field: 'type',
      enums: Event::StaticImpacts.keys,
      description: "The type of event",
      isRequired: true
    }
  ]

  action 'Create Mobility action', type: "single", fields: [
    {
      type: 'String',
      field: 'distance',
      description: "The distance in kilometers",
      isRequired: true
    }, 
    {
      type: 'Enum',
      field: 'application',
      enums: Application.all.pluck(:name),
      description: "The application triggering the action",
      isRequired: true
    }, 
    {
      type: 'Enum',
      field: 'transport',
      enums: ["bus", "carpool", "scooter", "walk", "train", "electric car", "bike"],
      description: "The mean of transport",
      isRequired: true
    }
  ]
end