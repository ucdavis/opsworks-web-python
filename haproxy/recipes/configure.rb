service "haproxy" do
  provider node['haproxy_service_provider']
  supports :restart => true, :status => true, :reload => true
  action :nothing # only define so that it can be restarted if the config changed
  ignore_failure true # Newer Ubuntus don't support action :nothing
end

template "/etc/haproxy/haproxy.cfg" do
  cookbook "plone_buildout"
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[haproxy]"
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  provider node['haproxy_service_provider']
  not_if "pgrep haproxy"
  notifies :start, "service[haproxy]"
end
