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


ruby_block "copy dotfiles" do
  block do
    Dir.glob("#{dotdir}/.*") do |curr_path|
      destination_file = "#{home}/#{Pathname.new(curr_path).basename}"
      if !::File.exists?(destination_file) and ::File.file?(curr_path)
        ::FileUtils.copy("#{curr_path}", destination_file)
        ::FileUtils.chown_R username, username, destination_file
      end
    end
  end
end
