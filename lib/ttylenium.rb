module TTYlenium

  @@browser
  def self.new
    begin
      # this archive was repacked from Chrome Store on 17 Oct 2021
      require "tempfile"
      tempfile = Tempfile.new "secure_shell.zip"
      require "open-uri"
      File.binwrite tempfile, (Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5") ? Kernel : URI).open("http://md5.nakilon.pro/0f83810b3b3fb1978db3803dee52ac5e", &:read)
      require "zip"
      Zip::File.open tempfile do |zipfile|
        zipfile.each do |entry|
          "iodihamcpbpeioajjeobimgagajmlibd/#{File.dirname entry.name}".tap do |dir|
            FileUtils.mkdir_p dir
            zipfile.extract entry, "iodihamcpbpeioajjeobimgagajmlibd/#{entry.name}"
          end
        end
      end
    ensure
      tempfile.close
      tempfile.unlink
    end unless File.exist? "iodihamcpbpeioajjeobimgagajmlibd"
    require "ferrum"
    @@browser = Ferrum::Browser.new( headless: false, browser_options: {
      "disable-extensions-except" => "#{File.expand_path Dir.pwd}/iodihamcpbpeioajjeobimgagajmlibd/0.43_0",
      "load-extension"            => "#{File.expand_path Dir.pwd}/iodihamcpbpeioajjeobimgagajmlibd/0.43_0",
    } ).tap do |browser|
      browser.go_to "chrome://extensions/?id=iodihamcpbpeioajjeobimgagajmlibd"
      browser.evaluate("document.getElementsByTagName('extensions-manager')[0].shadowRoot.querySelector('extensions-detail-view').shadowRoot.querySelector('#allow-incognito').shadowRoot.querySelector('[role=button]')").click
      sleep 1
    end
  end

  def self.connect_and_cd dir
    wait_to_find_xpath = lambda do |selector, timeout: 2, &block|
      Timeout.timeout(timeout) do
        sleep 0.1 until found = (block ? block.call : br).at_xpath(selector)
        found
      end
    end
    @@browser.go_to "chrome-extension://iodihamcpbpeioajjeobimgagajmlibd/html/nassh.html##{ENV.fetch "USER"}@localhost"
    wait_to_find_xpath.call("//*[*[contains(text(),'fingerprint')]]//input"){ @@browser.frames.last }.type("yes\n")
    @@browser.execute "window.removeEventListener('beforeunload', nassh_.onBeforeUnload_)"
    wait_to_find_xpath.call("//*[*[contains(text(),'Password')]]//input"){ @@browser.frames.last }.type("#{ENV.fetch "TTYLENIUM_PASSWORD"}\n")
    @@browser.keyboard.type "cd #{Shellwords.escape File.expand_path dir}\n"
  end

  def self.get_current_lines
    @@browser.evaluate("term_.getRowsText(0, term_.getRowCount())").split("\n")
  end

  def self.wait_for_still_frame wait_time = 2, freeze_time = 1
    Timeout.timeout wait_time do
      frames = []
      until frames.last(freeze_time * 10).size == freeze_time * 10 && frames.last(freeze_time * 10).uniq.size == 1
        sleep 0.1
        frames.push get_current_lines
      end
      frames.last
    end
  end

end
