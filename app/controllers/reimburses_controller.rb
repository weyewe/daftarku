class ReimbursesController < ApplicationController

	include Transloadit::Rails::ParamsDecoder


	def index
		@objects = current_user.reimburses.includes(:reimburse_details).order("id DESC")
	end

	def new
		@object = Reimburse.new 
	end

	def create




		params[:reimburse][:user_id] = current_user.id 

		if params[:transloadit] and 
			params[:transloadit][:results]['thumb'].present? and
			params[:transloadit][:results]['medium'].present? and 
			params[:transloadit][:results]['optimized'].present? 

			params[:reimburse][:thumb_image_url] =  params[:transloadit][:results]['thumb'].first['url']
			params[:reimburse][:medium_image_url] = params[:transloadit][:results]['medium'].first['url']
			params[:reimburse][:optimized_image_url] = params[:transloadit][:results]['optimized'].first['url']
    	end

    	@object = Reimburse.create_object( params[:reimburse] )

    	if @object.errors.size == 0 
    		redirect_to reimburses_url 
    		return 
    	end

    	@errors_size = @object.errors.size
    	puts "==================++>> Total error: #{@errors_size}\n\n"*10 

	end

	def edit
		@object = Reimburse.find_by_id params[:id]

	end

	def update
		@object  = Reimburse.find_by_id params[:id]

		if params[:transloadit] and 
			params[:transloadit][:results]['thumb'].present? and
			params[:transloadit][:results]['medium'].present? and 
			params[:transloadit][:results]['optimized'].present? 
			
			params[:reimburse][:thumb_image_url] =  params[:transloadit][:results]['thumb'].first['url']
			params[:reimburse][:medium_image_url] = params[:transloadit][:results]['medium'].first['url']
			params[:reimburse][:optimized_image_url] = params[:transloadit][:results]['optimized'].first['url']
    	else
    		params[:reimburse][:thumb_image_url] =  @object.thumb_image_url
			params[:reimburse][:medium_image_url] = @object.medium_image_url
			params[:reimburse][:optimized_image_url] = @object.optimized_image_url
    	end


		@object.update_object( params[:reimburse])

		if @object.errors.size == 0 
			redirect_to reimburses_url
		else
			redirect_to edit_reimburse_url( @object ) 
		end
	end

end
