defmodule Tty2048.Grid do
  def move_left(grid) do
    Enum.map collapse(grid), fn
      {acc, tail} -> Enum.reverse(acc, tail)
    end
  end

  def move_right(grid) do
    Enum.map(grid, &Enum.reverse/1) |> collapse |> Enum.map fn
      {acc, tail} -> tail ++ acc
    end
  end

  def move_up(grid) do
    transpose(grid) |> move_left |> transpose
  end

  def move_down(grid) do
    transpose(grid) |> move_right |> transpose
  end

  defp transpose(grid, acc \\ [])

  defp transpose([[]|_], acc) do
    Enum.reverse(acc)
  end

  defp transpose(grid, acc) do
    {tail, row} = Enum.map_reduce(grid, [], fn
      [el|rest], row -> {rest, [el|row]}
    end)

    transpose(tail, [Enum.reverse(row)|acc])
  end

  defp collapse(grid) do
    Stream.map(grid, &collapse(&1, [], []))
  end

  defp collapse([], acc, tail) do
    Enum.reverse(acc) |> merge([], tail)
  end

  defp collapse([0|rest], acc, tail) do
    collapse(rest, acc, [0|tail])
  end

  defp collapse([el|rest], acc, tail) do
    collapse(rest, [el|acc], tail)
  end

  defp merge([], acc, tail) do
    {acc, tail}
  end

  defp merge([el, el|rest], acc, tail) do
    merge(rest, [el + el|acc], [0|tail])
  end

  defp merge([el|rest], acc, tail) do
    merge(rest, [el|acc], tail)
  end
end
