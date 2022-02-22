require "json"
require "time"

file = File.open("./data/input.json")
data = JSON.load(file)
@cars = data["cars"]

def rental_days(start_date, end_date)
  (Date.parse(end_date) - Date.parse(start_date) + 1).to_i
end

def car_by_id(id)
  @cars.detect {|car| car["id"] == id}
end

def rental_price_by_time(rental)
  car_by_id(rental["car_id"]).dig("price_per_day") *
    rental_days(rental["start_date"], rental["end_date"])
end

def rental_price_by_distance(rental)
  car_by_id(rental["car_id"]).dig("price_per_km").to_i *
    rental.dig("distance")
end

def rental_price(rental)
  rental_price_by_time(rental) + rental_price_by_distance(rental)
end

rental_prices = data["rentals"].map do |rental|
  {
    id: rental["id"],
    price: rental_price(rental)
  }
end

export_hash = {rentals: rental_prices}


File.open("data/output.json", "wb") do |file|
  file.puts JSON.pretty_generate(export_hash)
end
