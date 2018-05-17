#! /usr/local/bin/ruby
# 閾値を超えているかチェックする
require 'time'
require 'twilio-ruby'
require 'uri'

include ApplicationHelper  # for send_message

Device.all.each do |d|
  log = Temp.where(device_id: d.id).order(:updated_at).last
  next if log.nil?
  now = Time.now
  print "device_id:#{d.id} ts:#{log.updated_at} temp: #{log.temperature}"
  msg = "#{now.hour}時#{now.min}分 #{d.name} "
  addresses = Address.where(device_id: d.id, active: true)
  if log.updated_at < now - Mailer::MAX_DELAY.minute
    puts " [too old]"
    msg += "データの受信を確認できません。最終受信日時は、#{log.updated_at.hour}時#{log.updated_at.min}分です。"
  elsif d.temp_max < log.temperature
    puts " [over]"
    if d.custom_msg_over.blank?
      msg += "#{log.temperature}°Cです。設定を上回りました。"
    else
      msg += d.custom_msg_over
    end
  elsif d.temp_min > log.temperature
    puts " [under]"
    if d.custom_msg_under.blank?
      msg += "#{log.temperature}°Cです。設定を下回りました。"
    else
      msg += d.custom_msg_under
    end
  else
    puts " [fine]"
    addresses = []
  end
  if addresses.count > 0
    send_message(addresses, msg, true)
  end
end
