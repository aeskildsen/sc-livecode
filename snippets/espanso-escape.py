#!/usr/bin/env python3
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: espanso-escape.py <input_file> [trigger]")
        print("If trigger is provided, outputs complete YAML entry")
        sys.exit(1)

    input_file = sys.argv[1]

    with open(input_file, 'r') as f:
        content = f.read()

    # Remove trailing newline if present
    if content.endswith('\n'):
        content = content[:-1]

    if len(sys.argv) > 2:
        trigger = sys.argv[2]
        print(f'  - trigger: ":{trigger}"')
        print('    replace: |')
        # Output each line with 6 spaces of indentation
        for line in content.split('\n'):
            print(f'      {line}')
        print('    paste_shortcut: true')
    else:
        # Output raw unescaped text
        print(content)
