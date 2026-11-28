#!/bin/sh
# scripts/install.sh
# AS Auto Switcher - POSIX User-Space Installer for macOS and Linux
# Installs without sudo and strictly verifies SHA-256 checksums before extraction.
set -eu

REPO="${AS_INSTALL_REPO:-tamnguyendinh/CheapApp-Auto-switcher-releases}"
VERSION="${AS_INSTALL_VERSION:-}"
BASE_URL="${AS_INSTALL_BASE_URL:-}"
INSTALL_DIR="${AS_INSTALL_DIR:-}"
TMP_DIR=""

log() {
  printf '%s\n' "$*"
}

warn() {
  printf 'WARNING: %s\n' "$*" >&2
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

cleanup() {
  if [ -n "${TMP_DIR:-}" ] && [ "$TMP_DIR" != "/" ] && [ "$TMP_DIR" != "." ]; then
    rm -rf "$TMP_DIR"
  fi
}

trap cleanup EXIT HUP INT TERM

usage() {
  cat <<'EOF'
AS Auto Switcher Installer (macOS & Linux, no sudo required)

Usage:
  install.sh [--version X.Y.Z] [--base-url URL] [--repo OWNER/NAME] [--install-dir DIR]

Options:
  --version X.Y.Z     Install a specific 3-part SemVer release (default: latest release)
  --base-url URL      Override release download base URL (env: AS_INSTALL_BASE_URL)
  --repo OWNER/NAME   Override GitHub release repository (default: tamnguyendinh/CheapApp-Auto-switcher-releases)
  --install-dir DIR   Override installation directory (must be an absolute writable path)
  -h, --help          Show this help message
EOF
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    fail "Required command '$1' is not installed or not in PATH."
  fi
}

validate_semver() {
  case "$1" in
    *[!0-9.]*|""|.*|*.|*..*)
      fail "Invalid 3-part SemVer version: '$1' (expected X.Y.Z)"
      ;;
  esac
  if ! printf '%s\n' "$1" | grep -Eq '^(0|[1-9][0-9]?)\.(0|[1-9][0-9]?)\.(0|[1-9][0-9]?)$'; then
    fail "Invalid 3-part SemVer version: '$1' (expected X.Y.Z with 0 <= X,Y,Z <= 99, no leading zeros)"
  fi
}

validate_repo() {
  if ! printf '%s\n' "$1" | grep -Eq '^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$'; then
    fail "Invalid GitHub repository specifier: '$1' (expected OWNER/NAME)"
  fi
}

validate_base_url() {
  case "$1" in
    https://*|file://*|http://127.0.0.1:*|http://127.0.0.1/*|http://localhost:*|http://localhost/*)
      ;;
    *)
      fail "Unsupported or insecure base URL '$1'. Use https:// (or local file:// / http://127.0.0.1 for testing)."
      ;;
  esac
}

