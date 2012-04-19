# Torquebox::Webconsole

An extension to [rack-webconsole](http://codegram.github.com/rack-webconsole/) that
adds the ability to switch between application runtimes within 
[TorqueBox](http://torquebox.org/). 

## Installation

Add this line to your application's Gemfile:

    gem 'torquebox-webconsole'

Then follow the [instructions](http://codegram.github.com/rack-webconsole/) for
rack-webconsole. 

*Note:* don't add `rack-webconsole` to your Gemfile - `torquebox-webconsole`
will bring it in for you, and currently uses a fork of `rack-webconsole` pending 
a [pull request](https://github.com/codegram/rack-webconsole/pull/44) and release 
of the official gem.

## Usage

Use it just like you would `rack-console`. When in the console, the following
TorqueBox specific methods are available to you:

* `list_runtimes` - returns an array of the available runtime names
* `current_runtime` - returns the name of the runtime that the console is
  currently attached to
* `switch_runtime(name)` - attaches the console to the named runtime
* `help` - tells you about the above methods

The console will be attached to the web runtime by default, and you will
only be able to list/attach to runtimes for the current application.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
