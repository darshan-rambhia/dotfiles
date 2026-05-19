#!/bin/zsh
# =============================================================================
# Simple Upgrade Reminder
# =============================================================================
# Prompts to run `upgrade` (topgrade) if it hasn't been run recently.
#
# Location: ~/.local/shell/.maintenance
# State: ~/.local/state/maintenance/upgrade.lastrun
# Lock:  ~/.local/state/maintenance/upgrade.running  (contains PID while running)

UPGRADE_THRESHOLD_DAYS=${UPGRADE_THRESHOLD_DAYS:-3}
_UPGRADE_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/maintenance"
UPGRADE_STATE_FILE="$_UPGRADE_STATE_DIR/upgrade.lastrun"
UPGRADE_LOCK_FILE="$_UPGRADE_STATE_DIR/upgrade.running"

[[ -d "$_UPGRADE_STATE_DIR" ]] || mkdir -p "$_UPGRADE_STATE_DIR"

_upgrade_days_since() {
  if [[ -f "$UPGRADE_STATE_FILE" ]]; then
    local lastrun=$(cat "$UPGRADE_STATE_FILE")
    local now=$(date +%s)
    echo $(( (now - lastrun) / 86400 ))
  else
    echo "never"
  fi
}

_upgrade_mark_done() {
  date +%s > "$UPGRADE_STATE_FILE"
}

# Returns 0 if topgrade is currently running in another shell
_upgrade_is_running() {
  if [[ -f "$UPGRADE_LOCK_FILE" ]]; then
    local lock_val=$(cat "$UPGRADE_LOCK_FILE" 2>/dev/null)
    # "cmux" sentinel means it was launched in a cmux workspace
    if [[ "$lock_val" == "cmux" ]]; then
      return 0
    elif [[ -n "$lock_val" ]] && kill -0 "$lock_val" 2>/dev/null; then
      return 0
    else
      rm -f "$UPGRADE_LOCK_FILE"
    fi
  fi
  return 1
}

# Wrapper to run upgrade and mark complete
upgrade() {
  if _upgrade_is_running; then
    echo -e "\033[1;33mUpgrade already running (PID $(cat "$UPGRADE_LOCK_FILE")).\033[0m"
    return 1
  fi

  if command -v cmux &>/dev/null && cmux ping &>/dev/null 2>&1; then
    # cmux is running — open a dedicated workspace so no existing shell is blocked
    local state_file="$UPGRADE_STATE_FILE"
    local lock_file="$UPGRADE_LOCK_FILE"
    local args="$*"
    echo "cmux" > "$UPGRADE_LOCK_FILE"
    cmux new-workspace --name "topgrade" \
      --command "topgrade $args; date +%s > \"$state_file\"; rm -f \"$lock_file\"; echo; echo -e '\033[1;32mUpgrade complete.\033[0m'"
    echo -e "\033[1;32mUpgrade running in new cmux workspace 'topgrade'.\033[0m"
  else
    echo $$ > "$UPGRADE_LOCK_FILE"
    topgrade "$@"
    local exit_code=$?
    # Always mark as done even with partial failures (topgrade exits non-zero if any step fails)
    _upgrade_mark_done
    rm -f "$UPGRADE_LOCK_FILE"
    return $exit_code
  fi
}

_upgrade_check() {
  local days="$(_upgrade_days_since)"

  if [[ "$days" == "never" ]] || [[ "$days" -ge "$UPGRADE_THRESHOLD_DAYS" ]]; then
    echo ""
    if _upgrade_is_running; then
      echo -e "\033[1;33mSystem upgrade already running in another shell.\033[0m"
      echo ""
      return
    fi

    if [[ "$days" == "never" ]]; then
      echo -e "\033[1;33mSystem upgrade has never been run.\033[0m"
    else
      echo -e "\033[1;33mSystem upgrade last run $days days ago.\033[0m"
    fi
    echo -n "Run upgrade now? [Y/n]: "
    read -r response
    response="${response:-y}"

    if [[ "${response:l}" == "y" || "${response:l}" == "yes" ]]; then
      upgrade
    fi
    echo ""
  fi
}

# Only check in interactive shells, once per session
if [[ -o interactive ]] && [[ -z "$_UPGRADE_CHECKED" ]]; then
  export _UPGRADE_CHECKED=1
  _upgrade_check
fi
