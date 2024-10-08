defmodule BurpWeb.Sortable do
  alias Burp.Helpers

  def sortable(conn, text, field, path_helper, opts \\ []) do
    extra_args = opts[:link_args] || []
    action = Phoenix.Controller.action_name(conn)

    column = sort_column(conn)
    dir = sort_direction(conn)

    cond do
      column == field && dir == :desc ->
        path = apply(path_helper, [conn, action, extra_args ++ [sort: field, dir: :asc]])
        PhoenixHTMLHelpers.Link.link(text, to: path, class: "sortable sort-descending")

      column == field && dir == :asc ->
        path = apply(path_helper, [conn, action, extra_args ++ [sort: field, dir: :desc]])
        PhoenixHTMLHelpers.Link.link(text, to: path, class: "sortable sort-ascending")

      true ->
        path = apply(path_helper, [conn, action, extra_args ++ [sort: field, dir: :asc]])
        PhoenixHTMLHelpers.Link.link(text, to: path, class: "sortable")
    end
  end

  def sort_collection(conn, valid_fields, defaults \\ [dir: :asc]) do
    controller_nam =
      Phoenix.Controller.controller_module(conn)
      |> Atom.to_string()
      |> String.replace(~r{.*\.}, "")

    cookie_key_col = "burp_" <> controller_nam <> "-sort_col"
    cookie_key_dir = "burp_" <> controller_nam <> "-sort_dir"

    {set_cookie_col, sort_col} =
      if Helpers.blank?(conn.params["sort"]) do
        {false, conn.cookies[cookie_key_col] || Atom.to_string(List.first(valid_fields))}
      else
        {true, conn.params["sort"]}
      end

    {set_cookie_dir, sort_dir} =
      if Helpers.blank?(conn.params["dir"]) do
        {false, conn.cookies[cookie_key_dir] || defaults[:dir]}
      else
        {true, conn.params["dir"]}
      end

    sort_dir =
      if sort_dir != "asc" && sort_dir != "desc",
        do: :asc,
        else: String.to_atom(sort_dir)

    sort_col =
      if Enum.find(valid_fields, &(Atom.to_string(&1) == sort_col)),
        do: String.to_atom(sort_col),
        else: List.first(valid_fields)

    {
      [{sort_dir, sort_col}],
      conn
      |> set_cookie(cookie_key_col, Atom.to_string(sort_col), set_cookie_col)
      |> set_cookie(cookie_key_dir, Atom.to_string(sort_dir), set_cookie_dir)
      |> Plug.Conn.assign(:_sort_col, sort_col)
      |> Plug.Conn.assign(:_sort_dir, sort_dir)
    }
  end

  defp set_cookie(conn, _, _, false), do: conn

  defp set_cookie(conn, key, value, true) do
    Plug.Conn.put_resp_cookie(conn, key, value, max_age: 360 * 24 * 60 * 60)
  end

  defp sort_column(conn) do
    conn.assigns[:_sort_col]
  end

  defp sort_direction(conn) do
    conn.assigns[:_sort_dir] || :asc
  end
end
