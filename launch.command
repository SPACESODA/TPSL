#!/bin/zsh
SCRIPT_DIR="${0:A:h}"
APP_BUNDLE="$SCRIPT_DIR/dist/TPSL.app"

if [[ "${1:-}" == "--rebuild" ]]; then
  shift
  exec /bin/zsh -lc 'cd "$1" || exit 1; shift; exec ./script/build_and_run.sh "$@"' tpsl-launch "$SCRIPT_DIR" "$@"
fi

if [[ ! -x "$APP_BUNDLE/Contents/MacOS/TPSL" ]]; then
  echo "TPSL.app is missing or incomplete. Rebuilding before launch..."
  exec /bin/zsh -lc 'cd "$1" || exit 1; shift; exec ./script/build_and_run.sh "$@"' tpsl-launch "$SCRIPT_DIR" "$@"
fi

exec /usr/bin/open -n "$APP_BUNDLE"