validate_safe_target() {
  _t="$1"
  _protected="${2:-}"
  case "$_t" in
    ""|"/"|"."|".."|*/..|*/../*|./*|*//*)
      fail "Refusing unsafe installation path: '$_t'"
      ;;
  esac
  case "$_t" in
    /*) ;;
    *) fail "Installation path must be absolute: '$_t'" ;;
  esac
  if [ "$_t" = "$HOME" ]; then
    fail "Refusing to install directly into HOME: '$_t'"
  fi
  if [ -n "$_protected" ] && [ "$_t" = "$_protected" ]; then
    fail "Refusing to install directly into protected root directory: '$_t'"
  fi
}

# Parse CLI flags (strictly no eval).
while [ $# -gt 0 ]; do
  case "$1" in
    --version)
      [ $# -ge 2 ] || fail "Missing value for --version"
      VERSION="$2"
      shift 2
      ;;
    --version=*)
      VERSION="${1#*=}"
      shift
      ;;
    --base-url)
      [ $# -ge 2 ] || fail "Missing value for --base-url"
      BASE_URL="$2"
      shift 2
      ;;
    --base-url=*)
      BASE_URL="${1#*=}"
      shift
      ;;
    --repo)
      [ $# -ge 2 ] || fail "Missing value for --repo"
      REPO="$2"
      shift 2
      ;;
    --repo=*)
      REPO="${1#*=}"
      shift
      ;;
    --install-dir)
      [ $# -ge 2 ] || fail "Missing value for --install-dir"
      INSTALL_DIR="$2"
      shift 2
      ;;
    --install-dir=*)
      INSTALL_DIR="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: '$1'. Run with --help for usage."
      ;;
  esac
done

validate_repo "$REPO"

if [ -z "${HOME:-}" ]; then
  fail "HOME environment variable is not set."
fi
case "$HOME" in
  "/"|""|"."|"..")
    fail "Refusing to run with unsafe HOME directory: '$HOME'"
    ;;
  /*) ;;
  *)
    fail "HOME must be an absolute path: '$HOME'"
    ;;
esac

# Fail fast on obviously unsafe --install-dir before any network/file download.
if [ -n "$INSTALL_DIR" ]; then
  validate_safe_target "$INSTALL_DIR"
fi

# Detect OS and CPU architecture.
RAW_OS="$(uname -s)"
case "$RAW_OS" in
  Darwin) OS="darwin" ;;
  Linux)  OS="linux" ;;
  *)      fail "Unsupported operating system: '$RAW_OS' (supported: Darwin, Linux)." ;;
esac

RAW_ARCH="$(uname -m)"
case "$RAW_ARCH" in
  arm64|aarch64) ARCH="arm64" ;;
  x86_64|amd64)  ARCH="amd64" ;;
  *)             fail "Unsupported CPU architecture: '$RAW_ARCH' (supported: arm64, x86_64/amd64)." ;;
esac

# Verify required host commands upfront.
require_cmd curl
require_cmd tar
require_cmd mktemp
require_cmd awk
require_cmd grep
if [ "$OS" = "darwin" ]; then
  require_cmd shasum
else
  require_cmd sha256sum
fi

# Create isolated temporary workspace cleaned automatically on EXIT.
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/as-auto-switcher-install.XXXXXX")"
if [ -z "$TMP_DIR" ] || [ ! -d "$TMP_DIR" ] || [ "$TMP_DIR" = "/" ] || [ "$TMP_DIR" = "." ]; then
  fail "Failed to create safe temporary directory."
fi

# Resolve release version.
if [ -n "$VERSION" ]; then
  VERSION="${VERSION#v}"
  VERSION="${VERSION#V}"
  validate_semver "$VERSION"
else
  if [ -n "$BASE_URL" ]; then
    fail "When --base-url / AS_INSTALL_BASE_URL is set, you must also specify --version X.Y.Z."
  fi
  LATEST_API_URL="https://api.github.com/repos/${REPO}/releases/latest"
  LATEST_JSON="$TMP_DIR/latest.json"
  log "Querying latest release from ${LATEST_API_URL}..."
  curl -fsSL \
    -H "Accept: application/vnd.github+json" \
    -H "User-Agent: as-auto-switcher-installer" \
    "$LATEST_API_URL" \
    -o "$LATEST_JSON" || fail "Failed to query latest release metadata from GitHub."

  RAW_TAG="$(tr ',' '\n' < "$LATEST_JSON" | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
  if [ -z "$RAW_TAG" ]; then
    fail "Could not extract tag_name from GitHub latest release response."
  fi
  VERSION="${RAW_TAG#v}"
  VERSION="${VERSION#V}"
  validate_semver "$VERSION"
fi

ASSET_NAME="AS_Auto_Switcher_${VERSION}-${OS}-${ARCH}.tar.gz"
if [ -n "$BASE_URL" ]; then
  BASE_URL="${BASE_URL%/}"
  validate_base_url "$BASE_URL"
  DOWNLOAD_BASE="$BASE_URL"
else
  DOWNLOAD_BASE="https://github.com/${REPO}/releases/download/v${VERSION}"
fi

CHECKSUMS_URL="${DOWNLOAD_BASE}/checksums.txt"
ARCHIVE_URL="${DOWNLOAD_BASE}/${ASSET_NAME}"
CHECKSUMS_FILE="$TMP_DIR/checksums.txt"
ARCHIVE_FILE="$TMP_DIR/${ASSET_NAME}"

log "Downloading checksums.txt for v${VERSION}..."
curl -fsSL "$CHECKSUMS_URL" -o "$CHECKSUMS_FILE" || fail "Failed to download ${CHECKSUMS_URL}"

# Parse expected SHA-256 from checksums.txt before downloading the archive (no eval, anti-404 guard).
EXPECTED_SHA="$(tr -d '\r' < "$CHECKSUMS_FILE" | awk -v target="$ASSET_NAME" '
  {
    line = $0
    sub(/^[ \t]+/, "", line)
    sub(/[ \t]+$/, "", line)
    if (line == "") next
    sp = match(line, /[ \t]+/)
    if (sp == 0) next
    hash = tolower(substr(line, 1, RSTART - 1))
    rest = substr(line, RSTART + RLENGTH)
    sub(/^\*/, "", rest)
    if (rest == target) {
      print hash
      exit
    }
  }
