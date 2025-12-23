\
#!/usr/bin/env bash
set -euo pipefail

# Prefer whiptail; fallback to dialog if present.
UI_BIN=""
if command -v whiptail >/dev/null 2>&1; then
  UI_BIN="whiptail"
elif command -v dialog >/dev/null 2>&1; then
  UI_BIN="dialog"
else
  echo "❌ Neither 'whiptail' nor 'dialog' is installed."
  echo "   Install one of them, e.g.: sudo apt-get install whiptail"
  exit 1
fi

ui_title() {
  local title="$1"
  echo "$title"
}

ui_msg() {
  local title="$1" msg="$2"
  if [[ "$UI_BIN" == "whiptail" ]]; then
    whiptail --title "$title" --msgbox "$msg" 14 80
  else
    dialog --title "$title" --msgbox "$msg" 14 80
  fi
}

ui_yesno() {
  local title="$1" msg="$2"
  if [[ "$UI_BIN" == "whiptail" ]]; then
    whiptail --title "$title" --yesno "$msg" 14 80
  else
    dialog --title "$title" --yesno "$msg" 14 80
  fi
}

ui_input() {
  local title="$1" msg="$2" default="${3:-}"
  local out
  if [[ "$UI_BIN" == "whiptail" ]]; then
    out=$(whiptail --title "$title" --inputbox "$msg" 14 80 "$default" 3>&1 1>&2 2>&3) || return 1
  else
    out=$(dialog --title "$title" --inputbox "$msg" 14 80 "$default" 3>&1 1>&2 2>&3) || return 1
  fi
  printf "%s" "$out"
}

ui_password() {
  local title="$1" msg="$2"
  local out
  if [[ "$UI_BIN" == "whiptail" ]]; then
    out=$(whiptail --title "$title" --passwordbox "$msg" 14 80 3>&1 1>&2 2>&3) || return 1
  else
    out=$(dialog --title "$title" --insecure --passwordbox "$msg" 14 80 3>&1 1>&2 2>&3) || return 1
  fi
  printf "%s" "$out"
}

ui_textarea() {
  local title="$1" msg="$2" default="${3:-}"
  local tmp
  tmp=$(mktemp)
  printf "%s" "$default" > "$tmp"
  if [[ "$UI_BIN" == "whiptail" ]]; then
    whiptail --title "$title" --textbox "$tmp" 20 90
  else
    dialog --title "$title" --textbox "$tmp" 20 90
  fi
  rm -f "$tmp"
  return 0
}

ui_editbox() {
  # Opens an edit box, returns edited text on stdout.
  local title="$1" msg="$2" default="${3:-}"
  local tmp
  tmp=$(mktemp)
  cat > "$tmp" <<EOF
$msg

$default
EOF

  local out
  if [[ "$UI_BIN" == "whiptail" ]]; then
    out=$(whiptail --title "$title" --editbox "$tmp" 24 100 3>&1 1>&2 2>&3) || { rm -f "$tmp"; return 1; }
  else
    out=$(dialog --title "$title" --editbox "$tmp" 24 100 3>&1 1>&2 2>&3) || { rm -f "$tmp"; return 1; }
  fi
  rm -f "$tmp"
  printf "%s" "$out"
}
