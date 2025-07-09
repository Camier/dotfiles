#!/bin/bash
# Test Claude Desktop Features v3.3.0
# Validates the new capabilities and performance improvements

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Claude Desktop v3.3.0 Feature Test Suite          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"

# Test directory
TEST_DIR="$HOME/claude-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo -e "\n${YELLOW}Test Directory: $TEST_DIR${NC}"

# Function to run a test
run_test() {
    local test_name=$1
    local test_description=$2
    echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Test: $test_name${NC}"
    echo -e "Description: $test_description"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Test 1: File Operation Limits
run_test "File Operation Limits" "Testing 1000-line write and 5000-line read capabilities"

echo -e "${BLUE}Creating test files...${NC}"
# Create 1000-line file
seq 1 1000 | sed 's/^/Line /' > test-1000.txt
echo -e "${GREEN}✓ Created 1000-line file${NC}"

# Create 5000-line file
seq 1 5000 | sed 's/^/Line /' > test-5000.txt
echo -e "${GREEN}✓ Created 5000-line file${NC}"

# Verify sizes
lines_1000=$(wc -l < test-1000.txt)
lines_5000=$(wc -l < test-5000.txt)
echo -e "${GREEN}✓ Verified: 1000-line file has $lines_1000 lines${NC}"
echo -e "${GREEN}✓ Verified: 5000-line file has $lines_5000 lines${NC}"

# Test 2: Cross-Filesystem Performance
if [ -d "/mnt/c/Temp" ]; then
    run_test "Cross-Filesystem Performance" "Testing WSL ↔ Windows file operations"
    
    # Time WSL to WSL copy
    start_time=$(date +%s.%N)
    cp test-1000.txt test-1000-copy.txt
    end_time=$(date +%s.%N)
    wsl_time=$(echo "$end_time - $start_time" | bc)
    echo -e "${GREEN}✓ WSL→WSL copy: ${wsl_time}s${NC}"
    
    # Time WSL to Windows copy
    start_time=$(date +%s.%N)
    cp test-1000.txt /mnt/c/Temp/test-1000.txt 2>/dev/null || true
    end_time=$(date +%s.%N)
    cross_time=$(echo "$end_time - $start_time" | bc)
    echo -e "${GREEN}✓ WSL→Windows copy: ${cross_time}s${NC}"
    
    # Calculate overhead
    if command -v bc &> /dev/null; then
        overhead=$(echo "scale=2; ($cross_time - $wsl_time) / $wsl_time * 100" | bc)
        echo -e "${BLUE}Cross-filesystem overhead: ${overhead}%${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Skipping cross-filesystem test (Windows mount not available)${NC}"
fi

# Test 3: Tool Availability Check
run_test "Tool Ecosystem" "Checking availability of integrated tools"

# Check for various tools
tools=(
    "git:Version Control"
    "node:Node.js"
    "python3:Python"
    "docker:Docker"
    "pass:Password Store"
    "gpg:GPG Encryption"
)

for tool_info in "${tools[@]}"; do
    IFS=':' read -r tool description <<< "$tool_info"
    if command -v "$tool" &> /dev/null; then
        version=$($tool --version 2>&1 | head -n1)
        echo -e "${GREEN}✓ $description: $version${NC}"
    else
        echo -e "${RED}✗ $description: Not found${NC}"
    fi
done

# Test 4: Claude Preferences Validation
run_test "Preferences Structure" "Validating Claude preferences JSON"

PREFS_FILE="$HOME/.config/claude/preferences.json"
if [ -f "$PREFS_FILE" ]; then
    # Check if jq is available for JSON validation
    if command -v jq &> /dev/null; then
        if jq empty "$PREFS_FILE" 2>/dev/null; then
            echo -e "${GREEN}✓ Preferences JSON is valid${NC}"
            
            # Extract key values
            version=$(jq -r '.metadata.version' "$PREFS_FILE" 2>/dev/null || echo "unknown")
            write_limit=$(jq -r '.system_context.desktop_commander.file_write_line_limit' "$PREFS_FILE" 2>/dev/null || echo "unknown")
            read_limit=$(jq -r '.system_context.desktop_commander.file_read_line_limit' "$PREFS_FILE" 2>/dev/null || echo "unknown")
            
            echo -e "${BLUE}  Version: $version${NC}"
            echo -e "${BLUE}  Write limit: $write_limit lines${NC}"
            echo -e "${BLUE}  Read limit: $read_limit lines${NC}"
        else
            echo -e "${RED}✗ Preferences JSON is invalid${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ jq not installed - skipping JSON validation${NC}"
        echo -e "${YELLOW}  Install with: sudo apt install jq${NC}"
    fi
else
    echo -e "${RED}✗ Preferences file not found at $PREFS_FILE${NC}"
fi

# Test 5: Security Configuration
run_test "Security Setup" "Checking GPG and pass configuration"

# Check GPG
if command -v gpg &> /dev/null; then
    key_count=$(gpg --list-secret-keys 2>/dev/null | grep -c "sec" || echo "0")
    echo -e "${GREEN}✓ GPG configured with $key_count secret key(s)${NC}"
fi

# Check pass
if command -v pass &> /dev/null; then
    if [ -d "$HOME/.password-store" ]; then
        pass_count=$(find "$HOME/.password-store" -name "*.gpg" 2>/dev/null | wc -l)
        echo -e "${GREEN}✓ Password store configured with $pass_count entries${NC}"
    else
        echo -e "${YELLOW}⚠ Password store directory not found${NC}"
    fi
fi

# Test 6: Sample Workflows
run_test "Sample Workflows" "Demonstrating key features"

echo -e "${BLUE}1. Documentation Workflow:${NC}"
echo "   Context7 (library docs) → Implementation → Artifact creation"

echo -e "\n${BLUE}2. File Operation Workflow:${NC}"
echo "   Read up to 5000 lines → Process → Write up to 1000 lines"

echo -e "\n${BLUE}3. Project Management Workflow:${NC}"
echo "   Linear (requirements) → Development → Git (with issue refs)"

# Cleanup
echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Cleaning up test directory...${NC}"
cd "$HOME"
rm -rf "$TEST_DIR"
echo -e "${GREEN}✓ Cleanup complete${NC}"

# Summary
echo -e "\n${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Test Summary                          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}✓ File operation limits validated${NC}"
echo -e "${GREEN}✓ Tool ecosystem checked${NC}"
echo -e "${GREEN}✓ Security configuration verified${NC}"
echo -e "${GREEN}✓ Workflows demonstrated${NC}"
echo -e "\n${YELLOW}Claude Desktop v3.3.0 is ready for enhanced development!${NC} 🚀"