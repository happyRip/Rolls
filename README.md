# Rolls

Systemy Wbudowane (trans. Embedded Systems) project.

## Instructions:

- setup system
    - install `Raspberry PI OS Lite` on **both machines**
    - change passwords for default `pi` user on **both machines**
    - change `/etc/hostname` file content to `Alpha` and `Beta` according to machine purpose

- clone this repository
```bash
git clone "https://github.com/happyRip/Rolls.git" "$HOME/Hazard" 
```

- move `rolls.sh` and `tote.sh` to `/bin` or `$HOME/.local/bin` and remove extention from the scripts on **both machines**
    - add `$HOME/.local/bin` to `PATH` if needed
    - remember to be logged in as `pi` user
    - `tote.sh` is only needed on `Alpha`

- setup `cron` job on **Alpha** to create `magic_numbers` file in `/tmp` folder periodically

- setup `ssh`
    - create `ssh` keys using
    ```bash
    ssh-keygen -t rsa -b 4096 -C "machine_name"
    ```
    on **both machines**
    - add keys to `authorized_keys` using
    ```bash
    ssh-copy-id user@host.com
    ```
    on **both machines**
