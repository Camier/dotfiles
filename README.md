# WSL2 Ubuntu Development Environment Complete Guide

**Last Updated**: January 8, 2025  
**Created**: January 8, 2025  
**Environment**: WSL2 on Windows 11  
**Author**: Camier (mickael.souedan@hotmail.fr)

## Table of Contents
1. [System Information](#system-information)
2. [Initial Setup Commands](#initial-setup-commands)
3. [Development Tools Installed](#development-tools-installed)
4. [Configuration Files](#configuration-files)
5. [Custom Scripts](#custom-scripts)
6. [Aliases and Commands](#aliases-and-commands)
7. [Quick Reference](#quick-reference)
8. [Database Management](#database-management)
9. [Troubleshooting](#troubleshooting)
10. [Maintenance](#maintenance)

---

## System Information

- **OS**: Ubuntu 22.04.5 LTS
- **Kernel**: 6.6.87.2-microsoft-standard-WSL2
- **Architecture**: x86_64
- **Windows Host**: Windows 11 with RTX 3070, 32GB RAM
- **WSL2 Config**: 16GB RAM, 8 processors, mirrored networking
- **Username**: miko
- **Hostname**: BASIC
- **IP Address**: 192.168.1.33

### Installed Versions
- **Node.js**: v22.17.0 (via NVM)
- **Python**: 3.13.0 & 3.11.8 (via pyenv)
- **Java**: OpenJDK 17
- **PostgreSQL**: 14.18
- **MySQL**: 8.0.42
- **MongoDB**: 7.0.21
- **Redis**: 6.0.16
- **Docker**: Latest via Docker Desktop
- **Git**: Latest version

---

## Initial Setup Commands

### 1. System Update and Essential Packages
```bash
# System updates
sudo apt update && sudo apt upgrade -y

# Essential build tools
sudo apt install -y build-essential curl wget software-properties-common \
  apt-transport-https ca-certificates gnupg lsb-release

# Additional utilities
sudo apt install -y zip unzip htop neofetch tree jq ripgrep fd-find bat exa
```

### 2. Shell Environment (Zsh + Oh My Zsh)
```bash
# Install Zsh
sudo apt install -y zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 3. Programming Languages

#### Node.js (via NVM)
```bash
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.zshrc

# Install Node.js
nvm install --lts
nvm use --lts
nvm alias default node

# Global packages
npm install -g yarn pnpm typescript ts-node nodemon pm2
```

#### Python (via pyenv)
```bash
# Install dependencies
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils \
  tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install pyenv
curl https://pyenv.run | bash

# Install Python versions
pyenv install 3.13.0
pyenv install 3.11.8
pyenv global 3.13.0

# Python packages
pip install --upgrade pip
pip install pipx virtualenv poetry black flake8 mypy pytest ipython jupyter
```

#### Java
```bash
sudo apt install -y openjdk-17-jdk openjdk-21-jdk maven gradle
```

### 4. Databases

#### PostgreSQL
```bash
sudo apt install -y postgresql postgresql-contrib
sudo service postgresql start
```

#### MySQL
```bash
sudo apt install -y mysql-server
sudo service mysql start
sudo mysql_secure_installation
```

#### MongoDB
```bash
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] \
  https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
```

#### Redis
```bash
sudo apt install -y redis-server
sudo service redis-server start
```

### 5. Development Tools
```bash
# Git configuration
git config --global user.name "Camier"
git config --global user.email "mickael.souedan@hotmail.fr"
git config --global core.editor "code --wait"
git config --global init.defaultBranch main
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
git config --global core.autocrlf input
git config --global core.eol lf

# SSH key generation
ssh-keygen -t ed25519 -C "mickael.souedan@hotmail.fr"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Additional tools
sudo apt install -y neovim
sudo snap install postman
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh -y

# ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok
```

---

## Configuration Files

### ~/.zshrc (Complete)
```bash
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git docker docker-compose node npm python pip zsh-autosuggestions zsh-syntax-highlighting sudo z extract)

source $ZSH/oh-my-zsh.sh

# User configuration

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Path additions
export PATH=$HOME/.local/bin:$PATH

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Windows program aliases (since Windows PATH is disabled)
alias code="/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code"
alias explorer="/mnt/c/Windows/explorer.exe"
alias notepad="/mnt/c/Windows/notepad.exe"

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs'
alias dprune='docker system prune -a'

# Service management
alias start-dev='~/start-services.sh'

# Database aliases
alias mydb='psql -U miko -d myapp_dev -h localhost'
alias mydb-mysql='mysql -u miko -p@lfred33 myapp_dev'
alias mydb-mongo='mongosh -u miko -p @lfred33 --authenticationDatabase myapp_dev myapp_dev'
alias mydb-redis='redis-cli -a @lfred33'

# Better tools
if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -la'
    alias lt='exa --tree'
fi

if command -v batcat &> /dev/null; then
    alias cat='batcat'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

### /etc/wsl.conf
```ini
[boot]
systemd=true

[network]
generateResolvConf = false

[interop]
appendWindowsPath = false
```

### Windows .wslconfig (C:\Users\micka\.wslconfig)
```ini
[wsl2]
memory=16GB
processors=8
localhostForwarding=true
nestedVirtualization=true
networkingMode=mirrored

[experimental]
sparseVhd=true
autoMemoryReclaim=gradual
```
**Note**: Remove deprecated keys: `wsl2.pageReporting`, `experimental.useWindowsDnsCache`

### Database Configuration Files

#### PostgreSQL (~/.pgpass)
```
localhost:5432:myapp_dev:miko:@lfred33
```
**Permissions**: `chmod 600 ~/.pgpass`

#### MongoDB (/etc/mongod.conf) - Key sections:
```yaml
# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1,localhost

# security - IMPORTANT: Must be under security, not processManagement
security:
  authorization: enabled
```

#### Redis (/etc/redis/redis.conf) - Key settings:
```conf
# Around line 790
requirepass @lfred33
```

#### MySQL Configuration
- User created with: `CREATE USER 'miko'@'localhost' IDENTIFIED BY '@lfred33';`
- Privileges: `GRANT ALL PRIVILEGES ON myapp_dev.* TO 'miko'@'localhost';`

---

## Custom Scripts

### ~/start-services.sh
```bash
#!/bin/bash
echo "Starting development services..."
sudo service postgresql start
sudo service mysql start
sudo service redis-server start
sudo systemctl start mongod
echo "All services started!"
```

### ~/check-env.sh
```bash
#!/bin/bash
echo "=== Development Environment Check ==="
echo ""
echo "System Info:"
echo "- OS: $(lsb_release -d | cut -f2)"
echo "- Kernel: $(uname -r)"
echo ""
echo "Languages & Runtimes:"
echo "- Node: $(node --version 2>/dev/null || echo 'Not installed')"
echo "- Python: $(python --version 2>/dev/null || echo 'Not installed')"
echo "- Java: $(java --version 2>&1 | head -n 1)"
echo ""
echo "Package Managers:"
echo "- npm: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "- yarn: $(yarn --version 2>/dev/null || echo 'Not installed')"
echo "- pnpm: $(pnpm --version 2>/dev/null || echo 'Not installed')"
echo "- pip: $(pip --version 2>/dev/null || echo 'Not installed')"
echo ""
echo "Development Tools:"
echo "- Git: $(git --version)"
echo "- Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
echo "- Docker Compose: $(docker compose version 2>/dev/null || echo 'Not installed')"
echo ""
echo "Databases (checking if installed, not if running):"
echo "- PostgreSQL: $(psql --version 2>/dev/null || echo 'Not installed')"
echo "- MySQL: $(mysql --version 2>/dev/null || echo 'Not installed')"
echo "- MongoDB: $(mongod --version 2>/dev/null | head -n 1 || echo 'Not installed')"
echo "- Redis: $(redis-server --version 2>/dev/null || echo 'Not installed')"
```

---

## Aliases and Commands

### Navigation
- `ll` - List files with details
- `la` - List all files
- `..` - Go up one directory
- `...` - Go up two directories
- `....` - Go up three directories

### Git
- `gs` - Git status
- `ga` - Git add
- `gc` - Git commit
- `gp` - Git push
- `gpl` - Git pull
- `gco` - Git checkout
- `gb` - Git branch
- `glog` - Git log (pretty format)

### Docker
- `dps` - Docker ps
- `dpsa` - Docker ps -a
- `di` - Docker images
- `dex` - Docker exec -it
- `dlog` - Docker logs
- `dprune` - Docker system prune -a
- `lazydocker` - Docker GUI

### Services
- `start-dev` - Start all development databases
- `~/check-env.sh` - Check environment status
- `mydb` - Connect to PostgreSQL myapp_dev
- `mydb-mysql` - Connect to MySQL myapp_dev  
- `mydb-mongo` - Connect to MongoDB myapp_dev
- `mydb-redis` - Connect to Redis with auth

---

## Quick Reference

### SSH Key
```
Public Key Location: ~/.ssh/id_ed25519.pub
GitHub SSH: ssh -T git@github.com
```

### Project Structure
```
~/projects/
├── personal/
├── work/
└── learning/
```

### VS Code Integration
```bash
# Open current directory in VS Code
code .

# Required extensions installed:
# - ms-vscode-remote.remote-wsl
# - dbaeumer.vscode-eslint
# - esbenp.prettier-vscode
# - ms-python.python
# - ms-vscode.cpptools
# - vscjava.vscode-java-pack
```

### Database Access

All databases are configured with consistent credentials:
- **Username**: miko
- **Password**: @lfred33
- **Development Database**: myapp_dev

#### Quick Connect Aliases (Configured and Tested):
```bash
mydb              # PostgreSQL myapp_dev
mydb-mysql        # MySQL myapp_dev
mydb-mongo        # MongoDB myapp_dev
mydb-redis        # Redis with auth
```

#### Manual Connection Commands:
```bash
# PostgreSQL
psql -U miko -d myapp_dev -h localhost

# MySQL
mysql -u miko -p@lfred33 myapp_dev

# MongoDB (with auth enabled)
mongosh -u miko -p @lfred33 --authenticationDatabase myapp_dev myapp_dev

# Redis (with password)
redis-cli -a @lfred33
```

#### Connection Strings for Applications:
```bash
# PostgreSQL
postgresql://miko:@lfred33@localhost:5432/myapp_dev

# MySQL
mysql://miko:@lfred33@localhost:3306/myapp_dev

# MongoDB
mongodb://miko:@lfred33@localhost:27017/myapp_dev

# Redis
redis://:@lfred33@localhost:6379
```

#### Quick Test Commands (All Working):
```bash
# PostgreSQL
mydb -c "SELECT version();" -q

# MySQL  
echo "SELECT VERSION();" | mydb-mysql -s

# MongoDB
echo "db.version()" | mydb-mongo --quiet

# Redis
echo "INFO server" | mydb-redis | grep redis_version
```

---

## Database Management

### PostgreSQL Commands
```sql
-- List databases
\l

-- Connect to database
\c database_name

-- List tables
\dt

-- Describe table
\d table_name

-- Create database
CREATE DATABASE dbname;

-- Drop database
DROP DATABASE dbname;

-- Backup database
pg_dump -U miko myapp_dev > backup.sql

-- Restore database
psql -U miko myapp_dev < backup.sql
```

### MySQL Commands
```sql
-- List databases
SHOW DATABASES;

-- Use database
USE database_name;

-- List tables
SHOW TABLES;

-- Describe table
DESCRIBE table_name;

-- Create database
CREATE DATABASE dbname;

-- Drop database
DROP DATABASE dbname;

-- Backup database
mysqldump -u miko -p@lfred33 myapp_dev > backup.sql

-- Restore database
mysql -u miko -p@lfred33 myapp_dev < backup.sql
```

### MongoDB Commands
```javascript
// List databases
show dbs

// Use database
use database_name

// List collections
show collections

// Create collection
db.createCollection("users")

// Find documents
db.users.find()

// Backup database
mongodump --db myapp_dev -u miko -p @lfred33

// Restore database
mongorestore --db myapp_dev -u miko -p @lfred33 dump/myapp_dev
```

### Redis Commands
```bash
# Test connection
PING

# Set key
SET key value

# Get key
GET key

# List all keys
KEYS *

# Delete key
DEL key

# Clear all data
FLUSHALL

# Save snapshot
SAVE

# Get info
INFO
```

---

### WSL Issues
```bash
# Restart WSL from Windows PowerShell
wsl --shutdown
wsl

# Check WSL version
wsl -l -v

# Update WSL
wsl --update
```

### Path Issues
If Windows programs aren't working, check aliases in ~/.zshrc

### NVM and Node.js Issues
```bash
# If you get prefix errors with npm
nvm use --delete-prefix v22.17.0 --silent

# Reinstall global packages after Node update
nvm install --lts --reinstall-packages-from=current

# Check current Node version
nvm current

# List installed Node versions
nvm list
```

### Database Connection Issues
```bash
# Check if services are running
sudo service postgresql status
sudo service mysql status
sudo systemctl status mongod
sudo service redis-server status
```

---

## Maintenance

### Regular Updates
```bash
# System packages
sudo apt update && sudo apt upgrade

# Node.js
nvm install --lts --reinstall-packages-from=current
npm update -g

# Python packages
pip install --upgrade pip
pyenv update

# Oh My Zsh
omz update
```

### Backup Important Files
- `~/.zshrc`
- `~/.ssh/`
- `~/.gitconfig`
- `/etc/wsl.conf`
- Custom scripts in home directory

### Clean Up
```bash
# APT cleanup
sudo apt autoremove
sudo apt autoclean

# Docker cleanup
docker system prune -a

# NPM cache
npm cache clean --force

# Python cache
pip cache purge
```

---

## Additional Resources

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [NVM](https://github.com/nvm-sh/nvm)
- [pyenv](https://github.com/pyenv/pyenv)

---

## Notes

- Created: January 8, 2025
- Last Updated: January 8, 2025
- Environment: WSL2 on Windows 11
- Database Password: @lfred33
- Contact: mickael.souedan@hotmail.fr

---

## Setup Verification

All components have been installed, configured, and tested successfully:

### ✅ Shell Environment
- Zsh with Oh My Zsh
- Powerlevel10k theme
- Auto-suggestions and syntax highlighting

### ✅ Programming Languages
- Node.js v22.17.0 (NVM)
- Python 3.13.0 & 3.11.8 (pyenv)
- Java OpenJDK 17

### ✅ Databases (All Working)
| Database   | Version | Alias       | Status |
|------------|---------|-------------|--------|
| PostgreSQL | 14.18   | `mydb`      | ✅     |
| MySQL      | 8.0.42  | `mydb-mysql`| ✅     |
| MongoDB    | 7.0.21  | `mydb-mongo`| ✅     |
| Redis      | 6.0.16  | `mydb-redis`| ✅     |

### ✅ Development Tools
- Git with SSH keys configured
- Docker & Docker Compose
- VS Code with WSL extension
- Neovim, GitHub CLI, Postman
- lazydocker, ngrok

### 📁 Project Structure Created
```
~/projects/
├── personal/
├── work/
└── learning/
```

### 🚀 Ready for Development!
All services can be started with: `start-dev`