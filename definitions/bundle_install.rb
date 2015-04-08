define :bundle_install do
  # install bundler gem
  gem_package 'bundler' do
    options '--no-ri --no-rdoc'
  end

  # bundle install
  execute 'bundle install' do
    cwd params[:path]
    command "bundle install --deployment"
    user params[:user]
    only_if { File.directory?(params[:path]) }
  end
end