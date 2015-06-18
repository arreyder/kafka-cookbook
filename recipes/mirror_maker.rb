#
# Cookbook Name:: kafka
# Recipe:: mirror_maker
#

include_recipe 'kafka::_defaults'
include_recipe 'kafka::_setup'
include_recipe 'kafka::_install'

directory node.kafka.log_dir do
  owner node.kafka.user
  group node.kafka.group
  mode '755'
  recursive true
end

node.mirror_maker.consumers.each do |config_file, options|
  template ::File.join(node.kafka.install_dir, 'config', config_file) do
    source 'source_cluster_consumer.properties.erb'
    owner node.kafka.user
    group node.kafka.group
    mode '644'
    variables options: options
  end
end

template ::File.join(node.kafka.install_dir, 'config', node.mirror_maker.producer.config_file) do
  source 'target_cluster_producer.properties.erb'
  owner node.kafka.user
  group node.kafka.group
  mode '644'
  variables options: node.mirror_maker.producer
end

kafka_script 'Prepare environment for Kafka MirrorMaker' do
  name 'mirror_maker'
  main_class mirror_maker_args
  options node.mirror_maker
end

service 'mirror_maker' do
  provider kafka_init_opts[:provider]
  supports start: true, stop: true, restart: true, status: true
  action kafka_service_actions
end
