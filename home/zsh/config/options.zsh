setopt extendedglob nomatch
setopt auto_pushd pushd_minus
setopt auto_continue prompt_sp

setopt extended_history hist_expire_dups_first hist_fcntl_lock hist_ignore_dups
setopt hist_ignore_space hist_reduce_blanks hist_verify share_history
# TODO: hist_lex_words?
SAVEHIST=99999
HISTSIZE=$SAVEHIST

unsetopt beep notify flow_control
