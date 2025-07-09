# Claude Desktop Preferences Changelog

## [3.3.0] - 2025-07-09

### Added
- **Context7 Integration**: Primary source for library documentation
  - React ecosystem mappings with snippet counts
  - Documentation-first development workflow
  - Hierarchy: Internal knowledge → Context7 → Web search

- **Tool Orchestration Framework**
  - Multi-tool workflow patterns
  - Tool selection matrix by query type and timeframe
  - Progressive enhancement strategies

- **Linear Project Management**
  - CLOCLO team integration
  - Issue tracking in development workflow
  - Requirements checking before implementation

- **Cloudflare Tools Integration**
  - DNS management patterns
  - Web scraping capabilities

- **Artifact Creation Guidelines**
  - Clear rules for artifact vs inline code (>20 lines)
  - Artifact type specifications
  - Integration with development workflows

### Changed
- **File Operation Limits** (Major Performance Update)
  - Write limit: 50 → 1000 lines (20x increase)
  - Read limit: 1000 → 5000 lines (5x increase)
  - Validated with performance testing (4-9ms operations)

- **Security Configuration**
  - Extended GPG/pass patterns to all new tools
  - Added tool-specific credential patterns
  - Updated integration examples

### Enhanced
- **Development Workflows**
  - Added pre-initialization checks with Linear/Context7
  - Documentation-driven development pattern
  - Framework-specific initialization sequences

- **Performance Optimization**
  - Updated chunking strategies based on new limits
  - Added caching strategies for tool results
  - Parallel operation patterns

- **Communication Patterns**
  - Tool transparency formatting
  - Progressive enhancement for responses
  - Enhanced emoji usage for clarity

### Technical Details
- Tested cross-filesystem performance: 50-60% overhead (consistent)
- Context7 provides 2500+ React snippets, 9400+ Router examples
- All file operations complete in under 10ms

## [3.2.0] - 2025-07-08
- Initial version with GPG/pass migration
- Basic Desktop Commander configuration
- Cross-platform development setup