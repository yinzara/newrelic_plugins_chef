# verify ruby dependency
verify_ruby 'Twilio Plugin'

# check required attributes
verify_attributes do
  attributes [
    'node[:newrelic][:license_key]', 
    'node[:newrelic][:twilio][:install_path]',
    'node[:newrelic][:twilio][:user]',
    'node[:newrelic][:twilio][:account_sid]',
    'node[:newrelic][:twilio][:auth_token]'
  ]
end

verify_license_key node[:newrelic][:license_key]

install_plugin 'newrelic_twilio_plugin' do
  plugin_version   node[:newrelic][:twilio][:version]
  install_path     node[:newrelic][:twilio][:install_path]
  plugin_path      node[:newrelic][:twilio][:plugin_path]
  download_url     node[:newrelic][:twilio][:download_url] 
  user             node[:newrelic][:twilio][:user]
end

# newrelic template
template "#{node[:newrelic][:twilio][:plugin_path]}/config/newrelic_plugin.yml" do
  source 'twilio/newrelic_plugin.yml.erb'
  action :create
  owner node[:newrelic][:twilio][:user]
  notifies :restart, 'service[newrelic-twilio-plugin]'
end

# install bundler gem and run 'bundle install'
bundle_install do
  path node[:newrelic][:twilio][:plugin_path]
  user node[:newrelic][:twilio][:user]
end

# install init.d script and start service
plugin_service 'newrelic-twilio-plugin' do
  daemon          './bin/newrelic_twilio'
  daemon_dir      node[:newrelic][:twilio][:plugin_path]
  plugin_name     'Twilio'
  plugin_version  node[:newrelic][:twilio][:version]
  user            node[:newrelic][:twilio][:user]
  run_command     'bundle exec'
end
