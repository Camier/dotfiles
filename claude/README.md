# Claude Desktop Preferences v3.3.0

This directory contains the Claude Desktop preferences configuration for optimal development workflow.

## Files

- `claude-preferences-v3.3.0.json` - Complete preferences with tool orchestration
- `apply-claude-preferences.sh` - Script to install preferences
- `test-claude-features.sh` - Test script for new features

## Version 3.3.0 Features

### 🚀 Major Enhancements

1. **Context7 Integration** - Instant library documentation without web search
2. **Optimized File Limits** - 1000 lines write / 5000 lines read
3. **Tool Orchestration** - Multi-tool workflows defined
4. **Linear Integration** - Project management context
5. **Enhanced Security** - GPG/pass patterns extended

### 📊 Performance Improvements

- Documentation retrieval: ~90% faster (Context7 vs web search)
- File operations: 20x larger capacity tested and validated
- Cross-filesystem: Consistent 50-60% overhead (expected)

## Installation

```bash
# Run the installation script
./apply-claude-preferences.sh

# Or manually copy to Claude config directory
cp claude-preferences-v3.3.0.json ~/.config/claude/preferences.json
```

## Testing

```bash
# Test the new features
./test-claude-features.sh
```

## Key Workflows

### Documentation-First Development
```
Context7 (docs) → Desktop Commander (implement) → Linear (track) → Artifacts (deliver)
```

### Tool Selection by Query Type
- Library documentation → Context7
- Current events → Web search
- File operations → Desktop Commander
- Project context → Linear
- Complex analysis → Sequential thinking

## Quick Reference

### File Operation Limits
- Write: 1000 lines per operation
- Read: 5000 lines per operation
- Chunking: 25-30 lines for progressive updates

### Common Context7 Libraries
- React: `/context7/react_dev` (2461 snippets)
- React Router: `/context7/reactrouter` (9433 snippets)
- React Flow: `/context7/reactflow_dev` (2305 snippets)

## Updates from v3.2.0

- Added comprehensive tool orchestration section
- Integrated Context7 documentation patterns
- Updated file operation limits based on performance testing
- Added artifact creation guidelines
- Enhanced security patterns for new tools
- Included Linear project management workflows