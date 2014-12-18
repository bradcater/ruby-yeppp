require 'mkmf'

home_dir = `echo $HOME`.strip
dirs = [
  File.join(home_dir, 'yeppp-1.0.0/library/headers'),
  File.join(home_dir, 'yeppp-1.0.0/binaries/linux/x86_64')
]

dirs.each{|d| puts d}

extension_name = 'ryeppp'
dir_config(extension_name)
dir_config('yeppp-1.0.0',
  # Include paths.
  dirs,
  # Library paths.
  dirs
)
if have_library('yeppp')
  create_makefile(extension_name)
else
  puts 'No Yeppp! support available.'
end
