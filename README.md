# Middleman

This is a generic Middleman engine used to launch Middleman apps on [Nanobox](http://nanobox.io). The engine automatically creates a web component named `web.middleman` that includes an Nginx webserver. The engine auto-detects your Middleman `build_dir` specified in your `config.rb`.

## Usage
To use this engine, specify the engine in your boxfile.yml:

```yaml
code.build:
  engine: middleman
```

## Build Process
- `bundle install`
- `bundle clean`
- `bundle exec middleman build`

## Basic Configuration Options

This engine exposes configuration options through the [boxfile.yml](http://docs.nanobox.io/app-config/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

#### Overview of Basic Boxfile Configuration Options
```yaml
code.build:
  # Ruby Settings
  ruby_runtime: ruby-2.2

  # Nginx Settings
  force_https: false
```

##### Quick Links
[Ruby Settings](#ruby-settings)   
[Web Server Settings](#web-server-settings)

### Ruby Settings
The following setting allows you to define your Middleman runtime environment.

---

#### ruby_runtime
Specifies which Middleman runtime and version to use. The following runtimes are available:

- ruby-1.9
- ruby-2.0
- ruby-2.1
- ruby-2.2 *(default)*
- ruby-2.3
- jruby-1.6
- jruby-1.7
- jruby-9.0

```yaml
code.build:
  config:
    ruby_runtime: 'ruby-2.2'
```

---

### Web Server Settings
The following setting is used to configure Nginx in your application.

---

#### force_https
Forces all incoming web requests to use https.

```yaml
code.build:
  config:
    force_https: false
```

---

## Help & Support
This is a generic (non-framework-specific) Middleman engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-ruby/issues/new).
