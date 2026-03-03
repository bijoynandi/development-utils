# 📦 COMPILED SOFTWARE LOG
**System:** Fedora 43
**User:** bijoy
**Last Updated:** 2026-03-02

---

## Currently Installed

### ble.sh (Bash Line Editor)
- **Version:** 0.4.0-devel4+32bb63d
- **Install Date:** 2026-03-02
- **Source Location:** `~/Documents/Development/Sources/ble.sh`
- **Install Location:** `~/.local/share/blesh/`
- **Install Method:** 
  ```bash
  git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git
  cd ble.sh
  make
  make install PREFIX=~/.local
  ```
- **Update Method:**
  ```bash
  cd ~/Documents/Development/Sources/ble.sh
  git pull
  git submodule update --init --recursive
  make clean && make
  make install PREFIX=~/.local
  source ~/.bashrc
  ```
- **Remove Method:**
  ```bash
  rm -rf ~/.local/share/blesh
  rm -rf ~/.local/share/doc/blesh
  # Comment out in ~/.bashrc.d/tools.sh
  ```
- **Status:** ✅ Working perfectly
- **Notes:** 
  - Development version (bleeding edge)
  - Last stable: v0.3.4 (2022)
  - Provides syntax highlighting and auto-suggestions
  - No DNF package available, must compile
  - Check for updates: Every 6-12 months

---

## Pre-installed Tools (Not Compiled)

### bat (Better cat)
- **Status:** Installed via DNF or binary
- **Location:** `/usr/local/bin/bat` or `/usr/bin/bat`

### fd (Better find)
- **Status:** Installed via DNF or binary
- **Location:** `/usr/local/bin/fd` or `/usr/bin/fd`

### ripgrep (Better grep)
- **Status:** Installed via DNF or binary
- **Location:** `/usr/local/bin/rg` or `/usr/bin/rg`

### tmux (Terminal multiplexer)
- **Status:** Installed via DNF
- **Location:** `/usr/bin/tmux`

### neovim (Better vim)
- **Status:** Installed via DNF
- **Location:** `/usr/bin/nvim`

---

## Update Schedule

**Check for updates:**
- ble.sh: Every 6-12 months
- Or when you need new features
- Or when you notice a bug

**Set reminders:**
- [ ] September 2026
- [ ] March 2027
- [ ] September 2027

---

## Future Compilations

**Potential candidates for source compilation:**
- None planned (use DNF when possible!)

**Only compile when:**
1. Not available in DNF repos
2. Need bleeding-edge features
3. Learning experience
4. Specific customization needed

---

## Notes

**Philosophy:**
- Prefer DNF for easy maintenance
- Compile only when necessary
- Keep this log updated
- Track install/update methods
- Document everything!

**Remember:**
- Compiled software = Your responsibility
- No automatic updates
- Manual maintenance required
- But... you learn SO much! 💚

---

**Last Check:** 2026-03-03
**Next Check:** 2026-09-03 (6 months)