')"

if [ -z "$EXPECTED_SHA" ]; then
  fail "Release v${VERSION} does not include a prebuilt package for ${OS}/${ARCH} (${ASSET_NAME}). Check https://github.com/${REPO}/releases/tag/v${VERSION} or specify another version with --version X.Y.Z."
fi
if ! printf '%s\n' "$EXPECTED_SHA" | grep -Eq '^[0-9a-f]{64}$'; then
  fail "Malformed SHA-256 hash in checksums.txt for '${ASSET_NAME}': '${EXPECTED_SHA}'"
fi

log "Downloading ${ASSET_NAME}..."
curl -fsSL "$ARCHIVE_URL" -o "$ARCHIVE_FILE" || fail "Failed to download ${ARCHIVE_URL}"

if [ ! -s "$ARCHIVE_FILE" ]; then
  fail "Downloaded archive is empty: ${ARCHIVE_FILE}"
fi

if [ "$OS" = "darwin" ]; then
  ACTUAL_SHA="$(shasum -a 256 "$ARCHIVE_FILE" | awk '{print tolower($1)}')"
else
  ACTUAL_SHA="$(sha256sum "$ARCHIVE_FILE" | awk '{print tolower($1)}')"
fi

if [ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]; then
  fail "SHA-256 checksum mismatch for ${ASSET_NAME}: expected ${EXPECTED_SHA}, got ${ACTUAL_SHA}"
fi
log "SHA-256 verified: ${ACTUAL_SHA}"

# Extract verified archive into isolated temp staging directory.
EXTRACT_DIR="$TMP_DIR/extract"
mkdir -p "$EXTRACT_DIR"
tar -xzf "$ARCHIVE_FILE" -C "$EXTRACT_DIR" || fail "Failed to extract ${ASSET_NAME}"

