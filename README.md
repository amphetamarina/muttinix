<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/9e4f99ca-b559-4343-91ee-a142d4b25472" />

# muttinix
**reproducible · portable · template-driven**

a self-contained cli mail environment using **neomutt**, **notmuch**, and **isync (mbsync)**. built on `nix-portable` to run anywhere without root access or global configuration pollution.
<img width="1408" height="768" alt="image" src="https://github.com/user-attachments/assets/f6d434c7-6f81-4417-a2c5-df0e270284c6" />

configured by default for **fastmail**, but adaptable to any standard imap provider.

## features
* **zero install:** runs entirely inside a nix shell; no system dependencies required.
* **templated config:** configuration files are auto-generated from `.env` vars at runtime.
* **secure:** secrets are kept in local files, never committed to git.
* **search-driven:** full-text indexing via notmuch.

## setup

### 1. bootstrap
clone the repo and download the static nix binary.

```bash
git clone [https://github.com/yourusername/muttinix.git](https://github.com/yourusername/muttinix.git)
cd muttinix

# download nix-portable
curl -L [https://github.com/DavHau/nix-portable/releases/download/v009/nix-portable](https://github.com/DavHau/nix-portable/releases/download/v009/nix-portable) -o nix-portable
chmod +x nix-portable
```

### 2. secrets
```bash
mkdir secrets
# paste your fastmail (or other provider) app password here
echo "your-app-password" > secrets/fastmail_pass
chmod 600 secrets/fastmail_pass
```

### 3. configuration
```bash
cp .env.example .env
``` 
edit .env with your details

## usage
initialize the environment. the first run will download dependencies (neomutt, isync, etc).
```bash
./scripts/run.sh
``` 

once inside the shell, use the helper scripts:
- `./scripts/sync.sh` → pulls mail via mbsync and indexes via notmuch.
- `./scripts/mutt.sh` → launches neomutt with the local configuration.

## structure
```
.
├── config/             # configuration templates (*.template)
├── mail/               # local mail storage (ignored)
├── secrets/            # credentials (ignored)
├── .env                # local environment variables (ignored)
├── flake.nix           # nix environment definition
├── scripts/run.sh      # entry point script
├── scripts/sync.sh     # mail fetch & index wrapper
└── scripts/mutt.sh     # ui launcher wrapper
``` 
## notes
- this setup defaults to fastmail because it adheres strictly to imap standards and offers granular app passwords. if using gmail, you must enable 2fa and generate an app password, but be aware of gmail's non-standard label mapping.
- this setup uses `nix-portable` by default, edit run.sh script to fit your needs




