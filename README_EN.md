# AS Auto Switcher - **Version 1.4.1**

[Tiếng Việt](README_VN.md) | [English](README_EN.md)

If you have a personal account, a work account, and a freelance/side-project account, and you waste valuable time signing in and out whenever switching accounts—this tool is built for you.

### **When accounts switch automatically, all active work continues smoothly without interruption or manual intervention.**

### **Safe and compliant with account switching mechanisms permitted by the IDEs. No modification to IDE source code (Antigravity, ChatGPT app, Claude Code, ...), no API wrapping.**

A native Windows application written in **Go** that lets you manage multiple accounts, monitor quotas in real time, and switch active sessions across supported IDEs (**Antigravity, ChatGPT app, Claude Code, ...**) smoothly and securely. Built with a modern, intuitive **Fyne** desktop GUI, it provides a seamless Zero-Console experience installed cleanly via an official Windows Installer package with automatic background updates.

The application features a built-in **Autonomous Multi-Account Switcher & Failover Daemon** powered by an advanced 3-stage pipeline (v1.0.3.2) with strict anti-thrashing safety guards. You can easily choose between manual switching (via the **Switch** button on the GUI) and fully autonomous switching (AutoSwitch). When AutoSwitch is enabled, the daemon monitors quota availability, detects exhaustion, performs in-memory backoff retries, filters out marginal candidates, and seamlessly fails over to the most optimal backup account using the **Burn-down Sorter** algorithm—keeping your coding flow uninterrupted.

## Key Highlights & User Experience

- **Clean System Tray Menu & Graceful Exit (v1.0.3.2):**
  - Streamlined the System Tray context menu to remove duplicate quit entries, keeping a single exit item in your active language ("Thoát" in Vietnamese / "Exit" in English).
  - Ensures background monitoring stops safely and preferences are flushed to disk cleanly whenever exiting from the main window or System Tray.
- **Instant Quota Synchronization at Startup (t = 0):**
  - Eliminates the 60-second cold-start delay by pulling fresh, live quota metrics directly from each supported IDE's provider (**Antigravity, ChatGPT app, Claude Code, ...**) in the first second of launching the application.
  - Operates unconditionally whether AutoSwitch is enabled or disabled, immediately populating accurate quota bars and status indicators across all account cards.
  - Instantly triggers autonomous account failover at launch if the active account is already depleted, ensuring seamless, zero-delay recovery without requiring manual user intervention.
- **Intelligent 3-Stage AutoSwitch Algorithm (v1.0.3.2):**
  - **Stage 1 (Detection):** Continuous real-time detection of 429 quota exhaustion errors and proactive background telemetry evaluations.
  - **Stage 2 (Candidate Screening & Anti-Thrashing Guard):** Enforces a strict **> 2%** weekly quota threshold (strictly rejecting all accounts <= 2%) and mandatory "AND" health condition (**5h > 2% AND Weekly > 2%**), completely eliminating rapid oscillating account switching loops (**Thrashing / Flapping Loop**).
  - **Stage 3 (Burn-down Sorter & Safe Preflight):** Rotates to the optimal backup account prioritizing the lowest healthy weekly quota (`w1 < w2`), with preflight quota validation ensuring the account is active and fresh before switching.
- **Intuitive Account Grid:** View your accounts at a glance with clear, distinctive status badges:
  - `[Active]`: Currently active account inside the corresponding IDE (**Antigravity, ChatGPT app, Claude Code, ...**).
  - `[Switch]`: Switch to this account instantly with a single click.
  - `[Needs OAuth]`: Reminds you to log into the IDE to grant authorization.
- **Safe Delete Button:** Clean up inactive accounts easily. Includes a danger confirmation dialog to protect against accidentally deleting the active account.
- **Autonomous AutoSwitch Toggle:** Seamlessly toggle automated account failover when quota is exhausted, ensuring non-stop developer productivity.
- **Real-Time Status Bar:** Live updates of the system state (`IDLE`, `EVALUATING`, `SWITCHING`, `SWITCHED`...).
- **Comprehensive Quota Dashboard:** Visually track remaining quota percentages across supported IDEs and AI providers (**Antigravity, ChatGPT app, Claude Code, ...**) for both 5-hour and Weekly reset windows. Progress bars dynamically shift color based on availability (green: plentiful, yellow: moderate, red: near exhaustion).
- **Instant Quota & Account Refresh:** Refresh the entire list or individual accounts in a split second.
- **3 Modern Themes:** Switch between **Dark**, **Light**, and **Warm** themes to suit your viewing preference.
- **Always-on-Top Pinning:** Keep the switcher floating on top while working to keep an eye on quotas.
- **System Tray Minimization:** Minimize to the Windows Taskbar/System Tray when not in focus, with quick access via a clean context menu without duplicate exit buttons and fully graceful background shutdown.

## Installation & Getting Started

### 1. Official Windows Distribution (MSI Installer)

The application is distributed via official GitHub Releases as a versioned Windows Installer (`AS_Auto_Switcher_<version>.msi`, e.g., `AS_Auto_Switcher_1.3.9.msi`) with a Zero-Console desktop experience:
- Download `AS_Auto_Switcher_<version>.msi` from the official **Releases** page and verify SHA-256 against `checksums.txt`.
- Run the installer to install cleanly (preserving user settings on upgrades) and launch the GUI.
- Subsequent updates check and install automatically via GitHub Releases.

