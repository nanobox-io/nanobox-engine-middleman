# Middleman

This is a Middleman engine used to launch Middleman apps with [Nanobox](http://nanobox.io). The engine automatically creates a web component named `web.middleman` that includes an Nginx webserver. The engine auto-detects your Middleman `build_dir` specified in your `config.rb`.

## Usage
To use this engine, specify the engine in your boxfile.yml:

```yaml
run.config:
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
run.config:
  # Ruby Settings
  ruby_runtime: ruby-2.2

  # Nginx Settings
  force_https: false
  error_pages:
    - errors: 404
      page: path/to/404.html
  rewrites:
    - if: '$request_uri ~ ^/path(.*)$'
      then: 'return 301 https://another-url.com/path;'
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
run.config:
  engine.config:
    ruby_runtime: 'ruby-2.2'
```

---

### Nginx Settings
The following setting is used to configure Nginx in your application.

---

#### force_https
Forces all incoming web requests to use https.

```yaml
run.config:
  engine.config:
    force_https: false
```

---

#### error_pages
Allows you to create custom error pages. You must provide one or more error codes (`errors`) and the path to the page that Nginx should serve when those errors arise. The page path should be relative to your `build_dir` once the code is built.

```yaml
run.config:
  engine.config:
    error_pages:
      - errors: 404
        page: path/to/404.html
      - errors: 500 503
        page: path/to/5xx.html
```

---

#### rewrites
Allows you to inject rewrites into your nginx.conf. Each consists of an `if`/`then` combination. These should be provided as strings that will be included in your nginx.conf as provided. 

```yaml
run.config:
  engine.config:
    rewrites:
      - if: '$host = sub.mydomain.com'
        then: 'return 301 https://mydomain.com$request_uri;'
      - if: '$request_uri ~ ^/download(.*)$'
        then: 'return 301 https://download.mydomain.com;'
```

---

## Help & Support
This is a Middleman engine provided by [Nanobox](http://nanobox.io). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-ruby/issues/new).
