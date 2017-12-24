# 使用方法[每10分钟dump一次分析一次]
# 将该文件放入initializers中
# log文件夹创建空目录dumps, 并在development环境运行
require 'objspace'
ObjectSpace.trace_object_allocations_start
module Custom
  module Debugger
    class MemoryAnalyze
      def memory_dump_objects file_name
        File.open(Rails.root.join("log/dumps/#{file_name}"), 'w') do |file|
          ObjectSpace.trace_object_allocations do
            ObjectSpace.dump_all(output: file)
          end
        end
      end

      def analyze_files files
        p "====================== Now Begin Analyze Dump Files ====================="
        first_addrs = Set.new
        third_addrs = Set.new

        # Get a list of memory addresses from the first dump
        File.open("log/dumps/#{files[0]}", "r").each_line do |line|
          parsed = JSON.parse(line)
          first_addrs << parsed["address"] if parsed && parsed["address"]
        end

        # Get a list of memory addresses from the last dump
        File.open("log/dumps/#{files[2]}", "r").each_line do |line|
          parsed = JSON.parse(line)
          third_addrs << parsed["address"] if parsed && parsed["address"]
        end

        diff = []

        # Get a list of all items present in both the second and
        # third dumps but not in the first.
        File.open("log/dumps/#{files[1]}", "r").each_line do |line|
          parsed = JSON.parse(line)
          if parsed && parsed["address"] && !(parsed["address"] =~ /[custom\_debugger\_memory\_analyze]/)
            if !first_addrs.include?(parsed["address"]) && third_addrs.include?(parsed["address"])
              diff << parsed
            end
          end
        end

        # Group items
        group_diffs = diff.group_by do |x|
          [x["type"], x["file"], x["line"]]
        end.map do |x,y|
          # Collect memory size
          [x, y.count, y.inject(0){|sum,i| sum + (i['bytesize'] || 0) }, y.inject(0){|sum,i| sum + (i['memsize'] || 0) }]
        end.sort do |a,b|
          b[1] <=> a[1]
        end

        File.open("log/debugger_memory_analyze_#{Process.pid}_#{Time.now.strftime('%m%d_%H%M%S')}", "w") do |f|
          group_diffs.each do |x,y,bytesize,memsize|
            # Output information about each potential leak
            f.write("Leaked #{y} #{x[0]} objects of size #{(bytesize.to_f/1024).round(2)}kb/#{(memsize.to_f/1024).round(2)}kb at: #{x[1]}:#{x[2]}\n")
          end
          # Also output total memory usage, because why not?
          memsize = diff.inject(0){|sum,i| sum + (i['memsize'] || 0) } / 1024.0
          bytesize = diff.inject(0){|sum,i| sum + (i['bytesize'] || 0) } / 1024.0
          f.write("\n\nTotal Size: #{bytesize.round(2)}kb/#{memsize.round(2)}kb")
        end
        p "========== Analyze Finish ========="
      end
    end
  end
end

if Dir['log/dumps'] && Rails.env.development?
  # FileUtils.rm_rf(Dir.glob('log/dumps/*'))
  Thread.new do
    loop do
      p "========== Will Analyze Memory After 20s ========="
      sleep 20
      files = []
      GC.start
      3.times do |i|
        p "====================== Begin #{i + 1} times Dump Memory PID: #{Process.pid} ====================="
        files << "dump_#{Process.pid}_#{Time.now.strftime("%m%d_%H%M%S")}"
        Custom::Debugger::MemoryAnalyze.new.memory_dump_objects(files.last)
        sleep 10 * 60 if i != 2
      end
      Custom::Debugger::MemoryAnalyze.new.analyze_files(files)
      p "========== delete Process #{Process.pid} dump files ========="
      files.each do |file|
        FileUtils.rm_rf(Dir.glob("log/dumps/#{file}"))
      end
    end
  end
end
# dump 程序三个时段的所有 objects
# 比较第一二时段新增 objects，得到一些可疑对象
# 将可疑对象与第三时段的 objects 对比，如果依然存在，很可能就是内存泄露的凶手了