### 2. Quick Start Guide

1. **Save an Account:** Sign in to your account inside your target IDE (**Antigravity**, **ChatGPT app**, **Claude Code**, ...), open the Switcher, and click **Account List** to capture the active session. Repeat for any additional accounts.
2. **Switch Manually:** Click the **Switch** button on any saved account card to switch your active working account.
3. **Switch Automatically:** Turn on the **AutoSwitch** toggle. The application will monitor your quota and automatically rotate to the best available backup account when limits are reached—without manual input.

## Safety, Security & License

- **Local Account Privacy:** All account session data and OAuth tokens are stored securely on your local machine and never sent to third-party servers. Network checks are used strictly for IDE/account quota operations and official application updates via GitHub Releases.
- **Standard-Compliant:** The switching mechanism complies with the account switching conventions permitted by the supported IDEs (**Antigravity, ChatGPT app, Claude Code, ...**). It does not alter IDE source code or binaries and does not use API proxy wrappers.
- **Commercial License:** Copyright (c) 2026 Tam Nguyen / CheapApp Auto switcher. All Rights Reserved. Proprietary commercial software (not open-source or freeware). See [`LICENSE`](LICENSE).

## 📜 Release History

## [Version 1.4.1] - 2026-11-18
- **Antigravity ULTRA Gemini 4 Carbon Quota:** Resolved weekly quota percentages and reset countdowns for active `Gemini 4 Carbon` extension models on `ULTRA` accounts while keeping `--` displayed for disabled extension entries on `PRO` and `FREE` accounts.
- **Autonomous Carbon Category Tracking:** Updated active-model classification so autonomous switching evaluates `Gemini 4 Carbon` against its dedicated `carbon` quota bucket.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.1.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.0] - 2026-11-16
- **Codex Quota-Limited Chats:** Updated manual-switch chat selection to include the active Desktop session's latest quota-limited chats without requiring prior quota hints, while preserving exclusions for completed, interrupted, waiting, and unrelated failed chats.
- **Recent Activity Tracking:** Aligned chat activity tracking with current Desktop timestamp fields to recognize recent work when saved activity is older.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.0.msi` and SHA-256 verification through the existing MSI update channel.
- **Verification Limitation:** Live Desktop switching, quota recovery, and automatic continuation remain pending real-session verification.

## [Version 1.3.9] - 2026-11-15
- **Versioned MSI-Only Releases:** Streamlined official releases to distribute a single version-labeled Windows Installer (`AS_Auto_Switcher_1.3.9.msi`) with `checksums.txt` verification and cleaner release assets.
- **Versioned Auto-Update Lookup:** Updated installed desktop auto-updates to match, SHA-256 verify, and install the versioned `AS_Auto_Switcher_<version>.msi` package automatically while preserving existing accounts and settings.
- **One-Time Manual Upgrade (`1.3.6–1.3.8`):** Users running `1.3.6–1.3.8` should install `AS_Auto_Switcher_1.3.9.msi` manually once to transition to versioned installer updates; updates from `1.3.9` onward apply automatically.

## [Version 1.3.8] - 2026-11-14
- **Smart Retry & Faster Recovery:** Checks for updates hourly and automatically retries after newly published releases, transient network interruptions, or rate-limit pauses using progressive backoff without waiting hours to recover.
- **Slow-Connection & Stall Protection:** Guards large installer and portable downloads with generous transfer timeouts and automatic stall detection while keeping an already verified update ready if a newer check fails.
- **Compact Rotating Update Logs:** Maintains size-limited, automatically rotating update logs without storing personal or account credentials, and ships version-labeled release packages alongside standard installers.

## [Version 1.3.7] - 2026-11-14
- **Commercial License & Brand Alignment:** Updated commercial licensing terms and product branding across release documentation and Windows packaging metadata.
- **Expanded Multi-IDE Documentation:** Aligned English and Vietnamese guides for supported AI tools and IDEs (`Antigravity`, `ChatGPT app`, `Claude Code`, and compatible workflows).
- **Release Synchronization:** Synchronized version metadata across the desktop application, Windows installer metadata, and checksum verification output.

## [Version 1.3.6] - 2026-11-14
- **Automatic Release Checking:** Added background update discovery against the official GitHub Releases channel with SHA-256 verification before applying updates.
- **One-Click Topbar Upgrade:** Displays an **Update** action directly on the top title bar when a newer release is verified and ready, while safely preventing upgrades while an account switch is active.
- **Brand Refresh & Quota Grouping:** Refreshed the CA brand monogram icon across the app, system tray, and Windows installer, and consolidated Antigravity model quota groups for clearer visibility.

## [Version 1.3.5] - 2026-11-10
- **Official Windows Installer & Tray Lifecycle:** Introduced the standard 3-part versioned Windows MSI installer with non-destructive uninstalls, minimize-to-tray behavior with quick restore, and unified local data storage.
- **Codex & ChatGPT Desktop Management:** Added independent multi-tab switching and auto-failover across Antigravity and Codex, smooth session continuation across switches, and stronger account safety guards.
- **Quota Accuracy & Failover Stability:** Expanded model quota and weekly reset tracking with immediate post-switch sync and more reliable failover recovery.
