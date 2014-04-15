#
# Cookbook Name:: scala
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "#{node['scala']['root_src_work']}" do
    owner "root"
    action :create
    not_if "ls #{node['scala']['root_src_work']}"
end

script "install_scala" do
    interpreter "bash"
    user "root"
    cwd "#{node['scala']['root_src_work']}"
    code <<-EOH
        wget http://www.scala-lang.org/files/archive/scala-#{node['scala']['version']}.tgz
        tar zxvf scala-#{node['scala']['version']}.tgz
        mv scala-#{node['scala']['version']} #{node['scala']['prefix']}/
        ln -s #{node['scala']['prefix']}/scala-#{node['scala']['version']} #{node['scala']['prefix']}/scala
    EOH
    not_if "ls #{node['scala']['prefix']}/scala-#{node['scala']['version']}"
end

# add_path_users should be defined key-value hash
#node['scala']['add_path_users'].each do |user|
node['scala']['add_path_users'].each do |user,home|
    execute "add_path_#{user}" do
        user "#{user}"
        command "echo \"export PATH=#{node['scala']['prefix']}/scala/bin:$PATH\" >> #{home}/.bash_profile"
        action :run
        not_if "grep scala #{home}/.bash_profile"
    end
end
