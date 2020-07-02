#!/bin/bash

RELEASE_DATA=$(curl -F "version=${SIGN_VERSION}" -F "password=${SIGN_SERVICE_PASSWORD}" -X POST "${SIGN_SERIVCE_URL}" )
echo $RELEASE_DATA
RELEASE_ID=$(echo $RELEASE_DATA| jq ".id")

function uploadfile() {
  FILE=$1
  CTYPE=$(file -b --mime-type $FILE)

  sleep 1
  curl -H "Authorization: token ${GITHUB_TOKEN}" -H "Content-Type: ${CTYPE}" --data-binary @$FILE "https://uploads.github.com/repos/xiaokangwang/effective-engine/releases/${RELEASE_ID}/assets?name=$(basename $FILE)"
  sleep 1
}

function upload() {
  FILE=$1
  DGST=$1.dgst
  openssl dgst -md5 $FILE | sed 's/([^)]*)//g' >> $DGST
  openssl dgst -sha1 $FILE | sed 's/([^)]*)//g' >> $DGST
  openssl dgst -sha256 $FILE | sed 's/([^)]*)//g' >> $DGST
  openssl dgst -sha512 $FILE | sed 's/([^)]*)//g' >> $DGST
  uploadfile $FILE
  uploadfile $DGST
}

curl "https://raw.githubusercontent.com/xiaokangwang/effective-engine/master/v2fly/${SIGN_VERSION}.Release" > Release
upload Release
