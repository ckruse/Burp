defmodule Burp.CleanCommentsTask do
  import Ecto.Query, warn: false

  alias Burp.Repo
  alias Burp.Blog.Comment

  def perform do
    Repo.transaction(fn ->
      from(comment in Comment, order_by: [desc: :id])
      |> Repo.stream()
      |> Enum.map(&maybe_delete_comment/1)
    end)
  end

  defp maybe_delete_comment(comment) do
    if delete?(comment) do
      File.write!(
        "deletions.log",
        "delete comment ##{comment.id} (#{comment.author}, #{comment.email}): #{comment.content}\n\n",
        [:append]
      )

      Repo.delete!(comment)
    end
  end

  @chinese_chars ~r/[\x{4e00}-\x{9fa5}]/u
  @spam_domains ~r/aliexpress|ciali|loans|[a-z]+cial|treatmentforcoronavirus|mpphr.com|space-forums.com|valium|digitalseoserviceslondon/i
  @spam_emails ~r/jinxhh@googlemail.com|mail.ru|delays.space|alisakonstantinova856|sabertf365@gmail.com|vanderburg.smargarets1244@gmail.com/
  @non_spam_authors [
    "Caesar",
    "Christian Kruse",
    "Jeena Paradies",
    "Rodney Rehm",
    "Chräcker Heller",
    "Stonie",
    "Esmeralda",
    "Oliver Wesemann",
    "Astrid Semm",
    "xwolf"
  ]
  @non_spam_comments [
    787,
    816,
    818,
    840,
    955,
    1014,
    1056,
    1167,
    23016,
    23024,
    23026,
    23077,
    23112,
    23114,
    23125,
    23155,
    23158,
    23163,
    23168,
    23167,
    23299,
    23298
  ]

  defp delete?(comment) do
    cond do
      comment.id in @non_spam_comments -> false
      comment.author in @non_spam_authors -> false
      comment.email != nil && Regex.match?(~r/@yandex.com$/, comment.email) -> true
      Regex.match?(~r/viagra|smartwatch/i, comment.content) -> true
      chinese?(comment.author) || chinese?(comment.url) || chinese?(comment.content) -> true
      comment.url && Regex.match?(@spam_domains, comment.url) -> true
      invalid_url?(comment.url) -> true
      comment.email && Regex.match?(@spam_emails, comment.email) -> true
      true -> false
    end
  end

  defp chinese?(nil), do: false
  defp chinese?(str), do: Regex.match?(@chinese_chars, str)

  defp invalid_url?(nil), do: false

  defp invalid_url?(str) do
    uri = URI.parse(str)
    !is_nil(uri.path)
  end
end
