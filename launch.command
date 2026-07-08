#!/bin/zsh
SCRIPT_DIR="${0:A:h}"
APP_BUNDLE="$SCRIPT_DIR/dist/TPSL.app"

case "${1:-}" in
  --rebuild)
    shift
    exec /bin/zsh -lc 'cd "$1" || exit 1; shift; if [[ $# -eq 0 ]]; then exec ./script/build_and_run.sh run; else exec ./script/build_and_run.sh "$@"; fi' tpsl-launch "$SCRIPT_DIR" "$@"
    ;;
  --install)
    shift
    exec /bin/zsh -lc 'cd "$1" || exit 1; shift; exec ./script/build_and_run.sh --install "$@"' tpsl-launch "$SCRIPT_DIR" "$@"
    ;;
esac

if [[ ! -x "$APP_BUNDLE/Contents/MacOS/TPSL" ]]; then
  echo "TPSL.app is missing or incomplete. Rebuilding before launch..."
  exec /bin/zsh -lc 'cd "$1" || exit 1; shift; exec ./script/build_and_run.sh "$@"' tpsl-launch "$SCRIPT_DIR" "$@"
fi

exec /usr/bin/open -n "$APP_BUNDLE"
