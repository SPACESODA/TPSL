#!/usr/bin/env bash
set -euo pipefail

APP_NAME="TPSL"
PRODUCT_NAME="TPSL"
BUNDLE_ID="com.realanthonyc.tpsl"
MODE="${1:-run}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
WEBAPP_DIR="$RESOURCES_DIR/WebApp"
BUILD_DIR="$ROOT_DIR/.build"
SWIFTPM_CACHE_DIR="$BUILD_DIR/swiftpm-cache"
CLANG_MODULE_CACHE_DIR="$BUILD_DIR/clang-module-cache"
PRESERVED_ICON="$DIST_DIR/AppIcon.icns"

mkdir -p "$SWIFTPM_CACHE_DIR" "$CLANG_MODULE_CACHE_DIR"
export SWIFTPM_CACHE_PATH="$SWIFTPM_CACHE_DIR"
export CLANG_MODULE_CACHE_PATH="$CLANG_MODULE_CACHE_DIR"

case "$MODE" in
  run|--debug|debug|--logs|logs|--telemetry|telemetry|--verify|verify) ;;
  *) echo "usage: $0 [run|--debug|--logs|--telemetry|--verify]" >&2; exit 2 ;;
esac

pkill -x "$APP_NAME" >/dev/null 2>&1 || true

if [[ -f "$RESOURCES_DIR/AppIcon.icns" ]]; then
  cp "$RESOURCES_DIR/AppIcon.icns" "$PRESERVED_ICON"
fi

swift build \
  -c release \
  --product "$PRODUCT_NAME" \
  --package-path "$ROOT_DIR" \
  --scratch-path "$BUILD_DIR" \
  --disable-sandbox

rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR" "$WEBAPP_DIR"

cp "$ROOT_DIR/.build/release/$PRODUCT_NAME" "$MACOS_DIR/$APP_NAME"
chmod +x "$MACOS_DIR/$APP_NAME"
cp "$ROOT_DIR/index.html" "$WEBAPP_DIR/"
cp "$ROOT_DIR/style.css" "$WEBAPP_DIR/"
cp "$ROOT_DIR/script.js" "$WEBAPP_DIR/"
cp "$ROOT_DIR/sw.js" "$WEBAPP_DIR/"
cp "$ROOT_DIR/manifest.webmanifest" "$WEBAPP_DIR/"
cp "$ROOT_DIR/icon.svg" "$WEBAPP_DIR/"
cp "$ROOT_DIR/icon-180.png" "$WEBAPP_DIR/"
cp "$ROOT_DIR/icon-192.png" "$WEBAPP_DIR/"
cp "$ROOT_DIR/icon-512.png" "$WEBAPP_DIR/"

if [[ -f "$PRESERVED_ICON" ]]; then
  cp "$PRESERVED_ICON" "$RESOURCES_DIR/AppIcon.icns"
  rm -f "$PRESERVED_ICON"
fi

APP_ICON_PLIST=""
if [[ -f "$RESOURCES_DIR/AppIcon.icns" ]]; then
  APP_ICON_PLIST="  <key>CFBundleIconFile</key>
  <string>AppIcon</string>"
fi

cat > "$CONTENTS_DIR/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
$APP_ICON_PLIST
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>13.0</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
</dict>
</plist>
PLIST

open_app() {
  /usr/bin/open -n "$APP_BUNDLE"
}

case "$MODE" in
  run)
    open_app
    echo "Built and launched $APP_BUNDLE"
    ;;
  --debug|debug)
    lldb -- "$MACOS_DIR/$APP_NAME"
    ;;
  --logs|logs)
    open_app
    /usr/bin/log stream --info --style compact --predicate "process == \"$APP_NAME\""
    ;;
  --telemetry|telemetry)
    open_app
    /usr/bin/log stream --info --style compact --predicate "subsystem == \"$BUNDLE_ID\""
    ;;
  --verify|verify)
    open_app
    sleep 1
    pgrep -x "$APP_NAME" >/dev/null
    echo "$APP_NAME launched from $APP_BUNDLE"
    ;;
esac
