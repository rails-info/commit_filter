# commit_filter

For reviewing the referenced commits of a story or task, you have to include the issue ID as a hashtag in the commit message, I needed a better overview than just a flat list of commits.

I want to group the commits by file. In case of Rails apps I also want to group files with commits by the following categories: library, model, controller, javascript, view, tests, configuration and misc.

Therefor I implemented the Ruby gem [commit_filter](http://rubygems.org/gems/commit_filter) for Rails apps which renders filter results e.g. about commits referencing [issue #56](https://github.com/home-page/home_page/issues/56) like this:

![Commit filter interface](http://i.imgur.com/9RBLjld.png)

Each commit is linked to a blame page and you get code diffs in a modal.

# Installation

## As a plugin

Add it to a development group in the Gemfile of your Rails 4 App:

```ruby
group :development do
  gem 'commit_filter', '~> 0.1.1'
end
```

Mount it to your desired path or just root through the routes file:

```ruby
mount CommitFilter::Engine => '/'
```

Have I mentioned that the Gem requires Twitter Bootstrap 3 ;-) But it's easy to write a new frontend framework adapter through inheritance.
So if your Gemfile does not include Twitter Bootstrap 3 then add it through the development group: gem 'bootstrap-sass', '~> 3.3.4.1' (How to setup CSS and JS manifest files can be found [>> here <<](https://github.com/twbs/bootstrap-sass))

If your application manifest files does not include Twitter Bootstrap 3 then you should point the gem to the CSS and JS manifest files which do through an initializer file:

```ruby
CommitFilter.configure do |config|
  config.manifest_file = 'twitter_bootstrap'
end
```

Start the Rails server and then you'll find the filter under this path: /commit/filters/new 

## As a standalone Application

```bash
git clone git@github.com:rails-info/rails_info_application.git
cd rails_info_application
bundle install
```

Start the Rails server and then you'll find the filter under this path: /rails/info/commit/filters/new 

# Configuration

If you like to set default values for the filter form then you can set them through an initializer file:

```ruby
CommitFilter.configure do |config|
  config.attribute_name = 'value'
end
```

All available configuration options can be found [>> here <<](https://github.com/rails-info/commit_filter/blob/master/lib/commit_filter.rb).

# Remote Repositories

All repositories and branches have to be checked out locally before filtering. I would also like to access remote GitHub repositories without local checkout but GitHub has no API for commit search and paginating over commits like in local environment is too expensive - rate limit.

P.S.: I recommend to limit the result by a time span for faster queries.
