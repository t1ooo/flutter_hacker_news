#!/bin/bash

declare -A urls

urls=(
    ["item_story"]="https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty"
    ["item_comment"]="https://hacker-news.firebaseio.com/v0/item/2921983.json?print=pretty"
    ["item_ask"]="https://hacker-news.firebaseio.com/v0/item/121003.json?print=pretty"
    ["item_job"]="https://hacker-news.firebaseio.com/v0/item/192327.json?print=pretty"
    ["item_poll"]="https://hacker-news.firebaseio.com/v0/item/126809.json?print=pretty"
    ["item_pollopt"]="https://hacker-news.firebaseio.com/v0/item/160705.json?print=pretty"
    ["user"]="https://hacker-news.firebaseio.com/v0/user/jl.json?print=pretty"
    ["maxitem"]="https://hacker-news.firebaseio.com/v0/maxitem.json?print=pretty"
    ["topstories"]="https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
    ["newstories"]="https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty"
    ["beststories"]="https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty"
    ["askstories"]="https://hacker-news.firebaseio.com/v0/askstories.json?print=pretty"
    ["showstories"]="https://hacker-news.firebaseio.com/v0/showstories.json?print=pretty"
    ["jobstories"]="https://hacker-news.firebaseio.com/v0/jobstories.json?print=pretty"
    ["updates"]="https://hacker-news.firebaseio.com/v0/updates.json?print=pretty"
)

for name in "${!urls[@]}"; do
    fname="../data/$name.json"
    echo "save $fname <- ${urls[$name]}"
    wget "${urls[$name]}" -O "$fname"
    sleep 1
done
