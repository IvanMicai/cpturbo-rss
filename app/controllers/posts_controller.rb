class PostsController < ApplicationController
  
  # GET /posts
  # GET /posts.json
  def index
  	if(params['topic'])
  		@posts = Post.where("topic_category_#{params['topic'].split(",").length+1}": params['topic']).order(created_at: :desc).limit(100)
  	else
  		@posts = Post.all.order(created_at: :desc).limit(100)
  	end
  end
  
end
