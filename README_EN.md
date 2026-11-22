# AS Auto Switcher - **Version 1.5.3**

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

## [Version 1.5.3] - 2026-11-22
- **Antigravity 3-Tier Continuation Filtering:** Replaced coarse mtime-only post-switch scanning with a 3-Tier filter (5-minute PC-clock window with `killed == 0`, 5 live/interrupted reasons including strict nested-protobuf UUID/trace-sanitized `step_type=17` quota detection, and bottom-up `Children -> Standalone -> Parents` ancestor-chain ordering), eliminating false `"Continue..."` wakeups on completed or canceled threads while reliably resuming active subagent trees and quota-interrupted threads.
- **Engine-Isolated Antigravity & Codex Continuation Modules:** Extracted dedicated `internal/engines/antigravity/continuation` and `internal/engines/codex/continuation` packages (`0` cross-engine or inverted imports), keeping `antigravity/reloader` and `codex/ipc` cleanly decoupled while wiring reactive `InterruptedConversationIDs` + `FREE`-tier inference in Antigravity and preserving 100% Codex continuation parity (`SendTurnStart` prompt support, 3s pacing, live/offline collection) via `ui/app.go`.
- **Packages & Platform Verification Notice:** Ships all 8 release assets (`AS_Auto_Switcher_1.5.3.msi`, `AS_Auto_Switcher_1.5.3-linux-amd64.tar.gz`, `AS_Auto_Switcher_1.5.3-linux-arm64.tar.gz`, `AS_Auto_Switcher_1.5.3-darwin-arm64.tar.gz`, `AS_Auto_Switcher_1.5.3-darwin-amd64.tar.gz`, `install.sh`, `checksums.txt`, `change.md`) with verified SHA-256 digests. Note: macOS live desktop hooks (`Antigravity` Keychain / `Codex.app` IPC) await Phase 2 physical macOS hardware verification.

## [Version 1.5.2] - 2026-11-22
- **Consolidated Multi-OS Release Orchestrator:** Delivered full 8-asset Multi-OS releases via a single PowerShell 5.1 / 7+ entrypoint (`updater/publish_release_github.ps1`) coordinating native Windows MSI (`windows/amd64`), Docker Ubuntu 22.04 Linux (`linux/amd64` & `linux/arm64`), and a 1-runner read-only `macos-latest` worker (`darwin/arm64` & `darwin/amd64`) with deterministic `dispatch_id` / `macos-manifest.json` SHA-256 verification and a 5/5 binary completeness gate.
- **Anti-404 POSIX Installer & Clean Source Export:** Updated `scripts/install.sh` to verify the target platform archive and SHA-256 entry in `checksums.txt` before downloading `.tar.gz` binaries, and hardened `scripts/push_clean_github.ps1` to strip internal workspace metadata cleanly while preserving local Git history.
- **Cross-OS Updater & Test Stability:** Normalized Windows install path matching across non-Windows runtimes (`updater/env.go`) and resolved cross-OS / macOS symlink and clean-checkout test portability across `internal/`, `ui/`, and `updater/`.
- **Packages & Platform Verification Notice:** Ships all 8 release assets (`AS_Auto_Switcher_1.5.2.msi`, `AS_Auto_Switcher_1.5.2-linux-amd64.tar.gz`, `AS_Auto_Switcher_1.5.2-linux-arm64.tar.gz`, `AS_Auto_Switcher_1.5.2-darwin-arm64.tar.gz`, `AS_Auto_Switcher_1.5.2-darwin-amd64.tar.gz`, `install.sh`, `checksums.txt`, `change.md`) with verified SHA-256 digests. Note: macOS live desktop hooks (`Antigravity` Keychain / `Codex.app` IPC) await Phase 2 physical macOS hardware verification.

## [Version 1.5.1] - 2026-11-22
- **Immediate Failover on Individual Quota Exhaustion:** Classified Google individual quota exhaustion errors (`Individual quota reached`, `upgrade your subscription`, `exhausted your capacity`, and long-horizon `Resets in Nh/Nd`) as `ErrorSeverityHardImmediate` (0 retries) so AutoSwitch fails over immediately without wasted retries.
- **Per-Conversation Model Isolation & Preservation:** Extracted per-conversation `model_enum` from `conversations/<uuid>.db` (`gen_metadata`) into `ActiveThread.Model` during `ScanActiveConversations`, preserving exact per-thread models across `RetryCoordinator` (`SendEmptyItemsRetry`) and `PerformSessionContinuation` while skipping unsupported/disabled secondary threads instead of overriding them with the global default model.
- **Multi-Thread Proactive Evaluation & 2-Tier Co-Active Failover:** Inspected all active thread models during proactive evaluation (preventing a healthy `.pbtxt` default model from masking a depleted active model) and passed the failing thread's `TriggerModelID` into `TriggerSwitchForModel` with 2-tier co-active candidate prioritization.
- **Packages:** Ships `AS_Auto_Switcher_1.5.1.msi` and `install.sh` with SHA-256 verification in `checksums.txt`, preserving full Windows MSI auto-update compatibility.

