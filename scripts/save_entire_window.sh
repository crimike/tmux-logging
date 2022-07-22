#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

main() {
        local original_pane=$(tmux list-panes | grep active | cut -d':' -f1)
	if supported_tmux_version_ok; then
            for pane_nr in $(tmux list-panes | cut -d':' -f1); do
                tmux select-pane -t $pane_nr
		local file=$(expand_tmux_format_path "${save_complete_history_full_filename}")
		local history_limit="$(tmux display-message -p -F "#{history_limit}")"
		tmux capture-pane -J -S "-${history_limit}" -p > "${file}"
		remove_empty_lines_from_end_of_file "${file}"
		display_message "History saved to ${file}"
            done
	fi
        tmux select-pane -t ${original_pane}
}
main
