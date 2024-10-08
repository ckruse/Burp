defmodule BurpWeb.TagView do
  use BurpWeb, :view

  @f_max 4
  @f_min 0.8

  def get_size(count, min_count, max_count) do
    divider =
      if @f_max - @f_min == 0.0,
        do: 1,
        else: @f_max - @f_min

    constant = :math.log10(max_count - (min_count - 1)) / divider

    if constant == 0.0 do
      1
    else
      Float.round(:math.log10(count - (min_count - 1)) / constant + @f_min, 5)
    end
  end
end
