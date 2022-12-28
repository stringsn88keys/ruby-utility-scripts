#!/usr/bin/env ruby

require 'time'
require 'tzinfo'
require 'colorize'

def usage
  puts %q(
  usage:
    convert_times {time string to parse, spaces ok}
    Examples:
      convert_times now # convert for now
      convert_times 13:30 # parses as local time "today"
      convert_times 2022-04-21 13:30 # parse as local time
      convert_times 2022-04-21 13:30 -0500 # parse as -0500 offset
  )
end

if ARGV.length == 0
  usage
  exit
end



arg_time=ARGV.join(' ')
the_time=arg_time=~/now/ ? Time.now : Time.parse(arg_time)
puts ("=" * 80).colorize(:light_white)
puts "Input time: #{the_time}".colorize(:light_white)
puts ("=" * 80).colorize(:light_white)

LOCAL_TIME='America/New_York'

#  keys are the description of the time for display
#  values are time zone identifiers
#  (use TZInfo::Timezone.all_identifiers to find a valid time zone identifier)
#  or [Wikipedia List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

time_zone_hash = {
  "UTC" => 'Etc/GMT',
#  "Brazil" => 'America/Sao_Paulo',
  "Your time" => LOCAL_TIME,
#  "Datadog" => LOCAL_TIME,
  "Slack alerts" => LOCAL_TIME,
#  "Database" => 'Etc/GMT',
#  "Kansas City" => 'America/Chicago',
#  "Denver" => 'America/Denver',
  "Bangladesh" => 'Asia/Dhaka',
  "India" => 'Asia/Kolkata',
  "Seattle" => 'America/Los_Angeles'
}


puts "database timestamps are in UTC".colorize(:light_red)
time_zone_hash.each do |k,v|
  tz=TZInfo::Timezone.get(v)
  string="#{k}: => #{tz.to_local(the_time)}"

  case k
  when "UTC"
    puts string.colorize(color: :black, background: :light_green)
  when "Your time"
    puts string.colorize(:light_green)
  else
    puts string
  end
end
