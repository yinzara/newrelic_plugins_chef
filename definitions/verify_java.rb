define :verify_java do
  # check java dependency
  unless node[:languages][:java] && node[:languages][:java][:version].start_with?('1.6', '1.7')
    Chef::Application.fatal!("The New Relic #{params[:name]} requires a Java version >= 1.6 -" +
      " For more information, see https://docs.newrelic.com/docs/plugins/installing-a-plugin")
  end
end