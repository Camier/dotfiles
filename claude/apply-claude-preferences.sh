#!/bin/bash
# Apply Claude Desktop Preferences v3.3.0
# chmod +x apply-claude-preferences.sh
# This script installs the Claude preferences to appropriate locations

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Claude Desktop Preferences v3.3.0 Installation${NC}"
echo "=============================================="

# Check if preferences file exists
PREFS_FILE="preferences-v3.3.0.json"
if [ ! -f "$PREFS_FILE" ]; then
    echo -e "${RED}Error: $PREFS_FILE not found in current directory${NC}"
    exit 1
fi

# Create config directory if it doesn't exist
CLAUDE_CONFIG_DIR="$HOME/.config/claude"
echo -e "${YELLOW}Creating Claude config directory...${NC}"
mkdir -p "$CLAUDE_CONFIG_DIR"

# Backup existing preferences if they exist
if [ -f "$CLAUDE_CONFIG_DIR/preferences.json" ]; then
    BACKUP_FILE="$CLAUDE_CONFIG_DIR/preferences.json.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Backing up existing preferences to:${NC}"
    echo "  $BACKUP_FILE"
    cp "$CLAUDE_CONFIG_DIR/preferences.json" "$BACKUP_FILE"
fi

# Copy new preferences
echo -e "${YELLOW}Installing new preferences...${NC}"
cp "$PREFS_FILE" "$CLAUDE_CONFIG_DIR/preferences.json"

# Create symlink in home directory for easy access
SYMLINK="$HOME/claude-preferences.json"
if [ -L "$SYMLINK" ]; then
    rm "$SYMLINK"
fi
ln -s "$CLAUDE_CONFIG_DIR/preferences.json" "$SYMLINK"
echo -e "${GREEN}✓ Created symlink: $SYMLINK${NC}"

# Summary of changes
echo -e "\n${GREEN}✓ Installation Complete!${NC}"
echo -e "\n${YELLOW}Key Features Enabled:${NC}"
echo "  • Context7 documentation integration"
echo "  • File operations: 1000 lines write / 5000 lines read"
echo "  • Linear project management integration"
echo "  • Enhanced tool orchestration"
echo "  • GPG/pass security patterns"

echo -e "\n${YELLOW}Configuration Locations:${NC}"
echo "  • Main config: $CLAUDE_CONFIG_DIR/preferences.json"
echo "  • Symlink: $SYMLINK"
echo "  • Backup: ${BACKUP_FILE:-None created}"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "  1. Test new features with: ./test-claude-features.sh"
echo "  2. Try Context7: Ask about React hooks documentation"
echo "  3. Test file limits: Create a 1000-line file"

echo -e "\n${GREEN}Happy coding with Claude Desktop v3.3.0! 🚀${NC}"