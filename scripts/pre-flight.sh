#!/usr/bin/env bash
# Pre-flight checks for pixel-perfect rewrite workflow
# Run before starting any Chrome DevTools MCP work

set -euo pipefail

PASS="[OK]"
FAIL="[FAIL]"
WARN="[WARN]"
status=0

echo "=== Pre-Flight Check ==="
echo ""

# 1. Kill orphaned Chrome processes
echo -n "1. Orphaned Chrome processes... "
chrome_pids=$(pgrep -f 'chrome.*remote-debugging' 2>/dev/null || true)
if [ -n "$chrome_pids" ]; then
  kill $chrome_pids 2>/dev/null || true
  sleep 1
  # Check if they actually died
  remaining=$(pgrep -f 'chrome.*remote-debugging' 2>/dev/null || true)
  if [ -n "$remaining" ]; then
    echo "$WARN killed some, but PIDs still running: $remaining"
  else
    echo "$PASS killed $(echo "$chrome_pids" | wc -w | tr -d ' ') process(es)"
  fi
else
  echo "$PASS none found"
fi

# 2. Remove Chrome SingletonLock files
echo -n "2. Chrome lock files... "
locks_removed=0
for lockfile in \
  "$HOME/.config/google-chrome/SingletonLock" \
  "$HOME/.config/google-chrome/SingletonCookie" \
  "$HOME/.config/google-chrome/SingletonSocket" \
  "$LOCALAPPDATA/Google/Chrome/User Data/SingletonLock" \
  "$LOCALAPPDATA/Google/Chrome/User Data/SingletonCookie" \
  "$LOCALAPPDATA/Google/Chrome/User Data/SingletonSocket" \
  "$HOME/.cache/chrome-devtools-mcp/chrome-profile/SingletonLock" \
  "$HOME/.cache/chrome-devtools-mcp/chrome-profile/SingletonCookie" \
  "$HOME/.cache/chrome-devtools-mcp/chrome-profile/SingletonSocket"; do
  if [ -e "$lockfile" ] 2>/dev/null; then
    rm -f "$lockfile" 2>/dev/null && locks_removed=$((locks_removed + 1))
  fi
done
if [ $locks_removed -gt 0 ]; then
  echo "$PASS removed $locks_removed lock file(s)"
else
  echo "$PASS none found"
fi

# 3. Verify bash is functional
echo -n "3. Bash functional... "
test_result=$(echo "hello" | tr 'h' 'H' 2>&1) || true
if [ "$test_result" = "Hello" ]; then
  echo "$PASS"
else
  echo "$FAIL basic pipe/tr test failed (Cygwin DLL issue?). Restart terminal."
  status=1
fi

# 4. Check dev server
echo -n "4. Dev server (localhost:4321)... "
if curl -sf -o /dev/null --max-time 3 http://localhost:4321/ 2>/dev/null; then
  echo "$PASS running"
else
  echo "$WARN not running. Start with: cd wife-website && npm run dev"
fi

# 5. Check Chrome DevTools MCP connectivity
echo -n "5. Chrome DevTools MCP... "
cdp_port=${CDP_PORT:-9222}
if curl -sf -o /dev/null --max-time 3 "http://localhost:$cdp_port/json/version" 2>/dev/null; then
  echo "$PASS connected on port $cdp_port"
else
  echo "$WARN no response on port $cdp_port (Chrome may start on first MCP call)"
fi

# Summary
echo ""
echo "=== Pre-Flight Complete ==="
if [ $status -ne 0 ]; then
  echo "Some checks FAILED. Fix issues before proceeding."
else
  echo "All critical checks passed. Ready to go."
fi

exit $status
