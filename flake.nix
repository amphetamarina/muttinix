{
  description = "portable, templated mail environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            neomutt
            isync
            notmuch
            cacert
            gettext # provides envsubst
          ];

          shellHook = ''
            export MAIL_ROOT=$PWD
            export XDG_CONFIG_HOME=$PWD/config
            export NOTMUCH_CONFIG=$PWD/config/notmuch-config
            export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt

            # 1. load .env variables
            if [ -f .env ]; then
              set -a
              source .env
              set +a
            else
              echo "warning: .env file missing. configs may be empty."
            fi

            # 2. generate configs from templates
            # we explicitly list vars to replace to avoid clobbering system vars
            VARS='$MY_NAME $MY_EMAIL $IMAP_HOST $SMTP_HOST $PASS_FILE $MAIL_ROOT'

            envsubst "$VARS" < config/mbsyncrc.template > config/mbsyncrc
            envsubst "$VARS" < config/notmuch-config.template > config/notmuch-config
            envsubst "$VARS" < config/neomuttrc.template > config/neomuttrc

            mkdir -p $PWD/mail

            echo ":: mail environment ::"
            echo "   user: $MY_NAME <$MY_EMAIL>"
            echo "   configs generated."
          '';
        };
      }
    );
}
