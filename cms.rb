# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'tilt/erubis'

# original use root = File.expand_path("..", __FILE__)
root = File.expand_path(__dir__)

get '/' do
  @files = Dir.glob(root + '/data/*').map do |path|
    File.basename(path)
  end
  erb :index
end
