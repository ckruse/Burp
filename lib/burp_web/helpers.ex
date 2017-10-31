defmodule BurpWeb.Helpers do
  use Phoenix.HTML

  @doc """
  generates a „sub-form“ in a different namespace: the input fields will be prefixed
  with that namespace. If i.e. called with `field` set to `foo[bar]` the generated
  field names look like this: `foo[bar][baz]`
  """
  def sub_inputs(form, field, _options \\ [], fun) do
    # options =
    #   form.options
    #   |> Keyword.take([:multipart])
    #   |> Keyword.merge(options)

    attr = Map.get(form.data, field) || %{}

    symbolized_attr =
      Enum.reduce(Map.keys(attr), %{}, fn key, map ->
        Map.put(map, String.to_atom(key), attr[key])
      end)

    types =
      Enum.reduce(Map.keys(symbolized_attr), %{}, fn key, map -> Map.put(map, key, :string) end)

    changeset =
      Ecto.Changeset.cast({symbolized_attr, types}, form.params, Map.keys(symbolized_attr))

    forms = Phoenix.HTML.FormData.to_form(changeset, as: form.name <> "[#{field}]")

    fun.(forms)
  end
end
