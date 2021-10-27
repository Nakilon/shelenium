require "byebug"
require "pp"

ENV["SHELENIUM_PASSWORD"] = File.read "password"
require "shelenium"
br = Shelenium.new
Shelenium.connect_and_cd "~/Downloads/umoria/"

Thread.new do
  file = File.open "rec.jsonl", "w"
  begin
    loop do
      file.puts JSON.dump [
        Time.now.to_f,
        Thread.main.backtrace_locations.find{ |_| __FILE__ == _.path }.lineno,
        br.evaluate("term_.getRowsText(0, term_.getRowCount())"),
      ]
      sleep 0.1
    end
  ensure
    file.close
  end
end unless true

assert_equal = lambda do |a, b|
  next if a == b
  pp Shelenium.get_current_lines
  br.screenshot path: "fail.png"
  puts "#{a.inspect} != #{b.inspect}"
  byebug
  byebug
end

type = lambda do |*what|
  what.each do |what|
    puts "type: #{what.inspect}"
    br.keyboard.type what
  end
end

loop do
  type.call "./umoria\n"

  assert_equal.call "                       [ press any key to continue ]", Shelenium.wait_for_still_frame(3, 2).last
  type.call :escape

  lines = Shelenium.wait_for_still_frame
  unless "  <f>ile character description. <c>hange character name." == lines.last
    if "Save file 'game.sav' present. Attempting restore." == lines.last
      if ["Restoring Memory of a departed spirit...  -more-", ""] == lines.first(2)
        type.call :escape
      else
        assert_equal.call [
          "Error during reading of file.  -more-",
          "Please try again without that save file.",
        ], Shelenium.get_current_lines.first(2)
        type.call :escape
        Shelenium.wait_for_still_frame
        type.call "rm game.sav\n"
        next
      end
    end
    assert_equal.call "  Choose a race (? for Help):", Shelenium.wait_for_still_frame[-3]
    type.call ?a
    assert_equal.call "  Choose a sex (? for Help): ", Shelenium.wait_for_still_frame[-2]
    type.call ?m
    assert_equal.call "  Hit space to re-roll or ESC to accept characteristics: ", Shelenium.wait_for_still_frame[-1]
    type.call :escape
    assert_equal.call "  Choose a class (? for Help):", Shelenium.wait_for_still_frame[-3]
    type.call ?a
    assert_equal.call "  Enter your player's name  [press <RETURN> when finished]", Shelenium.wait_for_still_frame[-1]
    type.call "bot\n"
    assert_equal.call "                 [ press any key to continue, or Q to exit ]", Shelenium.wait_for_still_frame[-1]
  end
  type.call :escape

  get_map = lambda do
    case lines[-1]
    when "                                                                 Town level"
      assert_equal.call "             ##################################################################", lines[1]
      assert_equal.call "             ##################################################################", lines[-2]
      lines[1..-2].map{ |_| _.ljust(79," ")[13..78] }
    when "                                                                 50 feet",
         "                                                                 100 feet"
      if ?@ == lines[1,22].map{ |_| _.ljust(79," ")[13..78] }.join.strip
        type.call "iw"
        type.call Shelenium.wait_for_still_frame.drop(1).join("\n").scan(/ ([a-z])\) (.+)/).find{ |k,v| v[" Torches "] }.first
        type.call :escape, :escape
      else
        lines[1..-2].map{ |_| _.ljust(79," ")[13..78] }  # make it wait for change?
      end
    else
      fail lines[-1].inspect
    end
  end

  lines = Shelenium.wait_for_still_frame
  if "(ESC to abort, return to print on screen, or file name)" == lines[-1]
    type.call :escape, :escape
    next
  end
  assert_equal.call "                                                               Press ? for help", lines.first
  mem = {}
    type_and_wait_for_change = lambda do |what|
      old = lines.dup
      type.call what
      Timeout.timeout(1){ nil until old != lines = Shelenium.get_current_lines }
    end
  loop do
    map = get_map.call
    find = ->w{ [map.index{ |_| _[w] }, map.map{ |_| _.index w }.find(&:itself)] }
    me = find[?@]
    y2, x2 = find[?>]
    if y2
      stack = [[me, []]]
      past = []
      loop do
        fail if stack.empty?
        (y1, x1), path = stack.pop
        next if past.include? [y1, x1]
        past.push [y1, x1]
        break path if [y1, x1] == [y2, x2]
        [
          [y1-1, x1-1, ?7], [y1-1, x1, ?8], [y1-1, x1+1, ?9],
          [y1  , x1-1, ?4],                 [y1  , x1+1, ?6],
          [y1+1, x1-1, ?1], [y1+1, x1, ?2], [y1+1, x1+1, ?3],
        ].select{ |y, x,| %{ . > }.include? map[y][x] if 0 <= y && y < map.size && 0 <= x && x < map[0].size }.
          sort_by{ |y, x,| (y2 - y).abs + (x2 - x).abs }.
          reverse_each{ |y, x, d| stack.push [[y, x], [*path, d]] unless stack.any?{ |(sy, sx), _| [sy, sx] == [y, x] } }
      end.each do |d|
        type_and_wait_for_change.call d
        Timeout.timeout 1 do
          loop do
            lines = Shelenium.get_current_lines
            map = get_map.call
            break if find[?@] != me
          end
        end
        me = find[?@]
        case lines.first
        when ""
        when "The Mean-Looking Mercenary hits you.  -more-"
        when "The Blubbering Idiot drools on you."
        else
pp lines
byebug
byebug
        end
      end
      type.call ?>
      lines = Shelenium.wait_for_still_frame
    else
      type.call "l5"
      case Shelenium.wait_for_still_frame.first
      when "You are on a down staircase. ---pause---"
        type.call ?>   # for some reason descending does not need to abort the look
        lines = Shelenium.wait_for_still_frame
      when "You see nothing of interest.",
           "You see a Giant Yellow Centipede. [(r)ecall]",
           "You see a Novice Priest. [(r)ecall]",
           "You see a Large White Snake. [(r)ecall]",
           "You see a Gnome Skeleton. ---pause---",
           "You see an open door. ---pause---",
           "You see a Kobold. [(r)ecall]",
           "You are on an open door. ---pause---",
           "You see a Silver-Plated Wand. ---pause---"
        type.call :escape, :escape
pp map
        type_and_wait_for_change.call( (
        stack = [[me, []]]
        past = []
          loop do
          if stack.empty?
            byebug
            byebug
          end
          (y1, x1), path = stack.shift
          break path.first if map[y1][x1] == ?\s && !mem[[y1,x1]]
          next if past.include? [y1, x1]
          past.push [y1, x1]
          [
            [y1-1, x1-1, ?7], [y1-1, x1, ?8], [y1-1, x1+1, ?9],
            [y1  , x1-1, ?4],                 [y1  , x1+1, ?6],
            [y1+1, x1-1, ?1], [y1+1, x1, ?2], [y1+1, x1+1, ?3],
          ].select do |y, x,|
            next unless 0 <= y && y < map.size && 0 <= x && x < map[0].size
            next mem[[y,x]] = true if ?. == map[y][x]
            ?\s == map[y][x]
          end.each{ |y, x, d| stack.push [[y, x], [*path, d]] unless stack.any?{ |(sy, sx), _| [sy, sx] == [y, x] } }
        end
        ) )
      else
p Shelenium.wait_for_still_frame.first
byebug
byebug
      end
    end
  end

end
