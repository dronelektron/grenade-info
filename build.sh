#!/bin/bash

PLUGIN_NAME="grenade-info"

cd scripting
spcomp $PLUGIN_NAME.sp -o ../plugins/$PLUGIN_NAME.smx
