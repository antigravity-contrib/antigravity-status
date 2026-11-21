"agy_model=" + ((.model.display_name // .model.id // "?") | @sh),
"current_dir=" + ((.workspace.current_dir // .cwd // ".") | @sh),
"cost_usd=" + (
  if .cost.total_usd != null then (.cost.total_usd | tostring) else "" end | @sh
),
"context_used=" + ((.context_window.used_percentage // 0 | floor | tostring) | @sh),
"agy_agent=" + ((.agent.name // "") | @sh),
"cycle_mode=" + ((.cycle_mode // "") | @sh),
"sandbox_enabled=" + ((.sandbox.enabled // false | tostring) | @sh),
"vim_mode=" + ((.vim.mode // "") | @sh),
"running_subagents=" + (
  ([(.subagents // [])[] | select(.status == "running")] | length | tostring) | @sh
),
"task_count=" + ((.task_count // 0 | tostring) | @sh)