## [Version 1.5.0] - 2026-11-22
- **Unified Quota & Auto-Switch Truth Table (Antigravity & Codex):** Implemented Proto3-0% reconstruction, 5h vs. Weekly classification, `Gemini 3.8` FREE/PAID separation, decoupled `EvaluateModelEntitlement` and 25-state cycle evaluation, P2 permanent auth priority, `WAIT_CANDIDATE` (`PREFLIGHT_TRANSIENT`) persistence on transient preflight errors, nearest-tier step-up affinity, hard-immediate reactive failover, and Codex Burn-Down candidate filtering with `SafetyStopManager` and 24h stale `inProgress` timeout.
- **Cross-Platform Foundation, Native UI & Hardened Multi-OS Updater:** Decoupled Antigravity, Codex, `cmd/switcher`, and `ui/` from Win32 via `internal/platform/{paths,proc,lock,secretstore,browser,credentialio}`, added Unix domain socket Codex IPC and cross-platform single-instance/updater locks, and hardened multi-OS `.tar.gz` updater extraction against symlink escapes and clobbering (`os.Lstat`, `O_EXCL`, strict entry allowlist).
- **Multi-OS Packaging, Installer & CI/CD Release Pipeline:** Added `scripts/build_MAC.ps1`, `scripts/build_linux.ps1`, zero-sudo POSIX `scripts/install.sh`, GitHub Actions CI & multi-OS release workflows, and unified zero-code release publishing (`updater/publish_release_github.ps1`).
- **Packages & Platform Verification Notice:** Ships `AS_Auto_Switcher_1.5.0.msi` and `install.sh` with SHA-256 verification in `checksums.txt`, preserving full Windows MSI auto-update compatibility. Note: macOS live desktop hooks (`Antigravity` Keychain / `Codex.app` IPC) await Phase 2 physical macOS hardware verification.

