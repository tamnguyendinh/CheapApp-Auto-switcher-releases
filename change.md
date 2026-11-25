# 📋 Changelog - AS Auto Switcher

All notable changes, new features, improvements, and bug fixes across releases of **AS Auto Switcher** are documented in this file.

---

## [Version 1.5.7] - 2026-11-25

### Smoother Native Windows Window, Faster First-Click Response & Unified Windows Installer Naming
- **Native Windows frameless window & instant first-click response:** Dragging, edge/corner resizing, Windows Snap, maximize/restore, and Windows 11 rounded corners/dark frame now use native Windows window handling, so controls respond immediately on the first click without flickering or misclicks.
- **Minimize directly to Taskbar (System Tray removed):** Minimizing now keeps the app cleanly on the Windows Taskbar, closing the window exits cleanly, and launching a second instance restores your existing window without un-maximizing it.
- **Smoother cards, tooltips & quote strip:** Hover tooltips no longer steal clicks or leave lingering overlays; account cards update smoothly in place with lighter rendering and background saving; and the quote strip automatically pauses while minimized, hidden, inactive, or resizing.
- **Unified Windows installer naming (`AS_Auto_Switcher_1.5.7-windows-amd64.msi`):** Standardized the Windows MSI package name to match the `-os-arch` convention of Linux and macOS packages, along with stricter sequential versioning and updater verification.
- **One-time manual upgrade (Windows `1.5.6` and earlier):** Users currently on Windows `1.5.6` or older should download and run `AS_Auto_Switcher_1.5.7-windows-amd64.msi` once (all saved accounts and settings are preserved). From `1.5.7` onward, automatic in-app updates work seamlessly with the new installer filename.
- **Release packages:** Windows installer (`AS_Auto_Switcher_1.5.7-windows-amd64.msi`), Linux (x64 and ARM64), macOS (Apple Silicon and Intel), installation script, and checksum file. **Note:** Direct desktop integration on macOS is still awaiting verification on real Mac hardware.

---

## [Version 1.5.6] - 2026-11-24

### Faster Recovery from Account Warnings & Cleaner 2-Row Antigravity Cards
- **Instant switch on Terms of Service warnings & long quota limits:** AutoSwitch immediately detects Terms of Service warnings and long-term `429` quota exhaustion and switches to a healthy backup account right away, while keeping up to 3 automatic retries for brief `429` traffic spikes and preventing AutoSwitch from jumping back to flagged accounts.
- **Bold red `WARNING` notice on flagged cards:** Accounts flagged with a Terms of Service warning display a bold red `WARNING` line right below the quota table while keeping all action buttons intact, with card height smoothly expanding and collapsing as needed.
- **Clearer sign-in & card status handling:** Accounts returning a `401` sign-in error automatically switch to `[Needs OAuth]` so they are easy to sign back into, and the warning line is hidden whenever a card is turned off or needs sign-in again.
- **Simpler 2-row Antigravity cards:** All current Gemini models are combined into a single `Gemini` quota row so account cards stay compact with just two rows (`Gemini` and `Claude`), while automatically opening a dedicated row for any new models with separate quotas in the future.
- **Release packages:** Windows installer, Linux (x64 and ARM64), macOS (Apple Silicon and Intel), installation script, and checksum file. **Note:** Direct desktop integration on macOS is still awaiting verification on real Mac hardware.

---

## [Version 1.5.5] - 2026-11-23

### Clearer Release Notes
- **Easier-to-read release history:** The changelog and the release history in the README (English and Vietnamese) have been rewritten in plain language, focusing on what you see and use in the app.
- **No feature changes:** This version does not change how the app works; it only improves the release notes.
- **Release packages:** Windows installer, Linux (x64 and ARM64), macOS (Apple Silicon and Intel), installation script, and checksum file. **Note:** Direct desktop integration on macOS is still awaiting verification on real Mac hardware.

---

