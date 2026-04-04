# SOPS Secrets Cheatsheet

## How It Works

- `secrets/secrets.yaml` is AES256-GCM encrypted and safe to commit to GitHub
- `.sops.yaml` defines which age keys can encrypt/decrypt secrets
- Two keys are registered: your **user age key** (`~/.config/sops/age/keys.txt`) and the machine's **host SSH key**
- At `nixos-rebuild` time, sops-nix decrypts secrets using `/etc/ssh/ssh_host_ed25519_key` and places them under `/run/secrets/`
- NixOS modules reference secrets via `config.sops.secrets.<name>.path`

---

## Prerequisites

`sops` is installed as a system package. To run it, use:

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/secrets.yaml
```

Or if sops is not yet installed (e.g. before first rebuild), use `nix run`:

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt nix run nixpkgs#sops -- secrets/secrets.yaml
```

---

## Editing Secrets

SOPS transparently decrypts on open and re-encrypts on save:

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/secrets.yaml
```

---

## Adding a New Secret

1. Open the secrets file:
   ```bash
   SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/secrets.yaml
   ```

2. Add your secret as a new key:
   ```yaml
   sshAuthorizedKey: ssh-ed25519 AAA...
   myPassword: supersecret
   apiToken: ghp_abc123
   ```

3. Save and close — SOPS re-encrypts automatically.

4. Declare the secret in `modules/core/sops.nix`:
   ```nix
   sops.secrets.myPassword = {};
   ```

5. Reference it in any NixOS module:
   ```nix
   { config, ... }:
   {
     someOption = config.sops.secrets.myPassword.path; # path to decrypted file
   }
   ```

---

## Secret Options

Each secret in `sops.nix` can be configured:

```nix
sops.secrets.mySecret = {
  owner = "username";      # file owner (default: root)
  group = "users";         # file group
  mode = "0400";           # file permissions (default: 0400)
  path = "/run/secrets/mySecret"; # override default path
  neededForUsers = true;   # decrypt before user activation (needed for SSH authorized keys etc.)
  restartUnits = [ "myservice.service" ]; # restart units when secret changes
};
```

---

## Installing on a New Machine

### 1. Install NixOS & apply the config
```bash
tr
```
Secrets won't decrypt yet — the new host key isn't registered.

### 2. Restore your user age key
Copy `~/.config/sops/age/keys.txt` from your backup to the new machine:
```bash
mkdir -p ~/.config/sops/age
# restore keys.txt here (from password manager or encrypted backup)
```

### 3. Get the new machine's host age key
```bash
nix run nixpkgs#ssh-to-age -- < /etc/ssh/ssh_host_ed25519_key.pub
```

### 4. Add it to `.sops.yaml`
```yaml
keys:
  - &user age19jq8zjfjtmu0zs63d5dzqzy7tkfrverdk22qjcpf5fvxjtxf9plswyhwa2
  - &host_desktop age12e4u495v4y0yeygqfmvqqd2r5073d9qu9w828jv0987ha2c9lyqsjqx5q6
  - &host_new age1<new-key-here>

creation_rules:
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
          - *user
          - *host_desktop
          - *host_new
```

### 5. Re-encrypt secrets with the new key
```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys secrets/secrets.yaml
```

### 6. Commit, push, rebuild
```bash
git add .sops.yaml secrets/secrets.yaml
git commit -m "add host age key for new machine"
git push
tr
```

Secrets will decrypt and `~/.ssh/id_ed25519` will be placed automatically.

---

## Rotating / Rekeying

To rotate encryption after adding or removing a key:

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys secrets/secrets.yaml
```

---

## Decrypting Manually (Inspect Values)

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --decrypt secrets/secrets.yaml
```

---

## Key Reference

| Key | Age Public Key |
|-----|---------------|
| User (`~/.config/sops/age/keys.txt`) | `age19jq8zjfjtmu0zs63d5dzqzy7tkfrverdk22qjcpf5fvxjtxf9plswyhwa2` |
| Host (`/etc/ssh/ssh_host_ed25519_key`) | `age12e4u495v4y0yeygqfmvqqd2r5073d9qu9w828jv0987ha2c9lyqsjqx5q6` |

---

## File Locations

| File | Purpose |
|------|---------|
| `~/.config/sops/age/keys.txt` | User age private key — back this up! |
| `.sops.yaml` | Key and creation rule config |
| `secrets/secrets.yaml` | Encrypted secrets store |
| `modules/core/sops.nix` | NixOS secret declarations |
