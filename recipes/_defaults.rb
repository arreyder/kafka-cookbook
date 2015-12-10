#
# Cookbook Name:: kafka
# Recipe:: _defaults
#

unless broker_attribute?(:broker, :id)
  node.default.kafka.broker.broker_id = node.ipaddress.gsub('.', '').to_i % 2**31
end

# port property does not play nice with listeners property in kafka 0.9.*
unless ( broker_attribute?(:port) || broker_attribute?(:listeners) )
  node.default.kafka.broker.port = 9092 
end

unless node.kafka.gc_log_opts
  node.default.kafka.gc_log_opts = %W[
    -Xloggc:#{node.kafka.log_dir}/kafka-gc.log
    -XX:+PrintGCDateStamps
    -XX:+PrintGCTimeStamps
  ].join(' ')
end

unless node.kafka.config_dir
  node.default.kafka.config_dir = ::File.join(node.kafka.install_dir, 'config')
end

unless node.kafka.version_install_dir
  node.default.kafka.version_install_dir = %(#{node.kafka.install_dir}-#{node.kafka.version})
end