## [Version 1.5.4] - 2026-11-23

### Accurate "LOCKED" Labels on Antigravity Account Cards
- **Consistent lock display:** All quota rows (Gemini, Claude, Argon, Carbon) now follow the same rules to decide whether a model is locked, and the display is identical at startup and after every refresh.
- **No more false lock on Claude (PRO):** PRO accounts whose Claude weekly quota reaches 0% no longer show a false "LOCKED" in the 5-hour column.
- **Correct lock for unavailable models:** Gemini 4 Carbon on PRO accounts without access, and Argon/Carbon on FREE accounts, now show "-- | LOCKED" as expected.
- **Outdated data is not treated as locked:** When quota information is outdated or incomplete, the card shows "-- | --" instead of a false lock.
- **Unchanged:** Cards that are turned off, not signed in, or denied access still show "N/A | N/A".
- **Release packages:** Windows installer, Linux (x64 and ARM64), macOS (Apple Silicon and Intel), installation script, and checksum file. **Note:** Direct desktop integration on macOS is still awaiting verification on real Mac hardware.

---

## [Version 1.5.3] - 2026-11-22

### Smarter Auto-Continue After Switching Accounts
- **Only resumes work that was really interrupted:** After an Antigravity account switch, the app only resumes conversations that were running or stopped by a quota limit within the last 5 minutes. Finished or cancelled conversations no longer receive an unwanted "Continue..." message.
- **Correct order for multi-step tasks:** Conversations made of sub-tasks are resumed in the right order (sub-tasks first, then the main conversation).
- **Antigravity and Codex work independently:** Auto-continue for Antigravity and Codex now run fully separately, so changes to one never affect the other. Codex behavior stays exactly the same.
- **Release packages:** Windows, Linux (x64 and ARM64), macOS (Apple Silicon and Intel), installation script, and checksum file. **Note:** Direct desktop integration on macOS is still awaiting verification on real Mac hardware.

---

## [Version 1.5.2] - 2026-11-22

### Complete Releases for Windows, Linux, and macOS
- **Full package set every release:** Each release now ships installers for Windows, Linux (x64 and ARM64), and macOS (Apple Silicon and Intel) together, all verified with checksums.
- **More reliable Linux/macOS installer:** The installation script checks that a package exists for your system and verifies it before downloading, preventing failed downloads.
- **Better stability across systems:** Improved updater and overall reliability on Windows, Linux, and macOS.
- **Note:** Direct desktop integration on macOS is still awaiting verification on real Mac hardware.

---

## [Version 1.5.1] - 2026-11-22

### Each Conversation Keeps Its Own Model & Faster Switching
- **Instant switch when personal quota runs out:** When Google reports that your personal quota is exhausted, the app switches accounts right away instead of wasting time on retries.
- **Each conversation keeps its model:** During retries and auto-continue, every conversation keeps the exact model it was using instead of being forced onto the default model. Conversations whose model is not available are skipped.
- **Checks every active conversation:** AutoSwitch now looks at the models of all running conversations, so a depleted model in use is no longer hidden by a healthy default model, and it prefers backup accounts that support the model you need.
- **Release packages:** Windows installer and installation script, with checksums. Windows auto-update remains fully compatible.

---

## [Version 1.5.0] - 2026-11-22

### More Accurate Quota & AutoSwitch, Plus First Steps to macOS and Linux
- **More accurate quota reading:** Better separation between 5-hour and weekly limits and between FREE and paid accounts, for both Antigravity and Codex.
- **AutoSwitch waits instead of stopping:** If backup accounts are only temporarily unavailable, AutoSwitch stays on and waits rather than shutting off.
- **Codex improvements:** Switches faster when an account requires sign-in again, skips accounts with errors, stops safely when no backup is left, and clears tasks stuck for more than 24 hours.
- **macOS and Linux support (preview):** The app, its updater, and installation packages now work on macOS and Linux, including a one-line installer that does not need administrator rights. Updates are installed more safely.
- **Release packages:** Windows installer and installation script, with checksums. Windows auto-update remains fully compatible. **Note:** Direct desktop integration on macOS is still awaiting verification on real Mac hardware.

