# Time::DATE_FORMATS.merge!({ :default => '%Y-%m-%d %H:%M:%S' })
# Date::DATE_FORMATS.merge!({ :default => '%Y-%m-%d' })
Time::DATE_FORMATS[:default] = '%Y-%m-%d %H:%M:%S'
Date::DATE_FORMATS[:default] = '%Y-%m-%d'
Time::DATE_FORMATS[:time] = '%H:%M:%S'
Time::DATE_FORMATS[:time_short] = '%H:%M'

Time::DATE_FORMATS[:humane] = lambda do |date|
  now = Time.now
  if now.strftime("%m-%d") == date.strftime("%m-%d")
    "今天 #{date.to_s(:time)}"
  elsif now.yesterday.strftime("%m-%d") == date.strftime("%m-%d")
    "昨天 #{date.to_s(:time)}"
  else
    date.strftime("%m-%d %H:%M")
  end
end
