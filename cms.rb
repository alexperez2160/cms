require "sinatra"
require "sinatra/reloader" 
require "sinatra/content_for"
require "tilt/erubis"
require "redcarpet"

configure do 
	enable :sessions 
	set :session_secret, 'secret'
end 


def render_markdown(text)
		markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
		markdown.render(text)
end 

def load_file_content(path)
	content = File.read(path)
	case File.extname(path)
		when ".txt"
			headers["Content-Type"] = "text/plain"
			content
		when ".md"
			render_markdown(content)
		end 
	end 


get '/' do

	@file= Dir.glob("data/*").map do |path|
		File.basename(path)
	end

	session[:files] = @file 
	
	erb :index
end


get '/:filename' do 
	@file_path = "data/" + params[:filename]
	session[:files] = Dir.glob("data/*").map do |path|
		File.basename(path)
	end

	@error = false 

	headers["Content-Type"] = "text/plain"
	if session[:files].include?(params[:filename])
		load_file_content(@file_path)
	else  
		session[:error] = "#{params[:filename]} does not exist"
		redirect "/"
	end  
end 

get '/:file/edit' do 
"your about to edit"
end 