---

## [Version 1.4.11] - 2026-11-21

### Support for Antigravity 2.34.0 and Newer
- **Works with Antigravity 2.34.0+:** The app reliably detects and connects to newer Antigravity versions while staying compatible with older ones.
- **Recognizes new models:** New models such as Gemini 4 Neon and Gemini 3.8 Flash are now identified correctly.
- **Recovers the correct active model:** When Antigravity's saved settings are out of date, the app still finds the model you are really using for AutoSwitch, retries, and auto-continue.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.10] - 2026-11-20

### Cleaner Quote Strip
- **No top border line:** The quote strip above the footer now blends smoothly into the window without a line on top, and is slightly slimmer. The divider above the status bar is kept, on all themes and both tabs.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.9] - 2026-11-20

### More Accurate Dual Quota, Standby Mode & Layout Fixes
- **More accurate 5-hour + weekly quota:** Claude quota is read correctly regardless of data order, and weekly values no longer hide an exhausted 5-hour limit.
- **Models stay tracked after switching:** Models that temporarily disappear after an in-session switch are still checked by AutoSwitch.
- **Standby wait mode:** When backup accounts exist but cannot be used yet, AutoSwitch stays on and shows a bilingual notice in the footer instead of stopping completely.
- **Layout fixes:** Footer notices are no longer cut off on first display, and switching between English and Vietnamese rearranges toolbars and account cards without overlapping.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.8] - 2026-11-19

### Smarter Backup Account Selection
- **Only compatible backups:** AutoSwitch only picks backup accounts that can use the model you are working with. FREE accounts are excluded from premium-only models, and depleted accounts are skipped.
- **Prefers the same or higher plan:** AutoSwitch prefers backup accounts on the same or a higher plan (ULTRA > PRO > FREE), falling back to other accounts when needed.
- **Better error recognition:** Quota, payment, and permission errors from Google are recognized more reliably, while errors caused by the request itself no longer trigger unnecessary switching.
- **FREE accounts no longer stall AutoSwitch** when some weekly models are disabled.
- **Covers all switching situations:** quota errors while working, low remaining quota (2% or less), active model not supported by the current account, permanent sign-in failure, trying the next backup if one fails, and doing nothing when AutoSwitch is off.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.7] - 2026-11-19

### Gemini 4 Neon Joins the Shared Gemini Quota
- **Simpler account cards:** Gemini 4 Neon now shares the main Gemini quota row instead of getting a separate extra row. Old cached data is cleaned up automatically, while models with their own quota (such as Gemini 4 Carbon) keep their dedicated row.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.6] - 2026-11-18

### Real Quota for Antigravity FREE Accounts
- **Accurate usage display:** FREE / personal accounts now show their real quota usage, matching Antigravity settings, instead of a fixed 100%.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.5] - 2026-11-18

### One Quote at a Time
- **Sequential quotes:** The quote strip now shows only one quote at a time; the next quote appears only after the current one has fully scrolled away.
- **Smooth behavior:** Scrolling stays smooth when resizing the window, switching language or theme, and when minimizing to or restoring from the system tray.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.4] - 2026-11-18

### Bilingual Quote Strip
- **Inspirational quote strip:** A new strip above the footer scrolls 45 built-in quotes in English and Vietnamese, with colors that adapt to the Dark, Warm, and Light themes and no immediate repeats.
- **Language and tray sync:** Quotes switch language instantly, pause while the app is in the system tray, and resume when restored.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.3] - 2026-11-18

### Codex Status & Version in the Footer
- **Live Codex status:** The Codex tab footer now shows whether the ChatGPT Desktop app is running ("Codex: Active" / "Codex: Inactive").
- **Version display:** Both tabs show the app version in the bottom-right corner when no notification is shown.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.2] - 2026-11-18

