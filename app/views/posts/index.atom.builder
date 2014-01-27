atom_feed(id: @blog ? @blog.url : 'http://wer.kennt-wayne.de/') do |feed|
  feed.title @blog ? @blog.name : t('global.who_knows_wayne')
  feed.updated(@posts[0].updated_at) if @posts.length > 0

  @posts.each do |post|
    feed.entry(post, id: post.guid) do |entry|
      entry.title(post.subject)
      entry.content(post.content, type: 'html')

      entry.author do |author|
        author.name(post.author.name)
      end
    end
  end

end

