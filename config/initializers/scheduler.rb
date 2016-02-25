require 'rufus-scheduler'
require 'mechanize'
require "base64"
require 'yaml'

s = Rufus::Scheduler.new

s.every '5m' do

	Rails.logger.info "Start Crawler Task #{Time.now}"
	Rails.logger.flush

	newestPosts = Post.all.order(created_at: :desc).limit(1000)
	if(newestPosts.length > 0)
		postsToDelete = Post.where('created_at < ?', newestPosts.last.created_at)

		postsToDelete.each do |post|
			post.destroy!
		end
	end


	mechanize = Mechanize.new

	page = mechanize.get('http://www.cpturbo.org/cpt/index.php')


	form = page.forms.first

	form['ips_username'] = ENV["CPTURBO_USER"]
	form['ips_password'] = ENV["CPTURBO_PASS"]


	page = form.submit

	page = mechanize.get('http://www.cpturbo.org/cpt/index.php?app=core&module=search&do=viewNewContent&period=today&search_app=forums&st=0')

	continue_load = true
	page_loaded = 0

	page.search('#forum_table tr').reverse_each do |post|

		topic = {}

		topic['post_id'] = post.search('h4 a').attribute('href').value
		topic['post_id'].slice! "http://www.cpturbo.org/cpt/index.php?showtopic="
		topic['post_id'].slice! "&hl="
		topic['post_id'] = topic['post_id'].to_i

		if(Post.where(post_id: topic['post_id']).length != 0)
			continue_load = false
			next
		end

		topicPage = mechanize.get(post.search('h4 a').attribute('href').value)
		topic['title'] = topicPage.search('.ipsBox_withphoto h1').text.strip

		if (topicPage.search('.ipsBox_withphoto .blend_links span').length == 3 )
			topic['published_at'] = topicPage.search('.ipsBox_withphoto .blend_links span')[2].attribute('datetime').text
		else
			topic['published_at'] = topicPage.search('.ipsBox_withphoto .blend_links span')[1].attribute('datetime').text
		end

		if(topicPage.search('.ipsBox_withphoto .blend_links span a').length != 0)
		  topic['author_id'] =  topicPage.search('.ipsBox_withphoto .blend_links span a').attribute('hovercard-id').value
		  topic['author_name'] = topicPage.search('.ipsBox_withphoto .blend_links span a').text
		else
		  topic['author_name'] = nil
		  topic['author_name'] = topicPage.search('.ipsBox_withphoto .blend_links span')[1].text
		end

		topic['description'] = Base64.encode64(topicPage.search('.post_body')[0].to_html)


		topic['topic_category_0'] = ''
		topic['topic_category_1'] = ''
		topic['topic_category_2'] = ''
		topic['topic_category_3'] = ''
		topic['topic_category_4'] = ''
		topic['topic_category_5'] = ''
		
		topic_level = topicPage.search('#secondary_navigation ol li a').length/2
		
		while topic_level > 1 do
			topic_level -= 1
			topic['topic_category_' + topic_level.to_s] = topicPage.search('#secondary_navigation ol li a')[topic_level].text.split(' ')[0]
		end

		Post.create(
			title: topic['title'],
			post_id: topic['post_id'],
			created_at: DateTime.now.to_s,
			published_at: Date.parse(topic['published_at']),
			author_name: topic['author_name'],
			author_id: topic['author_id'],
			description: topic['description'],
			topic_category_0: topic['topic_category_0'],
			topic_category_1: topic['topic_category_1'],
			topic_category_2: topic['topic_category_2'],
			topic_category_3: topic['topic_category_3'],
			topic_category_4: topic['topic_category_4'],
			topic_category_5: topic['topic_category_5'],
		 )

	end


end