#!/bin/bash
set -ev
if [ -n "${TRAVIS_PULL_REQUEST}" ] && [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  # Travis-CI
  #
  # git clone --depth=50 \
  # git://github.com/packsaddle/example-ruby-travis-ci.git \
  # packsaddle/example-ruby-travis-ci
  # cd packsaddle/example-ruby-travis-ci
  # git fetch origin +refs/pull/1/merge:
  # git checkout -qf FETCH_HEAD

  echo gem install
  gem install --no-document rubocop-select rubocop rubocop-checkstyle_formatter \
              checkstyle_filter-git saddler saddler-reporter-github \
              github_status_notifier

  github-status-notifier notify --state pending --context saddler/rubocop

  echo git diff
  git diff -z --name-only origin/master

  echo rubocop-select
  git diff -z --name-only origin/master \
   | xargs -0 rubocop-select

  TARGET_FILES=$(git diff -z --name-only origin/master \
                 | xargs -0 rubocop-select)

  if [ "${TARGET_FILES}" == "" ]; then
    echo "no rubocop target found"
    github-status-notifier notify --state success --context saddler/rubocop
    exit 0
  fi

  echo rubocop
  # rubocop return 1 both detecting error and raise error
  RUBOCOP_RESULT=$(git diff -z --name-only origin/master \
   | xargs -0 rubocop-select \
   | xargs rubocop \
       --require rubocop/formatter/checkstyle_formatter \
       --format RuboCop::Formatter::CheckstyleFormatter)
  echo $RUBOCOP_RESULT

  echo checkstyle_filter-git
  git diff -z --name-only origin/master \
   | xargs -0 rubocop-select \
   | xargs rubocop \
       --require rubocop/formatter/checkstyle_formatter \
       --format RuboCop::Formatter::CheckstyleFormatter \
   | checkstyle_filter-git diff origin/master

  echo saddler
  git diff -z --name-only origin/master \
   | xargs -0 rubocop-select \
   | xargs rubocop \
       --require rubocop/formatter/checkstyle_formatter \
       --format RuboCop::Formatter::CheckstyleFormatter \
   | checkstyle_filter-git diff origin/master \
   | saddler report \
      --require saddler/reporter/github \
      --reporter Saddler::Reporter::Github::PullRequestReviewComment

  github-status-notifier notify --exit-status $? --context saddler/rubocop
fi

exit 0
