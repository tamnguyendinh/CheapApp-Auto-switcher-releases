# AS Auto Switcher - **Version 1.5.6**

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

## [Version 1.5.6] - 2026-11-24
- **Instant switch on Terms of Service warnings & long quota limits:** AutoSwitch immediately moves to a healthy backup account on Terms of Service warnings or long-term `429` quota exhaustion, keeps 3 automatic retries for brief `429` spikes, and avoids switching back to flagged accounts.
- **Bold red `WARNING` notice on flagged cards:** Accounts with a Terms of Service warning show a bold red `WARNING` line below the quota table while keeping all action buttons usable, with card height adjusting smoothly.
- **Clearer sign-in status:** Accounts with `401` sign-in errors automatically switch to `[Needs OAuth]`, and the warning line stays hidden when a card is turned off or requires sign-in again.
- **Compact 2-row Antigravity cards:** All current Gemini models are grouped into one `Gemini` row so cards stay compact with 2 rows (`Gemini` and `Claude`), while still opening a dedicated row automatically for any new models that appear in the future.
- **Release packages:** Windows, Linux (x64 / ARM64), macOS (Apple Silicon / Intel), installation script, and checksums. Note: direct desktop integration on macOS is still awaiting verification on real Mac hardware.

## [Version 1.5.5] - 2026-11-23
- **Clearer release notes:** The changelog and README release history (English and Vietnamese) are rewritten in plain language focused on what you see in the app.
- **No feature changes** in this version.
- **Release packages:** Windows, Linux (x64 / ARM64), macOS (Apple Silicon / Intel), installation script, and checksums. Note: direct desktop integration on macOS is still awaiting verification on real Mac hardware.

## [Version 1.5.4] - 2026-11-23
- **Accurate "LOCKED" labels on Antigravity cards:** All quota rows (Gemini, Claude, Argon, Carbon) now follow the same lock rules, with identical display at startup and after refresh.
- **Fixed false locks:** PRO accounts with 0% Claude weekly quota no longer show a false "LOCKED" in the 5-hour column; Gemini 4 Carbon on PRO without access and Argon/Carbon on FREE correctly show "-- | LOCKED"; outdated data shows "-- | --" instead of a false lock.
- **Release packages:** Windows, Linux (x64 / ARM64), macOS (Apple Silicon / Intel), installation script, and checksums. Note: direct desktop integration on macOS is still awaiting verification on real Mac hardware.

## [Version 1.5.3] - 2026-11-22
- **Smarter auto-continue:** After an Antigravity account switch, only conversations that were running or stopped by quota in the last 5 minutes are resumed; finished or cancelled ones no longer receive "Continue...". Multi-step tasks resume in the right order.
- **Antigravity and Codex work independently:** Auto-continue for each tool runs separately; Codex behavior is unchanged.
- **Release packages:** Windows, Linux, macOS, installation script, and checksums.

## [Version 1.5.2] - 2026-11-22
- **Complete releases for all systems:** Every release ships Windows, Linux (x64 / ARM64), and macOS (Apple Silicon / Intel) packages together, verified with checksums.
- **More reliable installer:** The Linux/macOS installation script verifies the package before downloading, preventing failed downloads.
- **Better stability** of updates across Windows, Linux, and macOS.

## [Version 1.5.1] - 2026-11-22
- **Instant switch when personal quota runs out**, without wasting time on retries.
- **Each conversation keeps its own model** during retries and auto-continue instead of being forced onto the default model.
- **Checks every active conversation** so a depleted model in use is never hidden, and prefers backups that support the needed model.

## [Version 1.5.0] - 2026-11-22
- **More accurate quota & AutoSwitch** for Antigravity and Codex, with clearer separation of 5-hour/weekly limits and FREE/paid accounts. AutoSwitch waits instead of stopping when backups are temporarily unavailable.
- **Codex improvements:** Faster switching when sign-in is required, skips accounts with errors, stops safely when no backup is left.
- **macOS and Linux support (preview)** with a one-line installer that needs no administrator rights, and safer update installation.

## [Version 1.4.11] - 2026-11-21
- **Support for Antigravity 2.34.0+** while staying compatible with older versions.
- **Recognizes new models** such as Gemini 4 Neon and Gemini 3.8 Flash.
- **Recovers the correct active model** when Antigravity's saved settings are out of date.

## [Version 1.4.10] - 2026-11-20
- **Cleaner quote strip:** Removed the top border line and made the strip slightly slimmer, on all themes and tabs.

## [Version 1.4.9] - 2026-11-20
- **More accurate 5-hour + weekly quota** for Claude, and models stay tracked after an in-session switch.
- **Standby wait mode:** AutoSwitch stays on and shows a bilingual footer notice when backups exist but cannot be used yet. Layout fixes for footer notices and language switching.

## [Version 1.4.8] - 2026-11-19
- **Smarter backup selection:** Only backups that support your current model are chosen, preferring the same or a higher plan (ULTRA > PRO > FREE).
- **Better error recognition** for quota, payment, and permission errors, without unnecessary switching on request errors. FREE accounts no longer stall AutoSwitch, and all switching situations are covered.

## [Version 1.4.7] - 2026-11-19
- **Gemini 4 Neon joins the shared Gemini quota row**, keeping account cards simple; Gemini 4 Carbon keeps its own row.

## [Version 1.4.6] - 2026-11-18
- **Real quota for FREE accounts:** Shows actual usage matching Antigravity settings instead of a fixed 100%.

## [Version 1.4.5] - 2026-11-18
- **One quote at a time:** The quote strip shows a single quote at a time and stays smooth when resizing, switching language/theme, or using the tray.

## [Version 1.4.4] - 2026-11-18
- **Bilingual quote strip:** 45 built-in English/Vietnamese quotes scroll above the footer with theme-matched colors, pausing while in the tray.

## [Version 1.4.3] - 2026-11-18
- **Live Codex status** in the Codex tab footer, and the app version shown on both tabs.

## [Version 1.4.2] - 2026-11-18
- **Weekly quota for FREE accounts** with the 7-day reset time for Gemini and Claude.
- **Cleaner "Need OAuth" badge** in the top-right corner of the card.

## [Version 1.4.1] - 2026-11-18
- **Gemini 4 Carbon quota on ULTRA accounts**, clean "--" for unavailable models on PRO/FREE, and AutoSwitch recognizes Carbon.

## [Version 1.4.0] - 2026-11-16
- **Codex chat recovery:** Quota-limited chats are picked up for continuation when switching manually, and recent activity is recognized more reliably.
- **Note:** Live Desktop switching and auto-continue are still awaiting verification in real sessions.

## [Version 1.3.9] - 2026-11-15
- **Single versioned Windows installer** with automatic updates that keep your accounts and settings.
- **One-time manual upgrade:** Users on 1.3.6–1.3.8 need to run the 1.3.9 installer once; later updates are automatic.

## [Version 1.3.8] - 2026-11-14
- **More reliable auto-update:** Hourly checks, automatic retry after network problems, protection for slow connections, and compact logs without personal information.

## [Version 1.3.7] - 2026-11-14
- **License, branding & documentation update** covering supported AI tools and IDEs in English and Vietnamese.

## [Version 1.3.6] - 2026-11-14
- **Built-in auto-update** with a one-click Update button in the title bar.
- **New CA logo** and clearer model quota groups.

## [Version 1.3.5] - 2026-11-10
- **Official Windows installer & system tray** with clean uninstall and quick restore.
- **Codex / ChatGPT Desktop account management** with independent switching and seamless session continuation.
- **Better Antigravity quota tracking** with weekly reset times and more stable failover.
