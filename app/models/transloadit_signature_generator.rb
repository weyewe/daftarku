
require 'active_support'
require 'json'
require 'openssl'


class TransloaditSignatureGenerator
	attr_accessor :expiration, :signature

	DIGEST = OpenSSL::Digest::Digest.new('sha1')

	def initialize(expires_in = 12.hours)
		@expiration = (Time.now.utc + expires_in).strftime('%Y/%m/%d %H:%M:%S+00:00')
	end

	def signature 
		OpenSSL::HMAC.hexdigest(
			DIGEST,
			ENV["transloadit_auth_secret"], 
			transloadit_params
		)
	end

	def transloadit_params 
		JSON.generate({
			auth: {
			expires: @expiration,
			key: ENV["transloadit_auth_key"] ,# TRANSLOADIT_AUTH_KEY,
			},
			template_id: ENV["transloadit_template_id"] # TRANSLOADIT_TEMPLATE_ID
		})
	end

end