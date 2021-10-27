require "json"
$<.map(&JSON.method(:load)).chunk(&:last).map{ |_,(s,*)| puts JSON.dump s }
