# Overide method for applying new pricing for longer rentals.
def rental_price_by_time(rental)
  total_days = rental_days(rental["start_date"], rental["end_date"])
  price_per_day = car_by_id(rental["car_id"]).dig("price_per_day")

  price_discount = [
    { after_day: 0, price: 1 },
    { after_day: 1, price: 0.9 },
    { after_day: 4, price: 0.7 },
    { after_day: 10, price: 0.5 }
  ]

  return 0 if total_days == 0

  days_count = 0
  prices = 0

  price_discount.each_with_index.inject(0) do |sum, (obj, index)|
    break sum if days_count == total_days

    days_period = if price_discount.size == index+1 ||
        total_days < price_discount[index+1][:after_day]
      total_days - days_count
    else
      price_discount[index+1][:after_day] - days_count
    end

    days_count+= days_period

    sum + (price_per_day * obj[:price] * days_period)
  end

end
