#! /usr/local/bin/ruby
# 閾値を超えているかチェックする
require 'time'

class TmprCheck

  def self.execute
    if(ARGV[-1] == nil || ARGV[-1] == "" || ARGV[-1].to_i.to_s != ARGV[-1].to_s)
      puts "raspberrypiIDを指定してください。"
      return
    end

    id = ARGV[-1].to_i
    setting = Setting.where(raspi_id: id)
    tmpr_logs = TmprLog.where(raspi_id: id)
    logs = tmpr_logs.order(:time_stamp).last

    now = Time.now
    puts logs.temperature
    if setting.first.max_tmpr < logs.temperature
      send_mail(id, "#{now.hour}時#{now.min}分 #{logs.temperature}°Cです。設定値を上回りました。")
    elsif setting.first.min_tmpr > logs.temperature
      send_mail(id, "#{now.hour}時#{now.min}分 #{logs.temperature}°Cです。設定値を下回りました。")
    end
  end

  def self.send_mail(id, msg)
    addresses = Address.where(raspi_id: id)
    now = DateTime.now
    addresses.each do |address|
      next if (address.active != true)
      ts = MailLog.where(address_id: address.id, delivered: true).maximum(:time_stamp)
      d_flg = false
      if ts.nil? || ts + address.snooze.minute < now
        d_flg = true
        cmd = "echo '#{msg}' | sendmail #{address.mail}"
        puts cmd
        system(cmd)
      end
      MailLog.create(address_id: address.id, time_stamp: now, delivered: d_flg)
    end
  end
end

TmprCheck.execute
