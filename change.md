# 📋 Changelog - AS Auto Switcher

All notable changes, new features, performance improvements, and bug fixes across releases of **AS Auto Switcher** are documented in this file.

---

## [Version 1.4.10] - 2026-11-20

### Borderless Quote Marquee Strip Above Footer
- **Top Separator Removal (`ui/quote_strip.go`):** Removed `QuoteMarqueeStrip.topSep` (`*widget.Separator`) and the intermediate `root` container wrapper, rendering `q.clip` directly via `widget.NewSimpleRenderer(q.clip)` with eager `q.clip.ExtendBaseWidget(q.clip)` initialization so the quote strip blends seamlessly at the top without a horizontal border line.
- **21px Stage & Preserved Footer Divider:** Reduced `QuoteStripHeight` from `22.0` to `21.0` (`marqueeStageLayout.MinSize` aligned to `QuoteStripHeight`) and dropped `q.topSep.Refresh()` in `SetTheme` while preserving the lower `bottomSection` status-bar divider intact across **Dark**, **Warm**, and **Light** themes and both **Antigravity** and **Codex** tabs (`TestQuoteMarquee_MinSizeAndResizeBehavior`).
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.10.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.9] - 2026-11-20

### Antigravity Dual-Cycle Quota Correctness, Option A Standby Wait & Reactive UI Relayout
- **Canonical `PoolClaude` Priority & Dual-Cycle Quota Integrity:** Enforced canonical `PoolClaude` (`3p-5h`/`claude:5h`/`claude-5h`, `3p-weekly`/`claude:weekly`/`claude-weekly`) precedence across `ResolveCanonicalBuckets`, `RetrieveUserQuotaWithToken`, `ParseQuotaSummaryWithBuckets`, and `normalizeLoadedQuotaEntry` regardless of payload order, guarded `ExtractExtensionBuckets` (`isExplicit5h`) so `-weekly` zero-values never mask `5h` exhaustion, evaluated `Disabled`/`WeeklyDisabled` before `-1` in `ClassifyQuotaState` without false-locking on non-canonical sub-models, and applied strict dual-cycle `AND` gating (`IsModelSupportedByAccount`).
- **Hot-Switch Model Catalog Resilience:** Added `ErrModelNotInCascadeConfig` (`automation_rpc.go`) and an in-memory `modelCatalog` fallback in `AutomationController.resolveModel` so models hidden after an in-session hot-switch still trigger proactive mismatch checks, while unknown cold-start models fail cleanly with `MODEL_RESOLVE_ER`.
- **Option A Standby Wait vs. Hard Safety Stop:** Separated `StatusWaitingCandidate` (`WAIT_CANDIDATE` / `ErrWaitingCandidates`) from `StatusNoCandidate` (`SAFETY_STOP`) when usable `ON`+token backups exist on standby (`MODEL_INCOMPATIBLE`, `QUOTA_COOLING_DOWN`, `PREFLIGHT_INELIGIBLE`, `QUOTA_UNRELIABLE`), keeping `AutoSwitch` enabled, resetting `RetryCoordinator`, logging edge-triggered timeline entries, deferring `StatusSwitching` until after preflight passes, and showing pure bilingual (`vi`/`en`) footer standby notices.
- **First-Show Footer & In-Place `SetLanguage` UI Relayout:** Added lock-free `refreshFooterLayout()`, `refreshAntigravityToolbarLayout()`, `CodexView.RefreshToolbarLayout()`, and `AccountCardWidget.refreshTopRowLayout()` so Option A footer banners render unclipped on first display and in-place `EN`/`VN` switches across Antigravity, Codex (with preserved account masking), and card headers reflow cleanly without overlap; also synchronized `ui/codex/add_modal_test.go` mocks for deterministic `-race` testing.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.9.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.8] - 2026-11-19

