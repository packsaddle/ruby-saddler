# Saddler

[![Gem Version](http://img.shields.io/gem/v/saddler.svg?style=flat)](http://badge.fury.io/rb/saddler)
[![Build Status](http://img.shields.io/travis/packsaddle/ruby-saddler/master.svg?style=flat)](https://travis-ci.org/packsaddle/ruby-saddler)

**checkstyle2anywhere**, you can integrate any lint, security checker and tools with anywhere (e.g. GitHub Pull Request Review Comment.)

### Pull Request Review Comment

![Pull Request Review Comment](https://cloud.githubusercontent.com/assets/75448/6392012/842ba6e2-bdff-11e4-84c3-bc180ac199bc.png "Pull Request Review Comment")

### Pull Request Comment

![Pull Request Comment](https://cloud.githubusercontent.com/assets/75448/6392013/892d1e5a-bdff-11e4-8ffb-f8ca93507662.png "Pull Request Comment")

## Usage

```
git diff -z --name-only origin/master \
 | xargs -0 rubocop-select \
 | xargs rubocop \
     --require rubocop/formatter/checkstyle_formatter \
     --format RuboCop::Formatter::CheckstyleFormatter \
 | checkstyle_filter-git diff origin/master \
 | saddler report \
    --require saddler/reporter/github \
    --reporter Saddler::Reporter::Github::PullRequestReviewComment
```

It works!

You can run this from any CI Service (e.g. circle-ci, travis-ci, jenkins, etc).

## Reporters

* [saddler-reporter-text](https://github.com/packsaddle/ruby-saddler-reporter-text)
* [saddler-reporter-github](https://github.com/packsaddle/ruby-saddler-reporter-github)

## Demo
You can send pull request to repos below. Try this!

* TravisCI
 * [Pull Request Review Comment (RuboCop)](https://github.com/packsaddle/example-travis_ci-pull_request_review)
 * [Pull Request Comment (RuboCop)](https://github.com/packsaddle/example-travis_ci-pull_request)
 * [Pull Request Review Comment (JSCS)](https://github.com/packsaddle/example-travis_ci-pull_request_review-jscs)
* CircleCI
 * [Pull Request Review Comment (RuboCop)](https://github.com/packsaddle/example-circle_ci-pull_request_review)
 * [Pull Request Comment (RuboCop)](https://github.com/packsaddle/example-circle_ci-pull_request)
 * [Pull Request Review Comment (JSCS)](https://github.com/packsaddle/example-circle_ci-pull_request_review-jscs)

## Examples

* textlint
 * [jser/jser.github.io/test/travis-spellcheck.sh](./example/travis-spellcheck.sh)
* RuboCop
 * [packsaddle/ruby-saddler/bin/run-rubocop.sh](./example/run-rubocop.sh)

## Articles

### ja

* [jser/jser.github.ioの記事をpull request時にLintする仕組み | Web Scratch](http://efcl.info/2015/03/04/linting-article/)
* [変更したファイルにrubocopやjscsを実行して pull requestに自動でコメントする – Saddler - checkstyle to anywhere](http://packsaddle.org/articles/saddler-overview/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'saddler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install saddler

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec saddler` to use the code located in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/packsaddle/ruby-saddler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
