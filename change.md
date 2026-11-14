# 📋 Changelog - AS Auto Switcher

All notable changes, new features, performance improvements, and bug fixes across releases of **AS Auto Switcher** are documented in this file.

---

## [Version 1.3.9] - 2026-11-15

### Versioned MSI-Only Release Packaging & Auto-Update Alignment
- **Versioned Windows Installer Distribution:** Official releases now ship exclusively as a single version-labeled Windows Installer (`AS_Auto_Switcher_1.3.9.msi`) alongside `checksums.txt` SHA-256 verification and release notes, removing unversioned duplicate installer and standalone executable downloads.
- **Aligned Background Auto-Update Lookup:** Installed desktop editions now resolve, SHA-256 verify, and apply each release's version-labeled Windows Installer (`AS_Auto_Switcher_<version>.msi`) directly from official GitHub Releases while preserving existing accounts and settings.
- **One-Time Manual Upgrade Notice (`1.3.6–1.3.8`):** Because earlier installed releases (`1.3.6–1.3.8`) look for the legacy unversioned installer filename, users on `1.3.6–1.3.8` should download and run `AS_Auto_Switcher_1.3.9.msi` once to upgrade smoothly; all future updates (`1.3.9` and newer) will check and apply automatically.

---

## [Version 1.3.8] - 2026-11-14

### Auto-Update Resilience & Release Reliability
- **Smart Retry & Faster Update Recovery:** Checks for new releases hourly and automatically retries temporary network interruptions, newly published releases, or busy rate-limit windows using progressive backoff delays instead of waiting hours to recover.
- **Slow-Connection & Large Download Protection:** Separates connection checks from large installer and portable binary download budgets, automatically cancelling stalled transfers cleanly so slow or unstable networks do not interrupt downloads unnecessarily.
- **Preserved Ready Updates:** Keeps an already downloaded and verified Windows installer ready to apply even if a subsequent update check or download fails.
- **Compact Rotating Update Logs:** Records concise, size-limited update diagnostic logs with automatic rotation and no personal or account credentials, while ensuring update log files never lock upgrades.
- **Consistent Release Packaging:** Ships version-labeled Windows installer and portable packages alongside standard update packages with structured release notes.

---

## [Version 1.3.7] - 2026-11-14

### 📄 Release Alignment & Documentation
- **Commercial License & Brand Alignment:** Updated commercial licensing terms and product branding across release documentation and Windows packaging metadata.
- **Expanded Multi-IDE Documentation:** Aligned guides across English and Vietnamese READMEs to reflect supported AI tools and IDEs (`Antigravity`, `ChatGPT app`, `Claude Code`, and compatible workflows).
- **Release Synchronization:** Synchronized version metadata across the desktop application, Windows installer metadata, and checksum verification output.

---

## [Version 1.3.6] - 2026-11-14

### 🔄 Built-In Auto-Update & Topbar Integration
- **Automatic Release Checking:** Added background update discovery against the official GitHub Releases channel with SHA-256 verification before installing.
- **One-Click Topbar Upgrade:** Displays an **Update** action directly in the application title bar when a newer release is verified and ready to apply, while preventing upgrades while an account switch is in progress.

### 🎨 Brand Refresh & Antigravity Quota Grouping
- **CA Monogram Identity:** Refreshed the application logo across the desktop icon, title bar, system tray, and Windows installer.
- **Unified Model Quota Grouping:** Consolidated Antigravity model pool display groups (`Hydrogen` and `Orchestrator`) for clearer remaining-quota visibility.

---

## [Version 1.3.5] - 2026-11-10

### 📦 Windows MSI Installer & System Tray Lifecycle
- **Official Windows Installer (MSI):** Switched to a standard 3-part versioned Windows Installer integrated cleanly with Windows Installed Apps / Programs & Features, supporting safe, non-destructive uninstalls that preserve outside user directories.
- **Minimize to System Tray & Restore:** Closing the main window now minimizes the app into the Windows System Tray instead of terminating active background work, with instant single-click / menu restore.
- **Unified Local Data Storage:** Standardized per-user configuration and account storage locations cleanly across installed and portable runs.

### 🤖 Codex & ChatGPT Desktop Management
- **Independent Multi-Tab Switching & Auto-Failover:** Enabled full manual and autonomous account switching across both Antigravity and Codex tabs independently.
- **Seamless Session Continuation:** Preserves and resumes active Codex desktop conversation threads smoothly across account switches, including reset-time shortcut actions on account cards.
- **Clean Store & Account Safety:** Guarded fresh installations against accidentally capturing unintended startup accounts and strengthened token refresh reliability during switches.

### 📊 Antigravity Quota Accuracy & Failover Stability
- **Expanded Model Quota & Reset Tracking:** Added support for current Gemini models and weekly reset timestamps, with clear indicators when an account is locked.
- **Immediate Post-Switch Sync & Recycle Resilience:** Automatically refreshes quota metrics immediately after manual or automatic switching and stabilizes failover recovery so valid backup accounts are not skipped.

---

## [Version 1.0.3.5] - 2026-11-02

