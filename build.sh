#!/bin/bash

PLUGIN_NAME="grenade-info"

cd scripting
spcomp $PLUGIN_NAME.sp -i include -o ../plugins/$PLUGIN_NAME.smx
