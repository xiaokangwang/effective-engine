#!/bin/bash

export SIGN_VERSION=$(cat $GITHUB_EVENT_PATH| jq ".release.tag_name")

echo $SIGN_VERSION
