# SOPS Secrets Cheatsheet

## How It Works

- `secrets/secrets.yaml` is AES256-GCM encrypted and safe to commit to GitHub
- `.sops.yaml` defines which age keys can encrypt/decrypt secrets
- Two keys are registered: your **user SSH key** and the machine's **host SSH key**
- At `nixos-rebuild` time, sops-nix decrypts secrets using `/etc/ssh/ssh_host_ed25519_key` and places them under `/run/secrets/`
- NixOS modules reference secrets via `config.sops.secrets.<name>.path`

---

## Prerequisites

Enter a shell with the required tools:

```bash
nix-shell -p sops age ssh-to-age
```

Export your age private key (derived from your SSH key):

```bash
export SOPS_AGE_KEY=$(ssh-to-age -private-key -i ~/.ssh/id_ed25519)
```

---

## Editing Secrets

SOPS transparently decrypts on open and re-encrypts on save:

```bash
sops secrets/secrets.yaml
```

---

## Adding a New Secret

1. Open the secrets file:
   ```bash
   sops secrets/secrets.yaml
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

   Or read the value inline (e.g. for a file that needs the raw string):
   ```nix
   someOption = builtins.readFile config.sops.secrets.myPassword.path;
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
  restartUnits = [ "myservice.service" ]; # restart units when secret changes
};
```

---

## Adding a New Machine (Host Key)

When deploying to a new machine, add its host age key to `.sops.yaml` and re-encrypt:

1. Get the new machine's age key:
   ```bash
   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   ```

2. Add it to `.sops.yaml` under `keys` and reference it in `creation_rules`:
   ```yaml
   keys:
     - &user age14jjd...
     - &host_desktop age12e4...
     - &host_laptop ageXXX...   # new machine

   creation_rules:
     - path_regex: secrets/.*\.yaml$
       key_groups:
         - age:
             - *user
             - *host_desktop
             - *host_laptop
   ```

3. Re-encrypt all secrets with the updated key set:
   ```bash
   export SOPS_AGE_KEY=$(ssh-to-age -private-key -i ~/.ssh/id_ed25519)
   sops updatekeys secrets/secrets.yaml
   ```

---

## Rotating / Rekeying

To rotate the encryption (e.g. after removing a key):

```bash
export SOPS_AGE_KEY=$(ssh-to-age -private-key -i ~/.ssh/id_ed25519)
sops updatekeys secrets/secrets.yaml
```

---

## Decrypting Manually (Inspect Values)

```bash
export SOPS_AGE_KEY=$(ssh-to-age -private-key -i ~/.ssh/id_ed25519)
sops --decrypt secrets/secrets.yaml
```

---

## Key Reference

| Key | Age Public Key |
|-----|---------------|
| User (`~/.ssh/id_ed25519`) | `age14jjd8nqghha4awty8ggxqh40rthttewcjs63hfjvpu423k6xx42qu0ykk3` |
| Host (`/etc/ssh/ssh_host_ed25519_key`) | `age12e4u495v4y0yeygqfmvqqd2r5073d9qu9w828jv0987ha2c9lyqsjqx5q6` |

---

## File Locations

| File | Purpose |
|------|---------|
| `.sops.yaml` | Key and creation rule config |
| `secrets/secrets.yaml` | Encrypted secrets store |
| `modules/core/sops.nix` | NixOS secret declarations |
