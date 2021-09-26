defmodule Mergex.Parallel do
  alias Mergex.{Merger, Sequential}

  def sort(list, max_parallel \\ 1)
  def sort([], _), do: []
  def sort(list = [_], _), do: list

  def sort(list, max_parallel),
    do: sort(list, max_parallel, 1)

  def sort([], _, _), do: []
  def sort(list = [_], _, _), do: list

  def sort(list, max_parallel, current_level) do
    list
    |> Enum.split(div(length(list), 2))
    |> sort_and_merge(max_parallel, current_level + 1)
  end

  defp sort_and_merge(
         {right, left},
         max_parallel,
         current_level
       )
       when current_level >= max_parallel do
    task_right = Task.async(fn -> Sequential.sort(right) end)
    task_left = Task.async(fn -> Sequential.sort(left) end)

    handle_response(task_right, task_left)
  end

  defp sort_and_merge(
         {right, left},
         max_parallel,
         current_level
       ) do
    task_right = Task.async(fn -> sort(right, max_parallel, current_level) end)
    task_left = Task.async(fn -> sort(left, max_parallel, current_level) end)

    handle_response(task_right, task_left)
  end

  defp handle_response(task_right, task_left) do
    Merger.merge(Task.await(task_right, :infinity), Task.await(task_left, :infinity))
  end
end
