defmodule CalculatorTest do
  use ExUnit.Case

  test "starts with a basic value" do
    calc = Calculator.create()
    assert calc.value == 0
    assert Calculator.caught_up?(calc)
  end

  test "can add" do
    calc =
      Calculator.create()
      |> Calculator.add(10)

    assert !Calculator.caught_up?(calc)
    assert calc.value == 0

    calc =
      calc
      |> Calculator.catch_up()

    assert Calculator.caught_up?(calc)
    assert calc.value == 10
  end

  test "can subtract" do
    calc =
      Calculator.create(20)
      |> Calculator.subtract(2)

    assert !Calculator.caught_up?(calc)
    assert calc.value == 20

    calc =
      calc
      |> Calculator.catch_up()

    assert Calculator.caught_up?(calc)
    assert calc.value == 18
  end
end
