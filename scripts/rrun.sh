CYAN='\033[36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

set -e

pr() {
  echo -e "\n$CYAN$BOLD$1$NC" >&2
}

if [[ $# -lt 2 ]]; then
  echo "wrong number of arguments, got $# expected n >= 2" >&2
  exit 1
fi

host=$1
shift

relpath=${PWD#"$HOME"/}
cmd="mkdir -p '$relpath'"
pr "Creating '$host:$relpath' if it does not already exist..."
ssh "$host" "$cmd"

pr "Syncing contents of current directory to $host:$relpath..."
excludecmd() {
  git ls-files -oi --exclude-standard --directory 2>/dev/null || echo ""
}

rsync -aiv --progress --exclude-from=<(excludecmd) . "$host:$relpath"

pr "Running \"$*\" on $host..."
ssh "$host" "cd '$relpath' && $*"
