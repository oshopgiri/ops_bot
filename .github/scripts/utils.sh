#!/bin/bash

for util in $(find $REMOTE_SCRIPT_DIRECTORY/utils/ -name '*.sh');
do
  source $util
done
