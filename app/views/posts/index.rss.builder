xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "CPTurbo"
    xml.author "Ivan Micai"
    xml.description "CPTurbo Forum"
    xml.link "http://www.cpturbo.org"
    xml.language "pt-BR"

    for post in @posts
      xml.item do
        xml.title post.title
        xml.author_name post.author_name
        xml.topic_category_0 post.topic_category_0
        xml.topic_category_1 post.topic_category_1
        xml.topic_category_2 post.topic_category_2
        xml.topic_category_3 post.topic_category_3
        xml.topic_category_4 post.topic_category_4
        xml.topic_category_5 post.topic_category_5
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link "http://www.cpturbo.org/cpt/index.php?showtopic=" + post.post_id.to_s
        xml.guid post.post_id

        xml.description Base64.decode64(post.description).to_s
      end
    end
  end
end