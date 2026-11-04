#!/bin/bash
# Warns when a component widget (in presentation/components/ or common/widgets/) accesses
# a Cubit/Bloc directly via context.read<> or BlocProvider.of<>.
# Components must be pure UI — cubit access belongs only in screen widgets.
# Registered as a PostToolUse hook on the Edit|Write matcher.
# Exit 1 = advisory.

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

# Only apply to files inside presentation/components/ or common/widgets/
if [[ "$FILE_PATH" != */presentation/components/* && "$FILE_PATH" != */common/widgets/* ]]; then
  exit 0
fi

FOUND=0
MESSAGES=()

# Pattern 1: context.read<>() / context.watch<>() / context.select<>()
if grep -qP 'context\.(read|watch|select)\s*<' "$FILE_PATH" 2>/dev/null; then
  MATCHES=$(grep -nP 'context\.(read|watch|select)\s*<' "$FILE_PATH" | head -3)
  MESSAGES+=("context.read/watch/select in a component widget:\n$MATCHES")
  FOUND=1
fi

# Pattern 2: BlocProvider.of<>()
if grep -qP 'BlocProvider\.of\s*<' "$FILE_PATH" 2>/dev/null; then
  MATCHES=$(grep -nP 'BlocProvider\.of\s*<' "$FILE_PATH" | head -3)
  MESSAGES+=("BlocProvider.of<>() in a component widget:\n$MATCHES")
  FOUND=1
fi

# Pattern 3: BlocBuilder/BlocListener/BlocConsumer inside a component
if grep -qP 'BlocBuilder\s*<|BlocListener\s*<|BlocConsumer\s*<' "$FILE_PATH" 2>/dev/null; then
  MATCHES=$(grep -nP 'BlocBuilder\s*<|BlocListener\s*<|BlocConsumer\s*<' "$FILE_PATH" | head -3)
  MESSAGES+=("BlocBuilder/BlocListener/BlocConsumer in a component widget — state observation belongs in the screen:\n$MATCHES")
  FOUND=1
fi

if [[ $FOUND -eq 1 ]]; then
  echo "flutter-rules.md #14 — Widget purity violation in $FILE_PATH:" >&2
  for msg in "${MESSAGES[@]}"; do
    echo -e "  • $msg" >&2
  done
  echo "  Fix: move cubit access up to the screen widget and pass data/callbacks down via constructor parameters." >&2
  exit 1
fi

exit 0
