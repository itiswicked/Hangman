require 'httparty'

puts HTTParty
  .get('http://localhost:3000/api/v1/integrations/new')
  .body[0..4000]
