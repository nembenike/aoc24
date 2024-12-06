defmodule Day2 do
  def read_input(file_name) do
    file_path = Path.join(File.cwd!(), file_name)

    File.read!(file_path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1(input) do
    input
    |> Enum.count(&safe?/1)
  end

  def part2(input) do
    input
    |> Enum.count(&safe_with_dampener?/1)
  end

  defp safe_with_dampener?(levels) do
    safe?(levels) or dampener_safe?(levels)
  end

  defp dampener_safe?(levels) do
    Enum.any?(0..(length(levels) - 1), fn index ->
      levels
      |> List.delete_at(index)
      |> safe?()
    end)
  end

  defp safe?(levels) do
    differences = differences(levels)

    valid_differences?(differences) and monotonic?(differences)
  end

  defp differences(levels) do
    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  defp valid_differences?(differences) do
    Enum.all?(differences, fn diff -> abs(diff) in 1..3 end)
  end

  defp monotonic?(differences) do
    Enum.all?(differences, &(&1 > 0)) or Enum.all?(differences, &(&1 < 0))
  end
end

input = Day2.read_input("input")
IO.puts("Part 1: #{Day2.part1(input)}")
IO.puts("Part 2: #{Day2.part2(input)}")
