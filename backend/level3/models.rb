class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize(id:, price_per_day:, price_per_km:)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end
end


class Rental
  ROADSIDE_ASSISTANCE_FEE = 100
  COMMISSION_RATE = 0.3
  CUMULATIVE_PRICE = [
    { after_day: 0, price: 1 },
    { after_day: 1, price: 0.9 },
    { after_day: 4, price: 0.7 },
    { after_day: 10, price: 0.5 }
  ]

  attr_accessor :id, :days_num, :distance, :car

  def initialize(id:, start_date:, end_date:, distance:, car:)
    @id = id
    @car = car
    @distance = distance
    @days_num = (Date.parse(end_date) - Date.parse(start_date) + 1).to_i
  end

  def to_json
    {
      id: id,
      price: total_price,
      commission: commision_fee
    }
  end

  private

  def total_price
    (cumulative_price_by_time + price_by_distance).round
  end

  # Old price policy
  def price_by_time
    car.price_per_day * days_num
  end

  # new price policy
  def cumulative_price_by_time
    return 0 if days_num == 0

    days_count = 0
    prices = 0

    CUMULATIVE_PRICE.each_with_index.inject(0) do |sum, (obj, index)|
      break sum if days_count == days_num

      days_period = if CUMULATIVE_PRICE.size == index+1 ||
          days_num < CUMULATIVE_PRICE[index+1][:after_day]
        days_num - days_count
      else
        CUMULATIVE_PRICE[index+1][:after_day] - days_count
      end

      days_count+= days_period

      sum + (car.price_per_day * obj[:price] * days_period)
    end
  end

  def price_by_distance
    car.price_per_km * distance
  end

  def commision_fee
    {
      "insurance_fee": insurance_fee.round,
      "assistance_fee": assistance_fee.round,
      "drivy_fee": drivy_fee.round
    }
  end

  def total_commission
    total_commission ||= total_price * COMMISSION_RATE
  end

  def insurance_fee
    @insurance_fee ||= total_commission / 2
  end

  def assistance_fee
    @assistance_fee ||= ROADSIDE_ASSISTANCE_FEE * days_num
  end

  def drivy_fee
    total_commission - insurance_fee - assistance_fee
  end
end
