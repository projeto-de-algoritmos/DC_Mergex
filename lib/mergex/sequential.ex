defmodule Mergex.Sequential do
  alias Mergex.{Merger}

  def sort([]), do: []
  def sort(list = [_]), do: list

  def sort(list) do
    list
    |> divide_list()
    |> sort_sublists_sequentially_and_merge
  end

  defp sort_sublists_sequentially_and_merge({first_list, second_list}) do
    Merger.merge(sort(first_list), sort(second_list))
  end

  defp divide_list(list) do
    Enum.split(list, trunc(length(list) / 2))
  end
end
