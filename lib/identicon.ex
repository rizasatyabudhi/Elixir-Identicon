defmodule Identicon do
  def main(input) do
    input
    |> hash_string
    |> pick_color
    |> build_grid
  end

  def hash_string(input) do
    # hex = :crypto:hash(:md5,input)
    # :binary.bin_to_list(hex)
    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list

    # assign the return value into the struct
    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r,g,b | _tail]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  # Same as above
  # def pick_color(image) do
  #   %Identicon.Image{hex: [r,g,b | _tail]} = image
  #   %Identicon.Image{image | color: {r,g,b}}
  # end

  def mirror_row(row) do
    [first,second | _tail] = row
    # ++ is to append to list
    row ++ [second,first]
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    hex
    |> Enum.chunk(3)
    # use & to reference a function
    |> Enum.map(&mirror_row/1)
  end


end
