require "json"
require "time"

def data
  @data ||= JSON.load(File.open("./data/input.json"))
end

def rental_days(start_date, end_date)
  (Date.parse(end_date) - Date.parse(start_date) + 1).to_i
end

def car_by_id(id)
  @data["cars"].detect {|car| car["id"] == id}
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

def json_export(hash)
  File.open("./data/output.json", "wb") do |file|
    file.puts JSON.pretty_generate(hash)
  end
end
