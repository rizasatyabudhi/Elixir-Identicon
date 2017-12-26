defmodule Identicon do
  def main(input) do
    input
    |> hash_string
    |> pick_color
  end

  def hash_string(input) do
    # hash = :crypto:hash(:md5,input)
    # :binary.bin_to_list(hash)
    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list

    # assign the return value into the struct
    %Identicon.Image{hex: hex}
  end

  def pick_color(image) do
    # %Identicon.Image{hex: [r,g,b | _tail]} = image
    %Identicon.Image{hex: hex_list} = image

    # hex_list actually has more than [r,g,b] 3 character,
    # so we have to assign them as _tail
    [r,g,b | _tail] = hex_list
    [r,g,b]
  end
end
