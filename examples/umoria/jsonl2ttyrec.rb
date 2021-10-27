File.open "rec.ttyrec", "wb" do |file|
  require "json"
  $<.each do |line|
    timestamp, lineno, text = JSON.load(line)
    text = "\033[2J" + text.split("\n").map.with_index{ |e,i| "\033[#{i};0H#{e}" unless e.empty? }.join
    file.print [timestamp.to_i, (timestamp*1000000)%1000000, text.bytesize].pack("I<I<I<")
    file.print text
  end
end
