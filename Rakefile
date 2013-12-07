# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require

  require 'motion-testflight'
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'TinamiReader'
  require 'yaml'
  conf_file = './config.yml'
  if File.exists?(conf_file)
    config = YAML::load_file(conf_file)
    app.testflight.sdk        = 'vendor/TestFlightSDK'
    app.testflight.api_token  = config['testflight']['api_token']
    app.testflight.team_token = config['testflight']['team_token']

    app.info_plist['TINAMI_API'] = config['tinami']['api']

    env = ENV['ENV'] || 'development'
    app.provisioning_profile = config[env]['provisioning']
  end
end