### Weekly Quota for FREE Accounts & Cleaner OAuth Badge
- **Weekly quota on FREE accounts:** FREE accounts now show weekly quota and the 7-day reset time for Gemini and Claude. The 5-hour and Gemini 4 Carbon columns show "--" and Gemini 4 Argon shows "LOCKED". Old cached errors are fixed automatically at startup.
- **Cleaner "Need OAuth" badge:** The sign-in reminder now appears in the top-right corner of the account card, and the warning banner at the bottom of the card was removed.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.1] - 2026-11-18

### Gemini 4 Carbon Quota for ULTRA Accounts
- **Carbon quota on ULTRA:** ULTRA accounts now show weekly quota and reset time for Gemini 4 Carbon.
- **Clean display on PRO / FREE:** Models not available on PRO and FREE accounts keep showing "--".
- **AutoSwitch recognizes Carbon:** AutoSwitch now evaluates Gemini 4 Carbon quota correctly.
- **Windows installer** available through the normal update channel.

---

## [Version 1.4.0] - 2026-11-16

### Codex Chat Selection & Activity Tracking
- **Recovering quota-limited chats:** When switching accounts manually, the latest chats stopped by a quota limit are now picked up for continuation, while finished, interrupted, waiting, and unrelated failed chats are left alone.
- **Recent activity tracking:** Recent work is recognized more reliably for continuation.
- **Windows installer** available through the normal update channel.
- **Note:** Live account switching, quota recovery, and automatic chat continuation on the Desktop app are still awaiting verification in real sessions.

---

## [Version 1.3.9] - 2026-11-15

### Versioned Windows Installer & Auto-Update
- **Single versioned installer:** Each release now ships one Windows installer labeled with its version number, plus a checksum file and release notes.
- **Automatic updates:** Installed copies find, verify, and install new versions automatically while keeping your accounts and settings.
- **One-time manual upgrade (1.3.6–1.3.8):** Users on versions 1.3.6 to 1.3.8 need to download and run the 1.3.9 installer once. From 1.3.9 onward, updates are fully automatic.

---

## [Version 1.3.8] - 2026-11-14

### More Reliable Auto-Update
- **Smart retry:** Checks for new versions every hour and retries automatically after temporary network problems instead of waiting hours.
- **Slow-connection protection:** Large downloads get enough time to finish, stalled downloads are cancelled cleanly, and an already downloaded update stays ready even if a later check fails.
- **Compact update logs:** Small, self-rotating update logs that never contain personal or account information.
- **Consistent packaging:** Version-labeled Windows installer and portable packages with structured release notes.

---

## [Version 1.3.7] - 2026-11-14

### 📄 License & Documentation
- **Commercial license & branding:** Updated commercial license terms and product branding across documentation and the Windows installer.
- **Multi-IDE documentation:** English and Vietnamese guides now cover the supported AI tools and IDEs (Antigravity, ChatGPT app, Claude Code, and compatible workflows).
- **Consistent version numbers** across the app, the installer, and checksum files.

---

## [Version 1.3.6] - 2026-11-14

### 🔄 Built-In Auto-Update
- **Automatic update checks:** The app checks the official release channel for new versions and verifies them before installing.
- **One-click Update button:** An Update button appears in the title bar when a new version is ready. Updating is blocked while an account switch is in progress.

### 🎨 New Logo & Model Grouping
- **New CA logo** on the app, title bar, system tray, and Windows installer.
- **Clearer model quota groups** on Antigravity account cards.

---

## [Version 1.3.5] - 2026-11-10

### 📦 Windows Installer & System Tray
- **Official Windows installer:** Installs and uninstalls cleanly through Windows Settings without touching your other files.
- **Minimize to tray:** Closing the main window keeps the app running in the system tray, with quick restore.
- **Unified local storage:** Settings and accounts are stored in one standard per-user location.

