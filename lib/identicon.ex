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

  def pick_color(%Identicon.Image{hex: [r,g,b | _tail]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  # Same as above
  # def pick_color(image) do
  #   %Identicon.Image{hex: [r,g,b | _tail]} = image
  #   %Identicon.Image{image | color: {r,g,b}}
  # end



end
