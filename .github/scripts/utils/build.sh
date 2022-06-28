#!/bin/bash

build () {
  type=$1
  name=$2

  case $type in
    war)
      __build_war $name
      ;;
    zip)
      __build_zip $name
      ;;
  esac
}

local_check_build () {
  [ -f $BUILD_DIRECTORY/$TARGET_BUILD ] && exists=true || exists=false

  echo $exists
}

__build_war () {
  name=$1

  mvn package -q -f pom.xml
  mv $(ls ./target/*.war | head -1) $BUILD_DIRECTORY/$name
}

__build_zip () {
  name=$1

  zip $BUILD_DIRECTORY/$name -qr * .[^.]*
}
