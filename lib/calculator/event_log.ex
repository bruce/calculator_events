defmodule Calculator.EventLog do
  defstruct pending: [],
            applied: []

  @type t :: %__MODULE__{
          pending: [event()],
          applied: [event()]
        }

  @type event :: any()

  @spec put_event(log :: t(), event :: event()) :: t()
  def put_event(log, event) do
    update_in(log.pending, &[event | &1])
  end

  @spec play(
          log :: t(),
          subject :: any(),
          apply_event_fn :: (subject :: any(), event :: event() -> any())
        ) :: {any(), t()}
  def play(log, subject, apply_event_fn) do
    {subject, applied} =
      Enum.reduce(log.pending |> Enum.reverse(), {subject, log.applied}, fn
        event, {subject, applied} ->
          {apply_event_fn.(subject, event), [event | applied]}
      end)

    {subject, %{log | applied: applied, pending: []}}
  end
end
