# Path
dev=~/GitHub
for p in $dev/scripts $dev/go/bin ~/.cargo/bin; do
	  [ -d $p ] && PATH=$PATH:$p
done

# Editor
export EDITOR=vim
export VISUAL=vim
export PAGER=less

# Other env vars
export CLICOLOR=true
export GREP_OPTIONS='--color=auto'
export LEDGER_FILE=$dev/finance/journal.ledger
export LESS='-MerX'
export LESSHISTFILE='-'
