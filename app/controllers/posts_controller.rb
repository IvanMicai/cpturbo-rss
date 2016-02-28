class PostsController < ApplicationController
  
  # GET /posts
  # GET /posts.json
  def index
  	
  	if(params['topic'])
  		@posts = Post.where("topic_category_#{params['topic'].split(".").length}": params['topic']).order(created_at: :desc).limit(100)
  	else
  		@posts = Post.all.order(created_at: :desc).limit(100)
  	end

	tracker = Staccato.tracker(ENV['CPTURBO_GA'])
  	tracker.pageview(path: "/posts/#{params['topic']}")
 	
  end
  
end
