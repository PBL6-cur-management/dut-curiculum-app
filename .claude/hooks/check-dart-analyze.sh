#!/bin/bash
# Runs `dart analyze` on the edited Dart file after every Edit/Write.
# Catches errors immediately — most importantly, stale imports that point to
# deleted files (the primary symptom of dead-code cleanup leaving references behind).
# Only errors are fatal; hints/warnings are left to the IDE.
# Registered as a PostToolUse hook on the Edit|Write matcher.
# Exit 2 = block (hard error); exit 1 = advisory only.

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

# Run dart analyze on the specific file from the project root
ANALYZE_OUTPUT=$(cd "$CLAUDE_PROJECT_DIR" && dart analyze "$FILE_PATH" 2>&1)
ANALYZE_EXIT=$?

# dart analyze exits 0 on clean, 3 when issues found
if [[ $ANALYZE_EXIT -eq 0 ]]; then
  exit 0
fi

# Filter to errors only (skip hints/warnings — those are IDE noise)
ERRORS=$(echo "$ANALYZE_OUTPUT" | grep -E "^  error •" | head -10)

if [[ -z "$ERRORS" ]]; then
  # Only hints/warnings — not fatal
  exit 0
fi

echo "dart analyze — errors in $FILE_PATH:" >&2
echo "$ERRORS" >&2
echo "" >&2
echo "  Fix all errors before moving on (ai-rules.md Rule 10)." >&2
echo "  Common cause after dead-code removal: a stale import pointing to a deleted file." >&2
exit 2
