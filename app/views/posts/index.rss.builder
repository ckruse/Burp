xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title @blog ? @blog.name : 'Who knows Wayne?'
    xml.description @blog ? @blog.description : 'Who knows Wayne?'
    xml.link feed_url(format: :rss)
    xml.tag! 'atom:link', href: feed_url(format: :rss), rel: 'self', type: "application/rss+xml"

    for post in @posts
      xml.item do
        xml.title post.subject
        xml.description post.content
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link post_url(post)
        xml.guid post.guid
      end
    end
  end
end
