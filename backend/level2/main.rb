require "../level1/base"
require "./base"

rental_prices = data["rentals"].map do |rental|
  {
    id: rental["id"],
    price: rental_price(rental).round
  }
end

json_export({rentals: rental_prices})
