require "ttylenium"
bro = TTYlenium.new
TTYlenium.connect_and_cd "~/.ssh"

bro.keyboard.type "cat id_rsa.pub\n"
TTYlenium.wait_for_still_frame
require "pp"
pp TTYlenium.get_current_lines
