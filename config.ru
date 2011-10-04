$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'artwork/rack/date_header'
require 'artwork/server'

use Artwork::Rack::DateHeader
run Artwork::Server.new
