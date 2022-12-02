def usage
  puts "compare_directories.rb before after"
  puts "\tbefore - directory"
  puts "\tafter - directory"
  exit
end

if ARGV.length < 2 || !File.directory?(ARGV[0]) || !File.directory?(ARGV[1])
  usage
end


before_dir = File.expand_path(ARGV[0])
after_dir = File.expand_path(ARGV[1])
before_list=Hash[Dir[File.join(before_dir, '**', '*')].map { |path|  [path[before_dir.length..-1], File.size(File.expand_path(path))]}]
after_list=Hash[Dir[File.join(after_dir, '**', '*')].map { |path| [path[after_dir.length..-1], File.size(File.expand_path(path))]}]

intersections = before_list.keys & after_list.keys

puts "Before directory #{before_dir}, after directory #{after_dir}"

intersections.each do |location|
  if before_list[location] != after_list[location] && !File.directory?(File.join(before_dir, location))
    puts "File #{location}: Before size #{before_list[location]} After size #{after_list[location]}"
  end
end

puts "\n\nAdded files:"
added = after_list.keys - before_list.keys
added.each do |location|
  unless File.directory?(File.join(before_dir, location))
    puts "File #{location} added"
  end
end
