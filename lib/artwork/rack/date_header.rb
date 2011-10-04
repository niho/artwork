module Artwork
  module Rack
    class DateHeader
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        headers['Date'] ||= Time.now.httpdate
        [status, headers, body]
      end
    end
  end
end
