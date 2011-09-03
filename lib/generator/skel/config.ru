require 'rack'

use Rack::Static, root: '.', urls: %w(
  /index.html
  /profile.html
  /entries.html
  /entries.rss
  /favicon.png
  /entries
  /stylesheets
  /javascripts
  /images
)

map '/' do
  run ->(env) {
    if env['PATH_INFO'] == '/'
      [
        200,
        {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},
        File.open('index.html', File::RDONLY)
      ]
    else
      [404, {'Content-Type'  => 'text/plain'}, ['Not Found']]
    end
  }
end

