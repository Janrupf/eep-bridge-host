#!/usr/bin/env bash
PATH=$PATH:$HOME/.pub-cache/bin

rm -rf lib/protogen
mkdir -p lib/protogen

protoc -Iproto --dart_out lib/protogen proto/network/packets.proto
protoc -Iproto --dart_out lib/protogen proto/network/definitions.proto

protoc -Iproto --dart_out lib/protogen proto/project/project.proto
