# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'tilt/erubis'
require 'redcarpet'

# original use root = File.expand_path("..", __FILE__)
root = File.expand_path(__dir__)

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, escape_html: true
end

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

def load_file_content(path)
  content = File.read(path)
  case File.extname(path)
  when '.txt'
    headers['Content-Type'] = 'text/plain'
    content
  when '.md'
    render_markdown(content)
  end
end

get '/' do
  @files = Dir.glob(root + '/data/*').map do |path|
    File.basename(path)
  end
  erb :index
end

get '/:filename' do
  file_path = root + '/data/' + params[:filename]
  if FileTest.exist?(file_path)
    load_file_content(file_path)
  else
    session[:error] = File.basename(file_path) + ' does not exist.'
    redirect '/'
  end
end