### 🛡️ Codex Account Privacy & Masking Parity
- **Instant Privacy Masking:** Account masking now updates Codex email labels smoothly in place without redraw flicker or layout jumps.
- **Hover Email Preview & Unified Toggle:** Hovering a masked email still reveals the full address when needed, while the topbar privacy toggle synchronizes Antigravity and Codex tabs together.
- **Confirmation Dialog Protection:** Delete confirmation prompts hide email addresses when account masking is active and preserve masking during tab refreshes.

---

## [Version 1.0.3.4] - 2026-11-01

### 🎨 Codex Grid Layout, Live Quotas & Stability
- **Symmetric 3-Column Account Grid:** Upgraded the Codex tab layout to match the clean 3-column card grid and provider badges of the Antigravity tab.
- **Real-Time Codex Quota Tracking:** Added live Codex quota retrieval, safe handling of empty usage fields, and consistent 3-second footer notifications after refreshes.
- **Reliable Startup & Session Liveness:** Eliminated startup freezes when loading Codex accounts alongside the UI and ensured session reactivation checks stay anchored to local system clock time to avoid reopening closed chats.

---

## [Version 1.0.3.3] - 2026-10-31

### 🤖 Multi-AI Engine Architecture & Codex Integration
- **Engine & Storage Separation:** Organized Antigravity and Codex account stores separately with automatic non-destructive migration for existing accounts, plus single-instance protection and diagnostic `--version` output.
- **Codex Account Onboarding & Desktop Switching:** Added OAuth sign-in support, bilingual Add Account modal, safe credential token refresh, and asynchronous one-click switching for ChatGPT / Codex Desktop.
- **Dynamic Quota Matrix & Status Badges:** Dynamically adjusts quota display cells for active AI models with color-coded `Active`, `Depleted`, and `N/A` badges.
- **Resilient Thread Reactivation:** Reactivates recent IDE chat threads within a 5-minute active window while filtering out closed conversations during failover.

---

## [Version 1.0.3.2] - 2026-10-30

### 🪟 Tray Exit Fix, Instant Startup Sync & Smarter Failover
- **Clean System Tray Exit:** Removed the duplicate exit entry from the System Tray menu so only one localized "Exit" / "Thoát" item appears, ensuring background monitoring pauses and settings save cleanly on quit.
- **Instant Quota Sync at Launch:** Polls fresh account quotas immediately at startup instead of waiting for the first background interval, rotating automatically if the active account is already exhausted.
- **Anti-Thrashing AutoSwitch Guard:** Enforces a strict > 2% weekly quota floor (requiring healthy 5-hour and Weekly limits together) and prioritizes optimal backup accounts to stop rapid back-and-forth switching loops.

---

## [Version 1.0.3.1] - 2026-10-29

### ✨ Multi-Platform Sidebar & Shared Global Controls
- **Multi-Platform Sidebar Navigation:** Added a compact sidebar to switch seamlessly between **Antigravity** and **Codex** tabs inside a clean resizable workspace.
- **Global Titlebar Preferences:** Moved Theme selection and Account Masking into the top titlebar so preferences apply consistently across all tabs.
- **Longer Active Chat Preservation & Bilingual Modals:** Extended active thread preservation up to a 2-hour window during failovers and standardized bilingual candidate status tags (`[OAuth Ready]`, `[Added]`, `[Needs OAuth]`).

---

## [Version 1.0.3.0] - 2026-10-24

### 🏷️ Automatic Subscription Tier Badges
- **Live Plan Badges (`PRO`, `ULTRA`, `FREE`, `BIZ`, `--`):** Replaced the static header label with color-coded account tier badges across both active and inactive accounts without UI flicker.
- **Updated Plan Compatibility:** Fixed compatibility issues when reading nested subscription plan details from newer IDE updates.

---

## [Version 1.0.2.0] - 2026-10-23

### 🌐 Multilingual Documentation & Version Consistency
- **Vietnamese & English Guides:** Added dedicated `README_VN.md` and `README_EN.md` documentation with cross-language navigation links.
- **Automated Version Synchronization:** Unified version alignment across documentation headers and Windows application metadata.

---

## [Version 1.0.1.0] - 2026-10-21

### ⚡ Startup & Memory Optimizations
- **Faster Startup & Lower RAM Usage:** Reduced cold launch time below 500ms and cut idle background memory usage by over 40%.
- **Reliable IDE Detection & Active Protection:** Improved active IDE detection on Windows and added safeguards to prevent accidentally deleting or overwriting the currently running account.

---

## [Version 1.0.0.0] - 2026-10-18

### 🚀 Initial Release
- **Standalone Zero-Console Windows App:** Single-file desktop utility that launches cleanly without opening background terminal windows.
- **Visual Account Card Dashboard:** Displays account states (`Active`, `Switch`, `Needs OAuth`) with dual 5-hour and Weekly color-coded quota progress bars.
- **Autonomous AutoSwitch Mode:** Detects exhausted quotas automatically and rotates smoothly to the best healthy backup account.
- **Everyday Workspace Utilities:** Includes Dark, Light, and Warm themes, Always-on-Top window pinning, and System Tray minimization.