## [Version 1.4.11] - 2026-11-21
- **Antigravity 2.34.0+ Daemon Hub Discovery & Port Pinning:** Preserved legacy `--csrf_token` CLI discovery while adding O(1) `~/.gemini/antigravity/daemon/hub_<httpPort>.json` discovery (`ResolveDaemonHubInfo`), `PID`/`CSRFToken` verification, `httpPort` pinning against Sidecar Swarm ports, and dead-PID hub cleanup (`CleanupDaemonHubFilesForPIDs`) during `RecycleLanguageServer`.
- **Top-Level `modelId` & Qualifier-Resilient Model Matching:** Added `ClientModelConfig.ModelID` (`EffectiveAlias()`), thinking-suffix/qualifier-tolerant matching (`matchesModelItem`), and summary-catalog protection (`hasConcreteModelCatalogItems` in `IsModelSupportedByAccount`) for dynamic models like `Gemini 4 Neon` and `Gemini 3.8 Flash`.
- **Stale `.pbtxt` Active-Model Recovery:** Added `SelectActiveCascadeModelConfig`, `enrichConfigFromCatalog`, and `DiscoverVerifiedActiveAgentModel` so AutoSwitch evaluation, quota retries, and session continuation recover cleanly when `antigravity_state.pbtxt` holds stale placeholders or `defaultOverrideModelConfig` omits metadata.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.11.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.10] - 2026-11-20
- **Borderless Quote Marquee Strip:** Removed `QuoteMarqueeStrip.topSep` (`*widget.Separator`) and the intermediate `root` wrapper in `ui/quote_strip.go`, rendering `q.clip` directly (`q.clip.ExtendBaseWidget(q.clip)` + `widget.NewSimpleRenderer(q.clip)`) with `QuoteStripHeight = 21.0` so the top edge renders cleanly without a horizontal divider across **Dark**, **Warm**, and **Light** themes and both **Antigravity** and **Codex** tabs while keeping the lower `bottomSection` divider intact.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.10.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.9] - 2026-11-20
- **Antigravity Dual-Cycle Quota & Model Catalog Resilience:** Enforced canonical `PoolClaude` priority across all telemetry/cache parsers, prevented `-weekly` zero-values from polluting `5h` extension buckets, evaluated `Disabled`/`WeeklyDisabled` before `-1` with dual-cycle `AND` eligibility in `IsModelSupportedByAccount`, and added in-memory `modelCatalog` fallback across in-session hot-switches (`ErrModelNotInCascadeConfig`).
- **Option A Standby Wait & Reactive UI Relayout:** Separated `StatusWaitingCandidate` (`WAIT_CANDIDATE`) from Hard Safety Stop so `AutoSwitch` stays enabled with `RetryCoordinator` reset and bilingual footer standby banners whenever usable `ON`+token backups remain on standby, and added reactive container relayout across first-show footer banners, in-place `EN`/`VN` Antigravity & Codex toolbars (preserving account masking), and Antigravity card top rows.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.9.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.8] - 2026-11-19
- **Antigravity Tier-Affinity & Model Capability Match:** Added hard Criterion 7 candidate filtering (`IsModelSupportedByAccount`) before Burn-down sorting—blocking `FREE` accounts from restricted models (`Carbon`, `Argon`, `Hydrogen`, `Orchestrator`, Gemini `>= 4`, Claude `>= 5`) while preserving `Claude 4.6` and `Gemini 2.5 Pro`, validating `PRO` extension entitlement, and prioritizing same-or-higher subscription tiers (`ULTRA` > `PRO` > `FREE`) with graceful fallback.
- **Unified Google Error Catalog, FREE 60s Fallback & 6-Scenario Auto-Switch:** Consolidated quota/entitlement error detection (`429`/`402`/`401`/`403` tier-aware context) with Anti-Switch-Storm exclusions (`INVALID_ARGUMENT`, `400 BAD REQUEST`, `SAFETY_VIOLATION`), resolved `FREE` `-disabled` weekly telemetry to `0.0%` + 7-day reset so AutoSwitch never stalls, and handled all 6 switching scenarios including active-model mismatch and cascading fallback.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.8.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.7] - 2026-11-19
- **Antigravity `Gemini 4 Neon` Shared Pool Consolidation (True SSOT):** Consolidated `Gemini 4 Neon` into the canonical `PoolGemini` shared pool (Row 1 `Gemini`) via `model.ResolveQuotaPool`, eliminating duplicate `"neon"` extension rows, self-healing cached extension buckets on startup, and routing AutoSwitch active-model evaluation to the shared `Gemini` pool while preserving dynamic Row 4 rendering for independent extension models (`Gemini 4 Carbon`).
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.7.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.6] - 2026-11-18
- **Antigravity FREE Tier Real Quota Telemetry (`aicode-consumers`):** Fixed `SanitizeCloudCodeProjectID` to preserve the `"aicode-consumers"` consumer project ID on personal/FREE accounts so `fetchAvailableModels` sends `{"project": "aicode-consumers"}` and returns real depleted quota percentages matching Antigravity IDE Settings instead of static 100% defaults.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.6.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.5] - 2026-11-18
- **Single-Quote Sequential Marquee:** Refined the quote marquee strip to display one quote at a time, waiting until the active quote completely exits the left edge before spawning the next non-repeating quote and color at the right edge.
- **Resize, Locale & Theme Continuity:** Preserves single-quote scroll continuity across window resizes, instant English/Vietnamese switches, and **Dark**, **Warm**, and **Light** theme transitions alongside System Tray pause/resume.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.5.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.4] - 2026-11-18
- **Embedded Quote Marquee Strip:** Added a continuous 22px horizontal marquee strip above the footer displaying 45 embedded English/Vietnamese quotes with 20 theme-calibrated contrast colors (**Dark**, **Warm**, **Light**) and non-repeating random selection.
- **Live Locale & Tray Lifecycle Integration:** Switches quote language instantaneously between English and Vietnamese while preserving scroll flow, and automatically pauses when minimized to the System Tray and resumes upon restore.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.4.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.3] - 2026-11-18
- **Live Codex Desktop Footer Status:** Displays real-time ChatGPT Desktop process liveness in the Codex tab footer (`Codex: Active` / `Codex: Inactive`) with instant startup detection, background periodic checks, and seamless locale switching.
- **Unified Footer Version Display:** Synchronized the bottom-right footer on the Codex tab to display the application version (`Version: 1.4.3`) matching the Antigravity tab.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.3.msi` and SHA-256 verification through the existing MSI update channel.

## [Version 1.4.2] - 2026-11-18
- **Antigravity FREE Tier Weekly Quota:** Resolved weekly quota percentages and 7-day reset countdowns for `Gemini` and `Claude` on `FREE` accounts while keeping `5h` and `Gemini 4 Carbon` at `--`, `Gemini 4 Argon` at `[LOCKED]`, and automatically healing legacy cached `SUBSCRIPTION_REQUIRED` states on startup.
- **Unified `[Need OAuth]` Card Badge:** Moved OAuth re-authentication status directly into the top-right card action slot (`[Cần OAuth]` / `[Need OAuth]`) for inactive accounts requiring login and removed the bottom card warning banner.
- **Windows Package:** Provides `AS_Auto_Switcher_1.4.2.msi` and SHA-256 verification through the existing MSI update channel.

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
