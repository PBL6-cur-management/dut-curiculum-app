#!/bin/bash
# Warns when catch blocks silently swallow errors in Dart files.
# Registered as a PostToolUse hook on the Edit|Write matcher.
# Exit 1 = advisory (Claude sees it and should fix before finishing).

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only apply to Dart files
if [[ "$FILE_PATH" != *.dart ]]; then
  exit 0
fi

# Skip generated files
if [[ "$FILE_PATH" == *.g.dart || "$FILE_PATH" == *.freezed.dart || "$FILE_PATH" == *generated* ]]; then
  exit 0
fi

FOUND=0
MESSAGES=()

# Pattern 1: empty catch block — catch (e) { } or catch (_) { }
if grep -qP 'catch\s*\([^)]*\)\s*\{\s*\}' "$FILE_PATH" 2>/dev/null; then
  MATCHES=$(grep -nP 'catch\s*\([^)]*\)\s*\{\s*\}' "$FILE_PATH" | head -3)
  MESSAGES+=("Empty catch block (swallowed exception):\n$MATCHES")
  FOUND=1
fi

# Pattern 2: catch block that only calls print/debugPrint/log with no emit/throw/show
if grep -qP 'catch\s*\([^)]*\)\s*\{\s*(print|debugPrint|log)\s*\(' "$FILE_PATH" 2>/dev/null; then
  MATCHES=$(grep -nP 'catch\s*\([^)]*\)\s*\{\s*(print|debugPrint|log)\s*\(' "$FILE_PATH" | head -3)
  MESSAGES+=("Catch block with only a print — error not surfaced to user:\n$MATCHES")
  FOUND=1
fi

# Pattern 3: catch block that only sets isLoading without emitting errorMessage
if grep -qP 'catch\s*\([^)]*\)\s*\{[^}]*isLoading:\s*false[^}]*\}' "$FILE_PATH" 2>/dev/null; then
  MATCHES=$(grep -nP 'catch\s*\([^)]*\)\s*\{' "$FILE_PATH" | head -3)
  MESSAGES+=("Catch block sets isLoading: false but emits no errorMessage — user gets no feedback:\n$MATCHES")
  FOUND=1
fi

if [[ $FOUND -eq 1 ]]; then
  echo "flutter-rules.md #13 — Error handling violation in $FILE_PATH:" >&2
  for msg in "${MESSAGES[@]}"; do
    echo -e "  • $msg" >&2
  done
  echo "  Fix: emit state.copyWith(errorMessage: e.toString()) so the UI can show the actual error." >&2
  exit 1
fi

exit 0
