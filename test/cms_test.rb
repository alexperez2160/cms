ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative "../cms"

class AppTest < Minitest::Test 
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end 


	 def test_index
	    get "/"

	    assert_equal 200, last_response.status
	    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
	    assert_includes last_response.body, "about.md"
	    assert_includes last_response.body, "changes.txt"
	    assert_includes last_response.body, "history.txt"
	 end

	def test_viewing_text_document
		get "/history.txt"

		assert_equal 200, last_response.status
		assert_equal "text/plain", last_response["Content-Type"]
		assert_includes last_response.body, "Ruby 0.95 released"
	end

	def test_nonexist_file 
		get "/info.txt"
		assert_equal 302, last_response.status
		assert_includes last_response.body, "info.txt does not exist"
	end 

	def test_viewing_markdown_document
    get "/about.md"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "<h1>Ruby is...</h1>"
  end
end 
