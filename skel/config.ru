require 'rack'

here         = File.dirname(__FILE__)
static_files = Dir.glob("#{here}/**/*.{html,rss,css,js,png,jpg,jpeg,gif,ico}")

use Rack::Static, root: '.', urls: static_files.map {|path|
  path.sub(here, '')
}

map '/' do
  run ->(env) {
    if env['PATH_INFO'] == '/'
      [
        200,
        {'Content-Type'  => 'text/html', 'Cache-Control' => 'public, max-age=86400'},
        File.open(File.join(here, 'index.html'), File::RDONLY)
      ]
    else
      [404, {'Content-Type'  => 'text/plain'}, ['Not Found']]
    end
  }
end
