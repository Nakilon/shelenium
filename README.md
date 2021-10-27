# Shelenium

## Why

It is easy to automate applications that print to STDOUT and STDERR in a straight-forward way, but how to deal with fancy dialogs of tty-prompt and cli-ui? Or how to know what user sees in a Nethack game session?

Shelenium is a tool that provides an interface to shell session as simple as a two-dimensional array of currently shown characters. It is also cross-platform and does not depend on any proprietary terminal emulators.

## How

Shelenium needs a Chrome browser to be preinstalled -- it is used to run the [Secure Shell extension](https://chrome.google.com/webstore/detail/secure-shell/iodihamcpbpeioajjeobimgagajmlibd) that provides the read/write interface and the shell session via establishing the SSH connection to the localhost. The browser extension weighs ~40 MB so it is not packaged into the gem and is being downloaded on the first run to the current working directory.

## Notes

It currently uses the password login (that should not be a problem on dev machine). Also, it is currently working/tested only in a headfull browser mode, but with xvfb it should be possible to run it headless for test automation purposes.

Use the fork of Ferrum:

```ruby
gem "ferrum", github: "nakilon/ferrum"
```

to fix [the bug](https://github.com/rubycdp/ferrum/issues/203) otherwise the terminal area does not fit into the browser window.

## Examples

### ["Hello world" example](examples/hello)

```
$ git clone https://github.com/Nakilon/shelenium.git
$ cd examples/hello
$ bundle install
$  SHELENIUM_PASSWORD=... bundle exec ruby main.rb
```

It will launch Chrome and in few seconds you'll see the example result of the `Shelenium.get_current_lines` call printed, ending with prompt:

```none
["Welcome to \"Secure Shell\" version 0.43.",
 ...
 "naki:~ nakilon$ cd /Users/nakilon/.ssh",
 "naki:.ssh nakilon$ cat id_rsa.pub",
 "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyqfb/JsmNKlCSCC9F+VhG0tsxHhGEMMIyjpenIX97cPKjC6SL1S0APoxta7YdHgOYwOD76n3VuJoOSAcQ0FeY6i+PmONnrfAXFrpknyr1e6FwWyNQACZj+df7nowLy8l5AmLpy2U8gd6zpCN/0SPaeyxLcouBNgEU+AfItsJqg8dN2pMsJAH5eGAflWqBlPUhRlqXhxQHTrY2WAbiHoxrSj9becaWa3aL8k2wTS3TVpGQGAgzNYNa4bSrm70mPJvUvReP13KymfJkKoRv/7ZgQBCD7pHDf0tu0kwh0CE4RvsydARHbsKIYeZh70v7YYBGZ48tvOqov9A6ztQ1u9YR nakilon@gmail.com",
 "naki:.ssh nakilon$ "]
```

### Umoria bot

[This bot](examples/umoria) plays a roguelike game [Umoria](https://github.com/dungeons-of-moria/umoria).

It descends to lower levels and activates the torch. Opening the doors and going through enemies is not implemented.

You can find there the second thread that when activated continuously dumps the screen to a [JSONL](https://en.wikipedia.org/wiki/JSON_streaming) file that can then be converted to [ttyrec](https://en.wikipedia.org/wiki/Ttyrec) to be played with usual tools or to be embedded in HTML [like this](https://unsteadyhoneydewrelationalmodel.nakilon.repl.co/).
