script "save_config-sounds" do
  interpreter "ruby"
  code <<-EOH
require "fileutils"
include FileUtils
require "ftools"

x= File.directory?("/usr/local/freeswitch")
y= File.directory?("/opt/freeswitch")

folder = [x, y]
found = folder.index(true)

if found == 0
found = "/usr/local/freeswitch/"
end

if found == 1
found = "/opt/freeswitch/"
end

time = Time.now.strftime("-%Y%B%d")
time1 = Time.now.strftime("%d").to_i - 1
time_minus_1 = Time.now.strftime("-%Y%B").to_s + time1.to_s

system "tar czf /tmp/save-conf-$(date +%Y%B%d).tar.gz " + found.to_s + "conf"
system "tar czf /tmp/save-sounds-$(date +%Y%B%d).tar.gz " + found.to_s + "sounds"

EOH
end
