<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/9e4f99ca-b559-4343-91ee-a142d4b25472" />

# muttinix
**reproducible · portable · template-driven**

a self-contained cli mail environment using **neomutt**, **notmuch**, and **isync (mbsync)**.
configured by default for **fastmail**, but adaptable to any standard imap provider.

## features
* **zero install:** runs entirely inside a nix shell; no system dependencies required.
* **templated config:** configuration files are auto-generated from `.env` vars at runtime.
* **secure:** secrets are kept in local files, never committed to git.
* **search-driven:** full-text indexing via notmuch.

## setup

### 1. bootstrap
```bash
git clone [https://github.com/yourusername/muttinix.git](https://github.com/yourusername/muttinix.git)
cd muttinix
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
```bash
nix-shell
``` 

## notes
- this setup defaults to fastmail because it adheres strictly to imap standards and offers granular app passwords. if using gmail, you must enable 2fa and generate an app password, but be aware of gmail's non-standard label mapping.



