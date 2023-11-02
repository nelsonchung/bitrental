#!/bin/bash

# 定義一個函數來執行 ffmpeg 指令
process_image() {
    local INPUT="$1"
    local SCREEN_RESOLUTION="$2"
    local SCREEN_SIZE="$3"

    OUTPUT="${INPUT%.png}_${SCREEN_SIZE}.png"

    ffmpeg -i "$INPUT" -vf "scale=$SCREEN_RESOLUTION" "$OUTPUT"
}

# 針對 6.7 吋螢幕的設定
IPHONE_SCREEN_RESOLUTION1="1290*2796"
IPHONE_SCREEN_SIZE1=67

# 針對 5.5 吋螢幕的設定
IPHONE_SCREEN_RESOLUTION2="1242*2208"
IPHONE_SCREEN_SIZE2=55

# 針對 iPad 螢幕的設定
IPAD_SCREEN_RESOLUTION="2732*2048"
IPAD_SCREEN_SIZE=ipad

# 進入 iphone 資料夾並處理圖片
cd iphone
for INPUT in *.png; do
    process_image "$INPUT" "$IPHONE_SCREEN_RESOLUTION1" "$IPHONE_SCREEN_SIZE1"
    process_image "$INPUT" "$IPHONE_SCREEN_RESOLUTION2" "$IPHONE_SCREEN_SIZE2"
done
for INPUT in *.jpeg; do
    process_image "$INPUT" "$IPHONE_SCREEN_RESOLUTION1" "$IPHONE_SCREEN_SIZE1"
    process_image "$INPUT" "$IPHONE_SCREEN_RESOLUTION2" "$IPHONE_SCREEN_SIZE2"
done

# 進入 ipad 資料夾並處理圖片
cd ../ipad
for INPUT in *.png; do
    process_image "$INPUT" "$IPAD_SCREEN_RESOLUTION" "$IPAD_SCREEN_SIZE"
done
for INPUT in *.jpeg; do
    process_image "$INPUT" "$IPAD_SCREEN_RESOLUTION" "$IPAD_SCREEN_SIZE"
done

