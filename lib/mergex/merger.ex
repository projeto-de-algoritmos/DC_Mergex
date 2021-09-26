defmodule Mergex.Merger do
  def merge([], []), do: []
  def merge(not_empty_list, []), do: not_empty_list
  def merge([], not_empty_list), do: not_empty_list

  def merge([head | tail], second_list) when head <= hd(second_list) do
    [head | merge(tail, second_list)]
  end

  def merge(first_list, [head | tail]), do: [head | merge(first_list, tail)]
end
