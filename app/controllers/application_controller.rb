class ApplicationController < ActionController::API
	include Response
  	include ExceptionHandler
	include ActionController::HttpAuthentication::Token::ControllerMethods
	before_action :authenticate unless Rails.env == "test"

	def authenticate
	authenticate_token || render_unauthorized
	end

	def authenticate_token
	authenticate_with_http_token do |token, options|
	  @current_user = Admin.find_by(token: token)
	end
	end

	def render_unauthorized(realm = "Application")
	self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
	render json: {:error => "Bad credentials"}, status: :unauthorized
	end
end