### Antigravity Tier-Affinity, Model Capability Match, Unified Google Error Catalog & 6-Scenario Auto-Switch
- **Model Capability Match & Anti-Inversion Filtering (Criterion 7):** Added `IsModelSupportedByAccount` and `CriterionModelIncompatible` (`7`) in `internal/engines/antigravity/automation/model_quota.go` and `sorter.go` to hard-filter incompatible or depleted (`-disabled`, exhausted, or `<= 2%`) backup accounts before Burn-down sorting. Restricted tiers (`carbon`, `argon`, `hydrogen`, `orchestrator`, Gemini `>= 4`, Claude `>= 5`) are blocked on `FREE` accounts without false-blocking `Claude 4.6` or `Gemini 2.5 Pro`, and `PRO` accounts are verified against `ExtensionBuckets` / `RawBuckets` for `Argon` and `Carbon` entitlement.
- **Tier-Affinity Auto-Switch Ordering:** Added `SortCandidatesBurnDownWithTier` and 3-level `resolveActiveAccountTier` resolution so AutoSwitch prioritizes eligible backup accounts of the same or higher subscription tier (`ULTRA` > `PRO` > `FREE`) with the lowest healthy weekly Burn-down quota, falling back cleanly to pure Burn-down when no matching-or-higher-tier candidate is available.
- **Unified Google Quota & Entitlement Error Catalog & Anti-Switch-Storm Protection:** Introduced `IsAccountQuotaOrTierBlocked` (`internal/engines/antigravity/connector/error_catalog.go`) and `IsRateLimitOrQuotaExhaustedWithTier(isFreeAccount bool)` (`automation_rpc.go`, wired into `RetryCoordinator` in `retry.go`), unifying quota, payment, and entitlement errors (`429`, `402`, `401`, `UNAUTHENTICATED`, `INVALID_GRANT`, `VALIDATION_REQUIRED`, `SUBSCRIPTION_REQUIRED`, 24 quota/entitlement phrases, and contextual `403`/`PERMISSION_DENIED`/`FORBIDDEN` for `FREE` and entitlement clues) while blocking switch storms on prompt/request errors (`INVALID_ARGUMENT`, `400 BAD REQUEST`, `400 BAD_REQUEST`, `SAFETY_VIOLATION`, `HARM_CATEGORY`, `PROMPT_BLOCKED`).
- **FREE Tier `-disabled` 60s Telemetry Fallback:** Updated `ResolveCanonicalBuckets` (`internal/engines/antigravity/telemetry/client.go`) so `FREE` accounts whose Claude or Gemini weekly items are all marked `-disabled` still extract the 7-day reset window and resolve `WeeklyFraction = 0.0` (instead of `-1` / `UnknownUncertain`), allowing AutoSwitch to recover cleanly rather than stalling in an uncertain state.
- **6-Scenario AutoSwitch Orchestration & Cascading Fallback:** Updated `AutomationController` (`internal/engines/antigravity/automation/controller.go`) to handle all 6 switching situations in priority order: (1) reactive runtime quota/tier failures via `RetryCoordinator`, (2) proactive quota depletion (`<= 2%`), (3) active model capability mismatch on the active account, (4) permanent auth/entitlement failure, (5) cascading fallback across remaining eligible candidates when `!CredentialSwitched` while preserving `lastSwitchErr`, and (6) clean no-op when AutoSwitch is `OFF`.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.8.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.7] - 2026-11-19

### Antigravity `Gemini 4 Neon` Shared Pool Consolidation (True SSOT)
- **Canonical `PoolGemini` Shared Pool Mapping:** Consolidated `Gemini 4 Neon` (`neon` tokenized word boundary) into the canonical `PoolGemini` shared pool (`Row 1: Gemini`) alongside `Gemini 3` and `Gemini 4 Hydrogen` in `internal/engines/antigravity/model/pool_taxonomy.go`, keeping the standard 3-row Antigravity account card layout without creating a redundant 4th extension row for `Neon`.
- **Single Source of Truth (`pool_taxonomy.go`) Across All Pipelines:** Eliminated scattered hardcoded `"hydrogen"` and `"orchestrator"` checks across telemetry bucket classification (`client.go`, `cache.go`), baseline-preference fallback priority (`IsGeminiAlias`), and AutoSwitch active-model category resolution (`model_quota.go`), delegating all pool decisions directly to `model.ResolveQuotaPool` while preserving raw IDE `modelID` values for retry execution.
- **Self-Healing Cache & True Row-4 Extension Isolation:** Automatically cleans up legacy or transient `"neon"` / `"hydrogen"` entries from `ExtensionBuckets` when loading cached telemetry on startup while keeping genuinely independent Gemini 4+ models (such as `Gemini 4 Carbon`) on their dedicated dynamic 4th card row.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.7.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.6] - 2026-11-18

### Antigravity FREE Tier Real Quota Telemetry (`aicode-consumers` Project ID Preservation)
- **Preserve Consumer Project ID (`aicode-consumers`):** Fixed `SanitizeCloudCodeProjectID` in `internal/engines/antigravity/model/types.go` so that `"aicode-consumers"` and `"projects/aicode-consumers"` returned by `loadCodeAssist` on personal/FREE accounts are preserved instead of being stripped to an empty string.
- **Accurate Per-Account Quota Consumption:** Ensures `v1internal:fetchAvailableModels` receives `{"project": "aicode-consumers"}` rather than an empty `{}` body, returning real per-account depleted quota percentages (matching Antigravity IDE Settings) instead of static 100% defaults.
- **Daily Cloud Code Endpoint Routing Safety:** Keeps consumer project IDs routed to `daily-cloudcode-pa.googleapis.com` in `ResolveCloudCodeBaseURL`, reserving production GCP routing strictly for enterprise GCP projects.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.6.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.5] - 2026-11-18

