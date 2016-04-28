# Saddler

[![Gem Version](http://img.shields.io/gem/v/saddler.svg?style=flat)](http://badge.fury.io/rb/saddler)
[![Build Status](http://img.shields.io/travis/packsaddle/ruby-saddler/master.svg?style=flat)](https://travis-ci.org/packsaddle/ruby-saddler)

To effectively use your lint messages!

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


## Requirement

Set `GITHUB_ACCESS_TOKEN=__your_access_token__` to your environment variable.


### TravisCI

[Travis CI: Encryption keys](http://docs.travis-ci.com/user/encryption-keys/)

```bash
$ gem install travis
$ travis encrypt -r <owner_name>/<repos_name> "GITHUB_ACCESS_TOKEN=<github_token>"
```


### CircleCI

[Environment variables - CircleCI](https://circleci.com/docs/environment-variables)


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
    * [jser/jser.github.io/test/travis-spellcheck.sh](./example/travis-spellcheck.sh) ([link](https://github.com/jser/jser.github.io/blob/6df31731656e0ebf04f84b92e5ae3d98096214b7/test/travis-spellcheck.sh))
* RuboCop
    * [packsaddle/ruby-saddler/bin/run-rubocop.sh](./example/run-rubocop.sh) ([link](https://github.com/packsaddle/ruby-saddler/blob/f0abab9d0c43a0a062c1f062000680a49ddb27a2/bin/run-rubocop.sh))
* JSCS
    * [run-jscs.sh](./example/run-jscs.sh)
* Use multiple reporters simultaneously
    * [Saddler::Reporter::Text and Saddler::Reporter::Github::PullRequestReviewComment](./example/run-simultaneously.sh)
* Gradle android - Checkstyle, FindBugs, PMD, CPD, Android Lint
    * [noboru-i/android-saddler-sample/scripts/saddler.sh](./example/run-gradle-android.sh) ([link](https://github.com/noboru-i/android-saddler-sample/blob/626fc93c6693144bd069db563836a856f401864a/scripts/saddler.sh))


## Articles

### ja

* [jser/jser.github.ioの記事をpull request時にLintする仕組み | Web Scratch](http://efcl.info/2015/03/04/linting-article/)
* [変更したファイルにrubocopやjscsを実行して pull requestに自動でコメントする – Saddler - checkstyle to anywhere](http://packsaddle.org/articles/saddler-overview/)
* [CircleCI - Androidのコードを自動で解析し、GitHubのpull requestにコメントする - Qiita](http://qiita.com/noboru_i/items/2f30296db1c8a6dfbd9b)
* [pull requestした差分にrubocopの結果を自動でコメントしてCircleCIをfailedにするよ - Qiita](http://qiita.com/nifuramu/items/e7490e86b7b67d99ac87)

### vi
* [Saddler – công cụ giúp CI chạy rubocop và comment lỗi trực tiếp vào pull request. – Appconus Blog](http://blog.appconus.com/2015/11/19/saddler-cong-cu-giup-ci-chay-rubocop-va-comment-loi-truc-tiep-vao-pull-request/)

## VS.

### [Hound (web service)](https://houndci.com/)

Easy to configure, only allow GitHub oAuth.
Very quick response,
because Hound uses not entire code base but pull request hook's payload.
But Hound focuses on RuboCop and JavaScript linters wrapped by Rubygems.
JavaScript libraries wrapped by Rubygems have code smells.


### [Hound (oss)](https://github.com/thoughtbot/hound)

You can host *own* Hound.
If you like caring hosted rails application.


### [Pronto](https://github.com/mmozuras/pronto)

Pronto is good application, and pronto influences saddler.
Pronto's command seems simple, but this is "tightly-coupled" command.
Pronto requires pronto-SOME-WRAPPER, and you should maintain wrapper scripts.
Almost all of linters have their own command line interface.
Why don't you use that direct?


## FAQ

Q: Is there the way to share in the command line?

A: I think that sharing the command line is not a simple solution.

We can call `saddler report` multiple times.
If we want to run Saddler only once, we can create "merged checkstyle file" before calling `saddler report`.

```
merge-checkstyle (command-a ...) (command-b ...) \
| saddler report ...
```

This requires `merge-checkstyle` command, I'm not sure that this command exists. I search "checkstyle" in rubygems, but I don't find such gem.


Q: Does Saddler support using both the text and Github reporters simultaneously?

A: Use `tee`. See [Saddler::Reporter::Text and Saddler::Reporter::Github::PullRequestReviewComment](./example/run-simultaneously.sh).

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
