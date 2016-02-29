#!/bin/bash
HOOKS_PATH=src/main/resources/hooks
GENES_DEX=genes/genes/build/outputs/apk/genes-debug.apk

rm -r $HOOKS_PATH/*

baksmali --use-locals --sequential-labels $GENES_DEX --output $HOOKS_PATH/tmp

mv $HOOKS_PATH/tmp/hooks/* $HOOKS_PATH

rm -r $HOOKS_PATH/tmp
