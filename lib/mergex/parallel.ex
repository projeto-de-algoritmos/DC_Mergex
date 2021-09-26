defmodule Mergex.Parallel do
  def sort(list, max_parallel \\ 1)
  def sort([], _), do: []
  def sort(list = [_], _), do: list

  def sort(list, max_parallel),
    do: sort(list, max_parallel, 1)

  def sort([], _, _), do: []
  def sort(list = [_], _, _), do: list

  def sort(list, max_parallel, current_level) do
    list
    |> Enum.split(list, div(length(list), 2))
    |> sort_and_merge(max_parallel, current_level + 1)
  end

  defp sort_and_merge(
         {first_list, second_list},
         max_parallel,
         current_level
       )
       when max_parallel < current_level do
    task_1 = Task.async(fn -> Mergex.Sequential.sort(first_list) end)
    task_2 = Task.async(fn -> Mergex.Sequential.sort(second_list) end)
    Mergex.Merger.merge(Task.await(task_1, :infinity), Task.await(task_2, :infinity))
  end

  defp sort_and_merge(
         {first_list, second_list},
         max_parallel,
         current_level
       ) do
    task_1 = Task.async(fn -> sort(first_list, max_parallel, current_level) end)
    task_2 = Task.async(fn -> sort(second_list, max_parallel, current_level) end)
    Mergex.Merger.merge(Task.await(task_1, :infinity), Task.await(task_2, :infinity))
  end
end
