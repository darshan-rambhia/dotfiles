#!/usr/bin/env bash
# Detect project language/tool and show version
# Timeout after 1 second to prevent hanging

dir="${1:-$(pwd)}"
cd "$dir" 2>/dev/null || exit 0

# Helper function with timeout
get_version() {
    timeout 1 "$@" 2>/dev/null
}

# Check for project files and show relevant version
if [[ -f "bun.lockb" ]] || [[ -f "bunfig.toml" ]]; then
    v=$(get_version bun --version)
    [[ -n "$v" ]] && echo "🥟 $v"
elif [[ -f "package.json" ]]; then
    v=$(get_version node --version)
    [[ -n "$v" ]] && echo "⬢ ${v#v}"
elif [[ -f "go.mod" ]]; then
    v=$(get_version go version | awk '{print $3}' | sed 's/go//')
    [[ -n "$v" ]] && echo "🐹 $v"
elif [[ -f "Cargo.toml" ]]; then
    v=$(get_version rustc --version | awk '{print $2}')
    [[ -n "$v" ]] && echo "🦀 $v"
elif [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
    v=$(get_version python3 --version | awk '{print $2}')
    [[ -n "$v" ]] && echo "🐍 $v"
elif [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
    v=$(get_version java --version | head -1 | awk '{print $2}')
    [[ -n "$v" ]] && echo "☕ $v"
elif ls *.csproj &>/dev/null 2>&1 || [[ -f "global.json" ]]; then
    v=$(get_version dotnet --version)
    [[ -n "$v" ]] && echo "🔷 $v"
elif ls *.tf &>/dev/null 2>&1; then
    if command -v tofu &>/dev/null; then
        v=$(get_version tofu version | head -1 | awk '{print $2}')
        [[ -n "$v" ]] && echo "🟣 ${v#v}"
    elif command -v terraform &>/dev/null; then
        v=$(get_version terraform version | head -1 | awk '{print $2}')
        [[ -n "$v" ]] && echo "🟪 ${v#v}"
    fi
fi