if [ "$OS" = "darwin" ]; then
  SRC_APP="$EXTRACT_DIR/AS Auto Switcher.app"
  if [ ! -d "$SRC_APP" ] || [ ! -f "$SRC_APP/Contents/MacOS/AS_Auto_Switcher" ]; then
    fail "Archive does not contain a valid 'AS Auto Switcher.app' bundle."
  fi

  if [ -n "$INSTALL_DIR" ]; then
    APP_PARENT="${INSTALL_DIR%/}"
    if [ "$APP_PARENT" = "/Applications" ] || [ -d "$APP_PARENT" ] || mkdir -p "$APP_PARENT"; then
      :
    fi
  elif [ -d "/Applications" ] && [ -w "/Applications" ]; then
    APP_PARENT="/Applications"
  else
    APP_PARENT="$HOME/Applications"
    mkdir -p "$APP_PARENT"
  fi

  validate_safe_target "$APP_PARENT"
  if [ ! -w "$APP_PARENT" ]; then
    fail "Target Applications directory is not writable without sudo: '${APP_PARENT}'"
  fi

  TARGET_APP="${APP_PARENT}/AS Auto Switcher.app"
  validate_safe_target "$TARGET_APP" "$APP_PARENT"

  STAGE_APP="${APP_PARENT}/.AS Auto Switcher.app.new.$$"
  BACKUP_APP="${APP_PARENT}/.AS Auto Switcher.app.bak.$$"
  rm -rf "$STAGE_APP" "$BACKUP_APP"

  if command -v ditto >/dev/null 2>&1; then
    ditto "$SRC_APP" "$STAGE_APP"
  else
    cp -R -p "$SRC_APP" "$STAGE_APP"
  fi
  chmod 755 "$STAGE_APP/Contents/MacOS/AS_Auto_Switcher"

  # Preserve any co-located user data directories if upgrading an existing bundle.
  for _rel in "Contents/MacOS/accounts_store" "Contents/MacOS/logs" "Contents/accounts_store" "Contents/logs"; do
    if [ -d "$TARGET_APP/$_rel" ] && [ ! -e "$STAGE_APP/$_rel" ]; then
      mkdir -p "$(dirname "$STAGE_APP/$_rel")"
      cp -R -p "$TARGET_APP/$_rel" "$STAGE_APP/$_rel"
    fi
  done

  if [ -e "$TARGET_APP" ]; then
    mv "$TARGET_APP" "$BACKUP_APP"
  fi
  if ! mv "$STAGE_APP" "$TARGET_APP"; then
    if [ -e "$BACKUP_APP" ]; then
      mv "$BACKUP_APP" "$TARGET_APP" || true
    fi
    rm -rf "$STAGE_APP" || true
    fail "Failed to move staged macOS app bundle into '${TARGET_APP}'"
  fi
  rm -rf "$BACKUP_APP"

  if command -v xattr >/dev/null 2>&1; then
    xattr -dr com.apple.quarantine "$TARGET_APP" 2>/dev/null || true
  fi
  if command -v codesign >/dev/null 2>&1; then
    if ! codesign --verify --deep --strict "$TARGET_APP" >/dev/null 2>&1; then
      warn "codesign verification reported a warning for '${TARGET_APP}'."
    fi
  fi

  log ""
  log "Installed AS Auto Switcher v${VERSION} (darwin/${ARCH}) to:"
  log "  ${TARGET_APP}"
  log "Launch with: open \"${TARGET_APP}\""