### Single-Quote Sequential Marquee UX Refinement
- **One Quote at a Time Sequential Flow:** Updated the footer quote marquee strip so only a single quote scrolls across the strip at any moment, waiting until the active quote completely exits past the left edge before spawning the next non-repeating quote and contrast-calibrated color from the right edge.
- **Clean Startup & Resize Continuity:** Starts the initial quote cleanly near the left margin and adjusts horizontal positioning gracefully during window shrink or expansion without backfilling overlapping quotes.
- **Locale, Theme & Tray Synchronization:** Preserves smooth scroll continuity across English/Vietnamese switches (immediately advancing when a shorter translation exits), updates theme-calibrated colors safely across **Dark**, **Warm**, and **Light** themes, and honors System Tray pause, resume, and exit lifecycles.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.5.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.4] - 2026-11-18

### Embedded Bilingual Quote Marquee Strip Above Footer
- **Continuous Inspiration Marquee Bar:** Added a dedicated 22px horizontal quote marquee strip directly above the bottom status footer across the application window, smoothly scrolling an embedded corpus of 45 bilingual quotes (English and Vietnamese) from right to left without external disk reads.
- **Non-Repeating Randomization & Theme-Calibrated Colors:** Selects consecutive quotes and colors from a 20-color palette without immediate repeats, automatically adapting text contrast across **Dark**, **Warm**, and **Light** themes with uniform 10-space inter-quote separation.
- **Instant Locale & Tray Lifecycle Sync:** Switches displayed quotes seamlessly between English and Vietnamese on language changes while preserving scroll continuity, pauses animation while minimized to the Windows System Tray, resumes cleanly on restore, and shuts down safely on exit.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.4.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.3] - 2026-11-18

### Codex Footer Liveness Status & Global Application Version Parity
- **Live Codex Desktop Status Footer:** Replaced the static placeholder in the Codex tab's bottom-left status bar with real-time ChatGPT Desktop process liveness monitoring (`Codex: Active` / `Codex: Inactive` in English; `Codex: Hoạt động` / `Codex: Không hoạt động` in Vietnamese), updated automatically at startup, on periodic background ticks independent of Antigravity busy state, and across instant language switches.
- **Unified Footer Version Display:** Synchronized the bottom-right footer label across both Antigravity and Codex tabs to always display the application's official version string (`version.GetFullVersion()`) whenever no transient status notification is active.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.3.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.2] - 2026-11-18

### Antigravity FREE Tier Weekly Quota & OAuth Badge Alignment
- **FREE Tier Weekly Quota Resolution:** Resolved weekly quota percentages and 7-day reset countdowns (`Gemini` and `Claude`) directly from available model metadata on `FREE` tier Antigravity accounts without treating `SUBSCRIPTION_REQUIRED` summary responses or license help links as account validation errors.
- **Deterministic Weekly Window Selection & Self-Healing Cache:** Prioritized active 7-day weekly quota models over shorter or disabled entries while keeping `5h` and `Gemini 4 Carbon` columns at `--` and `Gemini 4 Argon` at `[LOCKED]`, and automatically healed legacy cached `SUBSCRIPTION_REQUIRED` entries on startup.
- **Streamlined Card `[Needs OAuth]` / `[Cần OAuth]` Badge:** Unified OAuth re-authentication indicators into the top-right card action slot (`[Cần OAuth]` / `[Need OAuth]`) for inactive accounts requiring login and removed the bottom card warning banner across all themes.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.2.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.1] - 2026-11-18

### Antigravity ULTRA Gemini 4 Carbon Quota & Category Resolution
- **Dynamic ULTRA Extension Quota Resolution:** Updated Antigravity quota resolution to extract active weekly quota percentages and reset times for dynamic Gemini 4+ extension models (such as `Gemini 4 Carbon`) on `ULTRA` accounts when summary buckets only report aggregate pools, while preserving exact summary bucket fractions whenever present.
- **Disabled Extension Model Filtering:** Filtered out `-disabled` model entries on `PRO` and `FREE` accounts so inapplicable extension models continue to display `--` cleanly without creating empty quota buckets.
- **Active Model Category Resolution:** Updated autonomous switching model classification to resolve active `Gemini 4 Carbon` placeholders and aliases directly to the `carbon` quota category.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.1.msi` with a SHA-256 checksum in `checksums.txt` through the official MSI update channel.

---

## [Version 1.4.0] - 2026-11-16

### Codex Chat Selection & Activity Tracking
- **Quota-Limited Chat Recovery:** Updated chat selection during manual account switching to include the active Desktop session's latest quota-limited chats even when no prior quota hint is available, while excluding completed, interrupted, waiting, and unrelated failed chats.
- **Recent Activity Tracking:** Aligned Codex chat activity tracking with current Desktop timestamp fields so recent work can remain eligible for continuation when saved activity is older.
- **Windows Release Package:** Ships as `AS_Auto_Switcher_1.4.0.msi` with a SHA-256 checksum in `checksums.txt` through the existing MSI update channel.
- **Verification Limitation:** Live Desktop account switching, quota recovery, and automatic chat continuation still require real-session verification; these release notes do not claim those scenarios have passed.

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
