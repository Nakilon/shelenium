require "Shelenium"
bro = Shelenium.new
Shelenium.connect_and_cd "~/.ssh"

bro.keyboard.type "cat id_rsa.pub\n"
Shelenium.wait_for_still_frame
require "pp"
pp Shelenium.get_current_lines
