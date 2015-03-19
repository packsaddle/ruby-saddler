#!/bin/bash
set -v
# Copyright (c) 2015 sanemat
# License MIT
# https://github.com/packsaddle/example-travis_ci-pull_request_review-jscs/blob/master/bin/run-jscs.sh
if [ -n "${TRAVIS_PULL_REQUEST}" ] && [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  # Travis-CI
  #
  # git clone --depth=50 \
  # git://github.com/packsaddle/example-ruby-travis-ci.git \
  # packsaddle/example-ruby-travis-ci
  # cd packsaddle/example-ruby-travis-ci
  # git fetch origin +refs/pull/1/merge:
  # git checkout -qf FETCH_HEAD

  NOTIFIER_CONTEXT="saddler/jscs"
  echo gem install
  gem install --no-document checkstyle_filter-git saddler saddler-reporter-github \
              github_status_notifier

  github-status-notifier notify --state pending --context "${NOTIFIER_CONTEXT}"

  # Check diff
  echo "gif diff"
  git diff --name-only origin/master \
   | grep '.*\.js$' || RETURN_CODE=$?

  case "$RETURN_CODE" in
    "" ) echo "diff found" ;;
    "1" )
      echo "diff not found"
      github-status-notifier notify --state success --context "${NOTIFIER_CONTEXT}"
      exit 0 ;;
    * )
      echo "Error"
      github-status-notifier notify --state error --context "${NOTIFIER_CONTEXT}"
      exit $RETURN_CODE ;;
  esac

  git diff --name-only origin/master \
   | grep '.*\.js$' \
   | xargs $(npm bin)/jscs \
       --reporter checkstyle \
   | checkstyle_filter-git diff origin/master \
   | saddler report \
      --require saddler/reporter/github \
      --reporter Saddler::Reporter::Github::PullRequestReviewComment

  github-status-notifier notify --exit-status $? --context "${NOTIFIER_CONTEXT}"
fi

exit 0
