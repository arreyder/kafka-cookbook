#
# Cookbook Name:: kafka
# Recipe:: _coordinate
#

ruby_block 'coordinate-kafka-start' do
  block do
    Chef::Log.debug 'Default recipe to coordinate Kafka start is used'
  end
  action :nothing
  notifies :restart, 'service[kafka]', :delayed
end

service 'kafka' do
  provider kafka_init_opts[:provider]
  if node.kafka.init_style == 'runit'
    supports start: false, stop: true, restart: true, status: true
  else
    supports start: true, stop: true, restart: true, status: true
  end 
  action kafka_service_actions
end

