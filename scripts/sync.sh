#!/bin/sh
# safety check
if [ -z "$MAIL_ROOT" ]; then
    echo "error: environment not loaded. run ./run or nix develop first."
    exit 1
fi

echo ":: syncing ::"
mbsync -c "$MAIL_ROOT/config/mbsyncrc" -a

echo ":: indexing ::"
notmuch new 
