# Shelenium

## Why

It is easy to automate applications that print to STDOUT and STDERR in a straight-forward way, but how to deal with fancy dialogs of tty-prompt and cli-ui? Or how to know what user sees in a Nethack game session?

Shelenium is a tool that provides an interface to shell session as simple as a two-dimensional array of currently shown characters. It is also cross-platform and does not depend on any proprietary terminal emulators.

## How

Shelenium needs a Chrome browser to be preinstalled -- it is used to run the [Secure Shell extension](https://chrome.google.com/webstore/detail/secure-shell/iodihamcpbpeioajjeobimgagajmlibd) that provides the read/write interface and the shell session via establishing the SSH session to localhost.

Note: It currently uses the password login that should not be a problem on dev machine. Also, it currently works/tested only in a headfull browser session.

## Example

See the [hello world example](examples/hello):

```
$ cd examples/hello
$ bundle install
$  SHELENIUM_PASSWORD=... bundle exec ruby main.rb
```

It will launch Chrome and in few seconds you'll see the example result of the `Shelenium.get_current_lines` call printed, ending with prompt:

["Welcome to \"Secure Shell\" version 0.43.",
 ...
 "naki:~ nakilon$ cd /Users/nakilon/.ssh",
 "naki:.ssh nakilon$ cat id_rsa.pub",
 "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyqfb/JsmNKlCSCC9F+VhG0tsxHhGEMMIyjpenIX97cPKjC6SL1S0APoxta7YdHgOYwOD76n3VuJoOSAcQ0FeY6i+PmONnrfAXFrpknyr1e6FwWyNQACZj+df7nowLy8l5AmLpy2U8gd6zpCN/0SPaeyxLcouBNgEU+AfItsJqg8dN2pMsJAH5eGAflWqBlPUhRlqXhxQHTrY2WAbiHoxrSj9becaWa3aL8k2wTS3TVpGQGAgzNYNa4bSrm70mPJvUvReP13KymfJkKoRv/7ZgQBCD7pHDf0tu0kwh0CE4RvsydARHbsKIYeZh70v7YYBGZ48tvOqov9A6ztQ1u9YR nakilon@gmail.com",
 "naki:.ssh nakilon$ "]
```

Note: use the fork of Ferrum:

```ruby
gem "ferrum", github: "nakilon/ferrum"
```

to fix [the bug](https://github.com/rubycdp/ferrum/issues/203).