### 🤖 Codex & ChatGPT Desktop
- **Independent switching on both tabs:** Manual and automatic switching work separately for Antigravity and Codex.
- **Seamless session continuation:** Active Codex conversations continue smoothly after switching accounts.
- **Account safety:** New installations no longer accidentally save unintended accounts, and sign-in refresh is more reliable during switches.

### 📊 Antigravity Quota & Failover
- **More models and reset times:** Support for current Gemini models and weekly reset times, with clear locked indicators.
- **Instant refresh after switching** and more stable failover so valid backup accounts are not skipped.

---

## [Version 1.0.3.5] - 2026-11-02

### 🛡️ Codex Account Privacy
- **Instant masking:** Hiding email addresses on the Codex tab now updates smoothly without flicker.
- **Hover preview & shared toggle:** Hovering a hidden email shows it in full, and one privacy toggle controls both tabs.
- **Protected confirmations:** Delete confirmations also hide email addresses when masking is on.

---

## [Version 1.0.3.4] - 2026-11-01

### 🎨 Codex Grid, Live Quota & Stability
- **3-column account grid** on the Codex tab, matching the Antigravity tab.
- **Live Codex quota** with clear notifications after refreshing.
- **Reliable startup:** No more freezes when loading Codex accounts, and closed chats are no longer reopened by mistake.

---

## [Version 1.0.3.3] - 2026-10-31

### 🤖 Codex Support
- **Separate account lists** for Antigravity and Codex, with automatic migration of existing accounts and protection against running the app twice.
- **Codex account sign-in & switching:** Sign in, add accounts, and switch ChatGPT / Codex Desktop accounts with one click.
- **Dynamic quota display** with color-coded Active, Depleted, and N/A badges.
- **Reliable chat reactivation:** Recent chats are reactivated after failover while closed conversations are left alone.

---

## [Version 1.0.3.2] - 2026-10-30

### 🪟 Tray Exit, Instant Startup Sync & Smarter Failover
- **Clean tray exit:** Only one "Exit" item in the tray menu, and settings are saved properly on quit.
- **Instant quota at startup:** Quota is loaded right when the app opens, switching immediately if the active account is already exhausted.
- **No back-and-forth switching:** Backup accounts must have more than 2% left on both 5-hour and weekly limits, preventing rapid switching loops.

---

## [Version 1.0.3.1] - 2026-10-29

### ✨ Sidebar & Shared Settings
- **Sidebar navigation** between the Antigravity and Codex tabs.
- **Shared title bar settings:** Theme and account masking apply to all tabs.
- **Longer chat preservation** during failover and consistent bilingual status tags.

---

## [Version 1.0.3.0] - 2026-10-24

### 🏷️ Subscription Plan Badges
- **Live plan badges (PRO, ULTRA, FREE, BIZ):** Color-coded plan badges on every account card.
- **Compatibility fix** for reading plan details from newer IDE versions.

---

## [Version 1.0.2.0] - 2026-10-23

### 🌐 Multilingual Documentation
- **Vietnamese & English guides** with links between languages.
- **Consistent version numbers** across documentation and the app.

---

## [Version 1.0.1.0] - 2026-10-21

### ⚡ Faster & Lighter
- **Faster startup and lower memory:** Launches in under half a second and uses over 40% less memory when idle.
- **Safer account handling:** Better IDE detection and protection against deleting or overwriting the account currently in use.

---

## [Version 1.0.0.0] - 2026-10-18

### 🚀 Initial Release
- **Standalone Windows app** that runs without any console window.
- **Account card dashboard** showing account status with 5-hour and weekly quota bars.
- **AutoSwitch mode** that switches to the best healthy backup account when quota runs out.
- **Everyday utilities:** Dark, Light, and Warm themes, always-on-top mode, and system tray support.
