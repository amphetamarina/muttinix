#!/bin/sh
if [ -z "$MAIL_ROOT" ]; then
    echo "error: environment not loaded. run ./run or nix develop first."
    exit 1
fi

neomutt -F "$MAIL_ROOT/config/neomuttrc"
