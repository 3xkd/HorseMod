# store current folder
WORKSHOP_DIR=$(pwd)

# need to be in the steam uploader folder
cd "$STEAMUPLOADER"
./SteamUploader -a 108600 -w 3525515977 -d "$WORKSHOP_DIR/description.bbcode" -P "$WORKSHOP_DIR/patch_note.bbcode" -c "$WORKSHOP_DIR/Contents" -p "$WORKSHOP_DIR/Mod preview/preview.gif"

# return to original folder
cd $WORKSHOP_DIR