else
  SRC_BIN="$EXTRACT_DIR/bin/AS_Auto_Switcher"
  if [ ! -f "$SRC_BIN" ] || [ ! -s "$SRC_BIN" ]; then
    fail "Archive does not contain a valid 'bin/AS_Auto_Switcher' executable."
  fi

  DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
  DATA_HOME="${DATA_HOME%/}"
  if [ -n "$INSTALL_DIR" ]; then
    INSTALL_ROOT="${INSTALL_DIR%/}"
  else
    INSTALL_ROOT="${DATA_HOME}/as-auto-switcher"
  fi
  validate_safe_target "$INSTALL_ROOT" "$DATA_HOME"

  INSTALL_PARENT="$(dirname "$INSTALL_ROOT")"
  mkdir -p "$INSTALL_PARENT"
  if [ ! -w "$INSTALL_PARENT" ]; then
    fail "Install parent directory is not writable without sudo: '${INSTALL_PARENT}'"
  fi

  STAGE_ROOT="${INSTALL_PARENT}/.as-auto-switcher.new.$$"
  BACKUP_ROOT="${INSTALL_PARENT}/.as-auto-switcher.bak.$$"
  rm -rf "$STAGE_ROOT" "$BACKUP_ROOT"
  mkdir -p "$STAGE_ROOT/bin"

  cp "$SRC_BIN" "$STAGE_ROOT/bin/AS_Auto_Switcher"
  chmod 755 "$STAGE_ROOT/bin/AS_Auto_Switcher"

  if [ -f "$EXTRACT_DIR/LICENSE" ]; then
    cp "$EXTRACT_DIR/LICENSE" "$STAGE_ROOT/LICENSE"
    chmod 644 "$STAGE_ROOT/LICENSE"
  fi
  if [ -f "$EXTRACT_DIR/install.sh" ]; then
    cp "$EXTRACT_DIR/install.sh" "$STAGE_ROOT/install.sh"
    chmod 755 "$STAGE_ROOT/install.sh"
  fi
  if [ -d "$EXTRACT_DIR/share" ]; then
    cp -R "$EXTRACT_DIR/share" "$STAGE_ROOT/share"
  fi

  # Write .install_manifest so updater/env_linux.go recognizes ModeLinuxArchive cleanly.
  INSTALLED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || printf 'unknown')"
  printf 'version=%s\narch=%s\ninstalled_at=%s\n' "$VERSION" "$ARCH" "$INSTALLED_AT" > "$STAGE_ROOT/.install_manifest"
  chmod 600 "$STAGE_ROOT/.install_manifest"

  # Preserve existing user account store and logs when upgrading.
  for _rel in "accounts_store" "logs"; do
    if [ -d "$INSTALL_ROOT/$_rel" ] && [ ! -e "$STAGE_ROOT/$_rel" ]; then
      cp -R -p "$INSTALL_ROOT/$_rel" "$STAGE_ROOT/$_rel"
    fi
  done

  if [ -e "$INSTALL_ROOT" ]; then
    mv "$INSTALL_ROOT" "$BACKUP_ROOT"
  fi
  if ! mv "$STAGE_ROOT" "$INSTALL_ROOT"; then
    if [ -e "$BACKUP_ROOT" ]; then
      mv "$BACKUP_ROOT" "$INSTALL_ROOT" || true
    fi
    rm -rf "$STAGE_ROOT" || true
    fail "Failed to promote staged Linux installation into '${INSTALL_ROOT}'"
  fi
  rm -rf "$BACKUP_ROOT"

  # Symlink CLI/GUI entrypoint into ~/.local/bin.
  BIN_LINK_DIR="$HOME/.local/bin"
  mkdir -p "$BIN_LINK_DIR"
  SYMLINK_PATH="${BIN_LINK_DIR}/as-auto-switcher"
  ln -sfn "${INSTALL_ROOT}/bin/AS_Auto_Switcher" "$SYMLINK_PATH"

  # Install desktop icon and Freedesktop .desktop entry.
  SRC_ICON="$EXTRACT_DIR/share/icons/hicolor/256x256/apps/as-auto-switcher.png"
  ICON_DIR="${DATA_HOME}/icons/hicolor/256x256/apps"
  if [ -f "$SRC_ICON" ]; then
    mkdir -p "$ICON_DIR"
    cp "$SRC_ICON" "${ICON_DIR}/as-auto-switcher.png"
    chmod 644 "${ICON_DIR}/as-auto-switcher.png"
  fi

  SRC_DESKTOP="$EXTRACT_DIR/share/applications/as-auto-switcher.desktop"
  APPS_DIR="${DATA_HOME}/applications"
  if [ -f "$SRC_DESKTOP" ]; then
    mkdir -p "$APPS_DIR"
    case "$SYMLINK_PATH" in
      *" "*) EXEC_VALUE="\"${SYMLINK_PATH}\"" ;;
      *)     EXEC_VALUE="${SYMLINK_PATH}" ;;
    esac
    awk -v exec_val="$EXEC_VALUE" '
      $0 == "Exec=as-auto-switcher" || $0 == "Exec={{EXEC}}" {
        print "Exec=" exec_val
        next
      }
      { print }
    ' "$SRC_DESKTOP" > "${APPS_DIR}/as-auto-switcher.desktop"
    chmod 644 "${APPS_DIR}/as-auto-switcher.desktop"
  fi

  if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APPS_DIR" >/dev/null 2>&1 || true
  fi
  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -q -t -f "${DATA_HOME}/icons/hicolor" >/dev/null 2>&1 || true
  fi

  log ""
  log "Installed AS Auto Switcher v${VERSION} (linux/${ARCH}) to:"
  log "  Install root : ${INSTALL_ROOT}"
  log "  Symlink      : ${SYMLINK_PATH}"
  log "  Desktop file : ${APPS_DIR}/as-auto-switcher.desktop"
  case ":${PATH:-}:" in
    *":${BIN_LINK_DIR}:"*) ;;
    *)
      log ""
      log "Note: Add '${BIN_LINK_DIR}' to your PATH to launch 'as-auto-switcher' from any terminal."
      ;;
  esac
fi
