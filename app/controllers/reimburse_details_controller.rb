class ReimburseDetailsController < ApplicationController
	include Transloadit::Rails::ParamsDecoder

	def index
		@parent_object = Reimburse.friendly.find params[:reimburse_id]

		if not belongs_to_current_user?( @parent_object )  
			redirect_to reimburses_url 
			return 
		end
		

		@objects = @parent_object.reimburse_details.order("id DESC")
	end

	def new
		@parent  = Reimburse.friendly.find params[:reimburse_id]
		@object = ReimburseDetail.new 
		@object.reimburse_id = @parent.id 
	end

	def belongs_to_current_user?( parent_object ) 
		( not parent_object.nil? ) and parent_object.user_id == current_user.id 
	end

	def create
		puts "We are inside the create of reimburse_deails\n"*10
		@parent = Reimburse.friendly.find params[:reimburse_id]

		if not belongs_to_current_user?( @parent )
			redirect_to reimburses_url 
			return 
		end

		if params[:transloadit] and 
			params[:transloadit][:results]['thumb'].present? and
			params[:transloadit][:results]['medium'].present? and 
			params[:transloadit][:results]['optimized'].present? 
			
			params[:reimburse_detail][:thumb_image_url] =  params[:transloadit][:results]['thumb'].first['url']
			params[:reimburse_detail][:medium_image_url] = params[:transloadit][:results]['medium'].first['url']
			params[:reimburse_detail][:optimized_image_url] = params[:transloadit][:results]['optimized'].first['url']
    	end
    	params[:reimburse_detail][:reimburse_id] = @parent.id 



    	puts "===>>> Gonnna add reimburs detail"
    	@object = ReimburseDetail.create_object( params[:reimburse_detail] )
    	puts "error message: #{@object.errors.size}"


    	@object.errors.messages.each {|x| puts "the error message is #{x}\n\n"*10}
    	if @object.errors.size == 0 
    		redirect_to reimburses_url 
    		return 
    	end 
	end

	def edit
		@parent = Reimburse.friendly.find params[:reimburse_id]
		@object = ReimburseDetail.friendly.find params[:id]

	end

	def update
		@parent = Reimburse.friendly.find params[:reimburse_id]

		if not belongs_to_current_user?( @parent )
			redirect_to reimburses_url 
			return 
		end
		
		@object  = ReimburseDetail.friendly.find params[:id] 

		if params[:transloadit] and 
			params[:transloadit][:results]['thumb'].present? and
			params[:transloadit][:results]['medium'].present? and 
			params[:transloadit][:results]['optimized'].present? 
			
			params[:reimburse_detail][:thumb_image_url] =  params[:transloadit][:results]['thumb'].first['url']
			params[:reimburse_detail][:medium_image_url] = params[:transloadit][:results]['medium'].first['url']
			params[:reimburse_detail][:optimized_image_url] = params[:transloadit][:results]['optimized'].first['url']
    	else
    		params[:reimburse_detail][:thumb_image_url] =  @object.thumb_image_url
			params[:reimburse_detail][:medium_image_url] = @object.medium_image_url
			params[:reimburse_detail][:optimized_image_url] = @object.optimized_image_url
    	end
		params[:reimburse_detail][:reimburse_id] = @parent.id 

		@object.update_object( params[:reimburse_detail])

		if @object.errors.size == 0 
			redirect_to reimburses_url
		else
			redirect_to edit_reimburse_url( [@parent, @object]  ) 
		end
	end

end
