require 'test/unit'

class Terminal
  def initialize
    @total = 0 
    @products = Hash.new(0)
  end

  def set_pricing(pricings)
    @pricings = pricings
  end

  def scan(product)
    return if @pricings[product] == nil
    @products[product] += 1
    if reach_packing?(product)
      @total += @pricings[product][:pack][:amount]
      @products[product] = 0
    end
  end

  def result
    @products.each {|key, value| @total += @pricings[key][:each] * value}
    p "$#@total."
  end

  private
  def reach_packing?(product)
    @pricings[product][:pack] && @pricings[product][:pack][:count] == @products[product]
  end
end

class TestTerminal < Test::Unit::TestCase
    def setup
      @pricing = {
        "A" => {:each => 2.0, :pack => {:count => 4, :amount => 7.0}},
        "B" => {:each => 12.0},
        "C" => {:each => 1.25, :pack => {:count => 6, :amount => 6.0}},
        "D" => {:each => 0.15}
      }
    end
    def test_terminal_ABCDABAA
      terminal = Terminal.new
      terminal.set_pricing(@pricing)
      terminal.scan("A")
      terminal.scan("B")
      terminal.scan("C")
      terminal.scan("D")
      terminal.scan("A")
      terminal.scan("B")
      terminal.scan("A")
      terminal.scan("A")
      assert_equal terminal.result, "$32.4."
    end

    def test_terminal_CCCCCCC
      terminal = Terminal.new
      terminal.set_pricing(@pricing)
      terminal.scan("C")
      terminal.scan("C")
      terminal.scan("C")
      terminal.scan("C")
      terminal.scan("C")
      terminal.scan("C")
      terminal.scan("C")
      assert_equal terminal.result, "$7.25."
    end
    def test_terminal_ABCD
      terminal = Terminal.new
      terminal.set_pricing(@pricing)
      terminal.scan("A")
      terminal.scan("B")
      terminal.scan("C")
      terminal.scan("D")
      assert_equal terminal.result, "$15.4."
    end
    def test_terminal_without_pricing
      terminal = Terminal.new
      terminal.set_pricing({})
      terminal.scan("C")
      assert_equal terminal.result, "$0."
    end

    def test_terminal_without_scan
      terminal = Terminal.new
      terminal.set_pricing(@pricing)
      assert_equal terminal.result, "$0."
    end
  end
