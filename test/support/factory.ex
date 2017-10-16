defmodule Burp.Factory do
  use ExMachina.Ecto, repo: Burp.Repo

  def author_factory do
    %Burp.Meta.Author{
      username: sequence("user-"),
      email: sequence(:email, &"postmaster-#{&1}@example.org"),
      admin: false,
      url: "https://example.com/"
    }
  end

  def blog_factory do
    %Burp.Meta.Blog{
      name: sequence("Blog "),
      description: "foo bar",
      keywords: "baz",
      url: sequence("http://example.org/blog-"),
      image_url: sequence("http://example.org/image-"),
      lang: "de",
      host: sequence(:blog, &"blog-#{&1}.example.org"),
      author: build(:author)
    }
  end

  def post_factory do
    %Burp.Blog.Post{
      slug: sequence("example-"),
      guid: sequence("http://example.org/example-"),
      visible: true,
      subject: sequence("Subject "),
      content: "The posting content",
      format: "html",
      posting_format: "html",
      published_at: NaiveDateTime.utc_now()
    }
  end

  def comment_factory do
    %Burp.Blog.Comment{
      post: build(:post),
      visible: true,
      author: "Foo bar",
      content: "Fine content"
    }
  end

  def tag_factory do
    %Burp.Blog.Tag{
      tag_name: sequence("Tag "),
      post: build(:post)
    }
  end

  def medium_factory do
    %Burp.Media.Medium{
      media_type: "image/png",
      name: sequence("Image "),
      path: "foo/bar",
      url: "/foo/bar",
      blog: build(:blog)
    }
  end
end
