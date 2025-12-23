# Mysql Export Wizard (CLI Wizard for Linux)

Author: Kheireddine BELAID  
GitHub: https://github.com/sysco999  

This project wraps your existing **generate.sh / queries.sh / domains.sh / consolidate.sh** workflow into a *wizard-style* Linux CLI (whiptail/dialog), to guide users through:

- MySQL connection setup and mandatory connection test
- Output destination (local folder or remote SFTP/SSH key)
- Table list + interval-based query generation (queries.sh)
- Optional domain mapping generation (domains.sh)
- CSV generation + optional consolidation
- Optional SFTP upload to remote destination

## Quick start

```bash
cd mysql_exporter
chmod +x bin/dwh-wizard
./bin/dwh-wizard
```

## Requirements

- `bash`, `coreutils`, `awk`, `sed`
- `whiptail` (or `dialog`) for the wizard UI
- MySQL client binary (path asked in wizard)
- For **password SFTP**: `sshpass` (wizard will warn if missing)
- For **key SFTP**: `sftp` + `ssh`

## Files

- `bin/dwh-wizard` : the wizard (first configuration window + run)
- `bin/dwh-run` : runs export using saved configuration
- `lib/ui.sh` : small helper functions for whiptail/dialog
- `templates/generate.sh.tpl` : generate logic (config-driven)
- `templates/consolidate.sh.tpl` : consolidation logic (optional prefix filter)
- `templates/uploader.sh.tpl` : SFTP upload (password or key)

The wizard generates/updates in the chosen workspace:
- `config.env` (chmod 600)
- `queries.sh`
- `domains.sh` (optional)
- `generate.sh`
- `consolidate.sh`
- `uploader.sh` (if remote enabled)
- `run_all.sh` (single entrypoint that calls the others)

## Notes

- Passwords are stored in `config.env` with permissions `600` inside the workspace you select.
- To store secrets more securely, you can later extend this to use `gpg` or OS keyring.
