class DiscountCalculator
  PRICING_TABLE = {
    'Milk'   => { unit_price: 3.97, sale_price_quantity: 2, sale_price: 5.00 },
    'Bread'  => { unit_price: 2.17, sale_price_quantity: 3, sale_price: 6.00 },
    'Banana' => { unit_price: 0.99 },
    'Apple'  => { unit_price: 0.89 }
  }

  def initialize
    @items = Hash.new(0)
  end

  def process_items(item_list)
    item_list.each do |item|
      @items[item.capitalize] += 1 if PRICING_TABLE.key?(item.capitalize)
    end
  end

  def calculate_total
    total_price = 0.0

    @items.each do |item, quantity|
      unit_price = PRICING_TABLE[item][:unit_price]
      sale_price_quantity = PRICING_TABLE[item][:sale_price_quantity]

      if sale_price_quantity && quantity >= sale_price_quantity
        sale_count = quantity / sale_price_quantity
        remaining_count = quantity % sale_price_quantity

        total_price += (sale_count * PRICING_TABLE[item][:sale_price] + remaining_count * unit_price)
      else
        total_price += quantity * unit_price
      end

      puts "#{item.ljust(8)} #{quantity.to_s.ljust(12)} $#{'%.2f' % (quantity * unit_price)}"
    end

    total_price
  end

  def display_receipt(total_price)
    puts "\nTotal price : $#{'%.2f' % total_price}"
    saved_amount = calculate_saved_amount(total_price)
    puts "You saved $#{'%.2f' % saved_amount} today."
  end

  private

  def calculate_saved_amount(total_price)
    original_price = @items.sum { |item, quantity| quantity * PRICING_TABLE[item][:unit_price] }
    original_price - total_price
  end
end

puts "Please enter all the items purchased separated by a comma"
user_input = gets.chomp.split(',')

calculator = DiscountCalculator.new
calculator.process_items(user_input)

puts "\nItem     Quantity      Price\n--------------------------------------"
total_price = calculator.calculate_total
calculator.display_receipt(total_price)
