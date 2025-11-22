{ pkgs ? import (fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz") {} }:

pkgs.mkShell {
  # Essential tools
  buildInputs = with pkgs; [
    neomutt
    isync
    notmuch
    cacert
    gettext # envsubst
  ];

  shellHook = ''
    # 1. Environment Setup
    export MAIL_ROOT=$PWD
    export XDG_CONFIG_HOME=$PWD/config
    export NOTMUCH_CONFIG=$PWD/config/notmuch-config
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt

    # 2. Load Secrets
    if [ -f .env ]; then
      set -a
      source .env
      set +a
    else
      echo ">> Warning: .env file missing. Templates may result in empty configs."
    fi

    # 3. Template Rendering
    # Restricting substitution to these variables prevents shell pollution
    VARS='$MY_NAME $MY_EMAIL $IMAP_HOST $SMTP_HOST $PASS_FILE $MAIL_ROOT'

    # Ensure config directory exists before writing
    mkdir -p config
    
    envsubst "$VARS" < config/mbsyncrc.template > config/mbsyncrc
    envsubst "$VARS" < config/notmuch-config.template > config/notmuch-config
    envsubst "$VARS" < config/neomuttrc.template > config/neomuttrc

    mkdir -p mail

    # 4. The Alias mechanism
    # Forces neomutt to use the generated config explicitly
    alias mutt="neomutt -F $PWD/config/neomuttrc"
    alias sync="mbsync -c $PWD/config/mbsyncrc -a"

    echo ":: Mail Environment Active ::"
    echo "   User: $MY_NAME <$MY_EMAIL>"
    echo "   Commands: 'mutt' (launch), 'sync' (fetch mail)"
  '';
}
