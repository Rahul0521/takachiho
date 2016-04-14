#! /usr/local/bin/ruby
require 'date'
require 'mysql2'
require 'optparse'

Version = '1.0.0'
DIR = '/opt/bme280logs'

opt = OptionParser.new
opt.on('--all') { |v| OPTS[:all] = true }
opt.on('--daily') { |v| OPTS[:daily] = true }
opt.on('-e env') { |v| OPTS[:e] = v }

OPTS = {}
opt.parse!(ARGV)

env = OPTS[:e] || "development"
@client = Mysql2::Client.new(host:"localhost",username:"root",database:"mukoyama_#{env}")

def to_jst(ts)
  t = DateTime.parse(ts).to_time
  # t += 9 * 60 * 60
  return t.strftime("%F %T")
end

def get_id_from_dirname(dir)
  b = File.basename(dir)
  # DIR/id_name/yymmdd.log
  b.split("_")[0]
end

def parsefile(f,id)
  print f+" "
  n = 0
  fh = open(f,"r")
  fh.each do |line|
    row = line.split(",").map { |v| v.strip }
    temp = row[0]
    press = row[1]
    humid = row[2]
    ts = to_jst(row[3])
    sql = "INSERT IGNORE INTO tmpr_logs"
    sql += " (raspi_id,time_stamp,temperature,pressure,humidity)"
    sql += " VALUES (#{id},'#{ts}',#{temp},#{press},#{humid})"
    @client.query(sql)
    n += @client.affected_rows
  end
  fh.close
  puts "(%d)" % [n]
  return n
end

@daily_sql = <<EOT
INSERT IGNORE INTO tmpr_daily_logs (raspi_id,time_stamp,temperature,pressure,humidity,created_at)
SELECT raspi_id,date(time_stamp),avg(temperature),avg(pressure),avg(humidity),now()
FROM tmpr_logs GROUP BY raspi_id,date(time_stamp);
EOT

def parsedir(dir)
  id = get_id_from_dirname(dir)

  files = []
  Dir.entries(dir).sort.each do |f|
    next unless f.end_with? ".log"
    files += [f]
  end
  if OPTS[:all]
    n_rows = 0
    n_files = 0
    files.each do |f|
      n_rows += parsefile(dir+"/"+f,id)
      n_files += 1
    end
    puts "%d files scanned, %d rows added." % [n_files,n_rows]
    @client.query(@daily_sql)
  elsif OPTS[:daily]
    # Expected to run the first of the day.
    n_rows = parsefile(dir+"/"+files[-2],id)
    @client.query(@daily_sql)
  else
    n_rows = parsefile(dir+"/"+files[-1],id)
  end


  results = @client.query("SELECT max(time_stamp) AS time_stamp FROM tmpr_logs")
  results.each do |row|
    puts "Latest timestamp: %s" % [row["time_stamp"]]
  end
end

def main
  Dir.entries(DIR).sort.each do |d|
    next if d.start_with? "."
    next unless File.directory? DIR+"/"+d
    puts d
    next unless d == "1_greenhouse"
    # next unless File.exists? DIR+"/"+d
    parsedir(DIR+"/"+d)
  end
end

main
