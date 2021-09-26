max_value =
  System.argv()
  |> List.first()
  |> String.to_integer()

list = 1..max_value |> Enum.to_list() |> Enum.shuffle()

Benchee.run(
  %{
    "parallel" => fn -> Mergex.Parallel.sort(list) end,
    "sequential" => fn -> Mergex.Sequential.sort(list) end,
  }
)
