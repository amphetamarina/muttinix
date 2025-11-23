{ pkgs ? import (fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    neomutt
    isync
    notmuch
    cacert
    gettext
    w3m        # Renders HTML to text
    urlscan    # Modern replacement for urlview
    xdg-utils  # Provides xdg-open for the browser
  ];

  shellHook = ''
    # 1. Environment Setup
    export MAIL_ROOT=$PWD
    export XDG_CONFIG_HOME=$PWD/config
    export NOTMUCH_CONFIG=$PWD/config/notmuch-config
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    
    # Point neomutt to our local mailcap
    export MAILCAPS=$PWD/config/mailcap

    # 2. Generate Mailcap (HTML Rendering)
    # This tells neomutt to use w3m to dump HTML as plain text
    mkdir -p config
    cat > config/mailcap <<EOF
    text/html; w3m -I %{charset} -T text/html -dump %s; copiousoutput
    EOF

    # 3. Load Secrets
    if [ -f .env ]; then
      set -a
      source .env
      set +a
    else
      echo ">> Warning: .env file missing."
    fi

    # 4. Template Rendering
    VARS='$MY_NAME $MY_EMAIL $IMAP_HOST $SMTP_HOST $PASS_FILE $MAIL_ROOT'
    
    # Ensure config directory exists before writing
    mkdir -p config
    
    envsubst "$VARS" < config/mbsyncrc.template > config/mbsyncrc
    envsubst "$VARS" < config/notmuch-config.template > config/notmuch-config
    envsubst "$VARS" < config/neomuttrc.template > config/neomuttrc
    cat config/mailcap.template > config/mailcap

    # 5. Inject HTML & URL Config into Neomutt
    cat >> config/neomuttrc <<EOF
    
    # --- Injection: HTML & URL Handling ---
    set mailcap_path = "$PWD/config/mailcap"
    
    # Auto-convert HTML to text so you don't see raw code
    auto_view text/html
    alternative_order text/plain text/enriched text/html
    
    # MACRO: Ctrl-b to open URL selector
    # Pipes the email to urlscan, which shows a clickable list
    macro index,pager \cb "<pipe-message>urlscan<Enter>" "open urlscan"
    macro attach,compose \cb "<pipe-entry>urlscan<Enter>" "open urlscan"
    EOF

    mkdir -p mail

    # 6. Aliases
    alias mutt="neomutt -F $PWD/config/neomuttrc"
    alias sync="mbsync -c $PWD/config/mbsyncrc -a"

    echo ":: Mail Environment ::"
    echo "   HTML:   Auto-rendered via w3m"
    echo "   URLs:   Press 'Ctrl-b' to select and open in browser"
  '';
}
