# Custom functions
fpath=(~/.zsh/functions $fpath)

autoload -U compinit zrecompile

zsh_cache=~/.zsh/cache/$USER/
mkdir -p $zsh_cache

HISTFILE=$zsh_cache/.hist
compinit -d $zsh_cache/zcomp-$HOST

for f in ~/.zshrc $zsh_cache/zcomp-$HOST; do
    zrecompile -p $f && rm -f $f.zwc.old
done
setopt extended_glob
for zshrc_snipplet in ~/.zsh/zsh.d/S[0-9][0-9]*[^~]; do
    source $zshrc_snipplet
done
function history-all { history -E 1 }
