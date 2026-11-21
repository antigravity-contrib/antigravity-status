#!/usr/bin/env bats

SCRIPT="${BATS_TEST_DIRNAME}/../agy-status"

strip_ansi() {
  sed 's/\x1b\[[0-9;]*m//g'
}

@test "agy-status plugin file exists" {
  [ -f "${BATS_TEST_DIRNAME}/../agy-status.plugin.zsh" ]
}

@test "agy-status script is executable" {
  [ -x "$SCRIPT" ]
}

@test "renders empty payload safely" {
  run bash -c "'$SCRIPT' <<< '{}'"
  [ "$status" -eq 0 ]
  plain=$(printf '%s' "$output" | strip_ansi)
  [[ "$plain" == *"0%"* ]]
  [[ "$plain" == *"?"* ]]
}

@test "renders full payload with optional segments" {
  payload='{
    "cwd": "/tmp",
    "model": {"display_name": "Gemini 4 Neon (High)"},
    "workspace": {"current_dir": "/tmp"},
    "context_window": {"used_percentage": 42.7},
    "agent": {"name": "reviewer"},
    "cycle_mode": "auto",
    "sandbox": {"enabled": true},
    "vim": {"mode": "NORMAL"},
    "cost": {"total_usd": 0.42},
    "subagents": [
      {"name": "a", "role": "r", "status": "running"},
      {"name": "b", "role": "r", "status": "completed"}
    ],
    "task_count": 2
  }'
  run bash -c "'$SCRIPT' <<< '$payload'"
  [ "$status" -eq 0 ]
  plain=$(printf '%s' "$output" | strip_ansi)
  [[ "$plain" == *"42%"* ]]
  [[ "$plain" == *'$0.42'* ]]
  [[ "$plain" == *"Gemini 4 Neon (High)"* ]]
  [[ "$plain" == *"⚡ reviewer"* ]]
  [[ "$plain" == *"auto"* ]]
  [[ "$plain" == *"NORMAL"* ]]
  [[ "$plain" == *"⚡1"* ]]
  [[ "$plain" == *"tmp"* ]]
}

@test "supports switching Catppuccin themes via AGY_STATUS_THEME" {
  run env AGY_STATUS_THEME=catppuccin-latte bash -c "'$SCRIPT' <<< '{\"model\":{\"display_name\":\"Gemini\"},\"workspace\":{\"current_dir\":\"/tmp\"}}'"
  [ "$status" -eq 0 ]
  # catppuccin-latte model_fg is 23;146;153
  [[ "$output" == *"38;2;23;146;153mGemini"* ]]
}

@test "switches context bar color at 70% and 90% thresholds" {
  run bash -c "'$SCRIPT' <<< '{\"context_window\":{\"used_percentage\":75},\"workspace\":{\"current_dir\":\"/tmp\"}}'"
  [ "$status" -eq 0 ]
  # catppuccin-mocha context_bar_fg (yellow) is 249;226;175
  [[ "$output" == *"38;2;249;226;175m"* ]]

  run bash -c "'$SCRIPT' <<< '{\"context_window\":{\"used_percentage\":92},\"workspace\":{\"current_dir\":\"/tmp\"}}'"
  [ "$status" -eq 0 ]
  # catppuccin-mocha diff_del_fg (red) is 243;139;168
  [[ "$output" == *"38;2;243;139;168m"* ]]
}
