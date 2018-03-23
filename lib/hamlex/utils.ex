defmodule Hamlex.Utils do
  @spec indent(String.t, non_neg_integer) :: String.t
  def indent(string, increment \\ 2) do
    spaces = String.duplicate " ", increment
    lines = for line <- String.split(string, "\n"), do: spaces <> line
    Enum.join lines, "\n"
  end

  @spec q(String.t) :: String.t
  def q(string) do
    "'" <> string <> "'"
  end
end
