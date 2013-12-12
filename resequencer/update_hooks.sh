#!/bin/bash
HOOKS_PATH=src/resequencer/hooks
GENES_DEX=../genes/bin/classes.dex

rm -r $HOOKS_PATH/*

java -jar lib/baksmali.jar --use-locals --sequential-labels $GENES_DEX --output $HOOKS_PATH/tmp

mv $HOOKS_PATH/tmp/hooks/* $HOOKS_PATH

rm -r $HOOKS_PATH/tmp