#!/bin/bash

PLAYLIST_URL="PLAYLIST_URL"
SAVE_DIR="./downloads"
URLS_FILE="urls.txt"
TMP_CURRENT="current_urls.tmp"

mkdir -p "$SAVE_DIR"

echo "Fetching Playlist URLs..."
yt-dlp --flat-playlist -i --print url "$PLAYLIST_URL" > "$TMP_CURRENT"

if [ ! -f "$URLS_FILE" ]; then
    mv "$TMP_CURRENT" "$URLS_FILE"
    echo "Initialized: Created '$URLS_FILE'."
    echo "Exiting..."
    exit 0
fi

awk 'NR==FNR{seen[$0];next} !($0 in seen)' "$URLS_FILE" "$TMP_CURRENT" \
| while read -r url; do
    echo "Downloading: $url"
    yt-dlp -P "$SAVE_DIR" "$url"
done

mv "$TMP_CURRENT" "$URLS_FILE"
echo "Done!"