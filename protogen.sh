#!/usr/bin/env bash
set -e

flutter pub global activate protoc_plugin

PATH=$PATH:"$HOME/.pub-cache/bin":"$(pwd)/tools"

rm -rf lib/protogen
mkdir -p lib/protogen

find proto -type f -exec echo Processing {} \; -exec protoc -Iproto --dart_out lib/protogen {} \;

