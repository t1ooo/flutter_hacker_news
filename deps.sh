#!/bin/bash

deps=(
    url_launcher
    http
    json_annotation
    equatable
    logging
    flutter_cache_manager
    provider
    retry
    clock
    shimmer
    quiver
    intl
    html
    path_provider
    # package_info_plus
    # flutter_widget_from_html
    # flutter_html
    # html_unescape
)

dev_deps=(
    build_runner
    json_serializable
    file
    mocktail
    test
)

for d in "${deps[@]}"; do
    # flutter pub remove "$d"
    flutter pub add "$d"
done

for d in "${dev_deps[@]}"; do
    # flutter pub remove "$d" --dev
    flutter pub add "$d" --dev
done

flutter pub get
