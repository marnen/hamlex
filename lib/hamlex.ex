defmodule Hamlex do
  @moduledoc """
  Documentation for Hamlex.
  """

  @type haml :: String.t
  @type html :: String.t

  @doc """
  Renders a Haml string to HTML.
  """
  @spec render(haml) :: html
  def render(haml) do
    "HTML version of #{haml}"
  end
end
