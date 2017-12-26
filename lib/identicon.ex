defmodule Identicon do
  def main(input) do
    input
    |> hash_string
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    # input is the second argument, the fist argument is the image from draw_image
    |> save_image(input)
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
    # assign/concat color to the struct
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
    # assign the pipe operator to "grid" variable
    grid =
      hex
      |> Enum.chunk(3)
      # use & to reference a function
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # Take the "first" index from grid
    grid = Enum.filter(grid, fn({code, _index}) ->
      rem(code,2) == 0
    end)

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index,5) * 50
      vertical = div(index,5) * 50

      top_left = {horizontal,vertical}
      bottom_right = {horizontal+50,vertical+50}
    end
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(255,255)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image,start,stop,fill)
    end

    :egd.render(image)
  end

  def save_image(image,input) do
    File.write("#{input}.png", image)
  end
end
