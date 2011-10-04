require File.expand_path('test/test_helper')
require 'artwork/server'

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Artwork::Server.new
  end

  def test_small_jpg
    get "/1_small.jpg"
    assert_equal 200, last_response.status
    assert_equal 'image/jpeg', last_response.content_type
  end

end
