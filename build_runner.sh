#!/bin/bash

flutter clean
dart run build_runner build --delete-conflicting-outputs --build-filter 'lib/src/**.dart'
