
class Api2::TransloaditsController < Api2::BaseMobileApiController
  respond_to :json

  def get_new_signature
  	generator  = TransloaditSignatureGenerator.new 


    render :json => { :signature => generator.signature ,
    	:params => generator.transloadit_params 
     }  
  end


 

end
 