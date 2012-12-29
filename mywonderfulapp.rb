require 'sinatra'
require 'omniauth-facebook'

enable :sessions

def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

#Here you have to put your own Application ID and Secret
APP_ID = "361975877195880"
APP_SECRET = "1b52480c74a72caaa588e5ce85fdee9b"

use OmniAuth::Builder do
  provider :facebook, APP_ID, APP_SECRET, { :scope => 'email, status_update, publish_stream' }
end

get_or_post '/' do
    @articles = []
    @articles << {:title => 'Deploying Rack-based apps in Heroku', :url => 'http://docs.heroku.com/rack'}
    @articles << {:title => 'Learn Ruby in twenty minutes', :url => 'http://www.ruby-lang.org/en/documentation/quickstart/'}

    erb :index
end

get_or_post '/auth/facebook/callback' do
  session['fb_auth'] = request.env['omniauth.auth']
  session['fb_token'] = session['fb_auth']['credentials']['token']
  session['fb_error'] = nil
  redirect '/'
end

get_or_post '/auth/failure' do
  clear_session
  session['fb_error'] = 'In order to use this site you must allow us access to your Facebook data<br />'
  redirect '/'
end

get_or_post '/logout' do
  clear_session
  redirect '/'
end

def clear_session
  session['fb_auth'] = nil
  session['fb_token'] = nil
  session['fb_error'] = nil
end