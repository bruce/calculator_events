defmodule Calculator do
  defstruct value: 0,
            events: %Calculator.EventLog{}

  @type t :: %__MODULE__{
          value: integer(),
          events: Calculator.EventLog.t()
        }

  @type event :: {:add, integer()} | {:subtract, integer()}

  @spec create(initial_value :: integer()) :: t()
  def create(initial_value \\ 0) do
    %__MODULE__{value: initial_value}
  end

  @spec add(calc :: t(), amount :: integer()) :: t()
  def add(calc, amount) do
    put_event(calc, {:add, amount})
  end

  @spec subtract(calc :: t(), amount :: integer()) :: t()
  def subtract(calc, amount) do
    put_event(calc, {:subtract, amount})
  end

  @spec put_event(calc :: t(), event :: event()) :: t()
  defp put_event(calc, event) do
    update_in(
      calc.events,
      &Calculator.EventLog.put_event(&1, event)
    )
  end

  @spec caught_up?(calc :: t()) :: boolean()
  def caught_up?(%{events: %{pending: []}}), do: true
  def caught_up?(_), do: false

  @spec catch_up(calc :: t()) :: t()
  def catch_up(calc) do
    {calc, events} = Calculator.EventLog.play(calc.events, calc, &apply_event/2)
    %{calc | events: events}
  end

  @spec apply_event(calc :: t(), event :: event()) :: t()
  def apply_event(calc, {:add, amount}) do
    %{calc | value: calc.value + amount}
  end

  def apply_event(calc, {:subtract, amount}) do
    %{calc | value: calc.value - amount}
  end
end
