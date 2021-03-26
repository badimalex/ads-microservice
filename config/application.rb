class Application < Sinatra::Base
  configure do
    register Sinatra::Namespace

    set :app_file, File.expand_path('../config.ru', __dir__)
  end

  configure :development do
    register Sinatra::Reloader

    set :show_exceptions, false
  end

  get '/' do
    json page_size: Settings.pagination.page_size
  end
end
