require "../level1/base"
require "./models"

rentals = data["rentals"].map do |rental|
  car = car_by_id(rental["car_id"])
  Rental.new(
    id: rental["id"],
    start_date: rental["start_date"],
    end_date: rental["end_date"],
    distance: rental["distance"],
    car: Car.new(
      id: car[:id],
      price_per_day: car["price_per_day"],
      price_per_km: car["price_per_km"])
  )
end

json_export({rentals: rentals.map(&:to_json)})
