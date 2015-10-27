#
# Cookbook Name:: dotfiles
# Recipe:: default
#

package 'git-core'

repo = node['dotfiles']['repo'] || ''

username = "vagrant"
home   = "/home/#{username}"
dotdir = "#{home}/.dotfiles"
git dotdir do
  repository repo
  user username
  group username
  action :sync
  only_if { File.directory?(home) }
end

Dir.glob("#{dotdir}/.*") do |curr_path|
  next if curr_path == '.' or curr_path == '..'

  file "#{home}/#{Pathname.new(curr_path).basename}" do
    owner username
    group username
    mode 0644
    content IO.read(curr_path)
    action :create
  end if File.file?(curr_path)
end
