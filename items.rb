class Item
  attr_reader :name, :unit_price, :sale_price_quantity, :sale_price

  def initialize(name, unit_price, sale_price_quantity = nil, sale_price = nil)
    @name = name
    @unit_price = unit_price
    @sale_price_quantity = sale_price_quantity
    @sale_price = sale_price
  end
end

class Receipt
  def initialize(pricing_table)
    @pricing_table = pricing_table
    @items = Hash.new(0)
  end

  def process_items(item_list)
    item_list.each do |item|
      item_name = item.strip.capitalize
      @items[item_name] += 1 if @pricing_table.key?(item_name)
    end
  end

  def calculate_total
    total_price = 0.0

    @items.each do |item, quantity|
      unit_price = @pricing_table[item].unit_price
      sale_price_quantity = @pricing_table[item].sale_price_quantity

      if sale_price_quantity && quantity >= sale_price_quantity
        sale_count = quantity / sale_price_quantity
        remaining_count = quantity % sale_price_quantity

        total_price += (sale_count * @pricing_table[item].sale_price + remaining_count * unit_price)
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
    original_price = @items.sum { |item, quantity| quantity * @pricing_table[item].unit_price }
    original_price - total_price
  end
end

class DiscountCalculator
  PRICING_TABLE = {
    'Milk'   => Item.new('Milk', 3.97, 2, 5.00),
    'Bread'  => Item.new('Bread', 2.17, 3, 6.00),
    'Banana' => Item.new('Banana', 0.99),
    'Apple'  => Item.new('Apple', 0.89)
  }

  def run
    puts "Please enter all the items purchased separated by a comma"
    user_input = gets.chomp.split(',')

    receipt = Receipt.new(PRICING_TABLE)
    receipt.process_items(user_input)

    puts "\nItem     Quantity      Price\n--------------------------------------"
    total_price = receipt.calculate_total
    receipt.display_receipt(total_price)
  end
end

# Run the program
calculator = DiscountCalculator.new
calculator.run
