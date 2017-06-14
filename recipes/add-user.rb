#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: add-user
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

group node['get-native']['user']['primary_group']

user node['get-native']['user']['name'] do
    group node['get-native']['user']['primary_group']
    home node['get-native']['user']['home']
    manage_home true
    password node['get-native']['user']['initial_password']
    shell node['get-native']['user']['shell']
end

include_recipe 'sudo::default'

sudo node['get-native']['user']['name'] do
    user node['get-native']['user']['name']
    runas 'ALL:ALL'
    nopasswd true
end

if ENV['CI']
    db_credentials = {
        get_native_password: 'dummy-password'
    }
else
    db_credentials = data_bag_item("#{node['get-native']['environment']}-#{node['get-native']['role']}", 'db-credentials')
end

template 'Get Native user .bashrc' do
    source 'add-user/get-native-bashrc.erb'
    path "#{node['get-native']['user']['home']}/.bashrc"
    mode 0644
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    variables({
        get_native_db_password: db_credentials['get_native_password']
    })
end

template 'Root user .bashrc' do
    source 'add-user/root-bashrc.erb'
    path '/root/.bashrc'
    mode 0644
    owner 'root'
    group 'root'
end
