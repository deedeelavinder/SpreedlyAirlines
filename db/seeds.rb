destinations = [
    'New York City',
    'London',
    'Barcelona',
    'Rio de Janiero',
    'New Orleans',
    'Tokyo',
    'Berlin',
    'Dubai',
    'Sydney',
    'Copenhagen'
]


destinations.each do |destination|
  Flight.create!(destination: destination, price: rand(50..500))
end