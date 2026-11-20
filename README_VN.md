# AS Auto Switcher - **Version 1.4.9**

[Tiếng Việt](README_VN.md) | [English](README_EN.md)

Nếu bạn có 1 tài khoản cá nhân, 1 tài khoản công ty, 1 tài khoản để làm dự án bên ngoài; mỗi khi chuyển tài khoản để làm việc cứ phải sign in/out mất thời gian thì công cụ này chính là dành cho bạn.

### **Khi tài khoản được chuyển tự động, tất cả công việc đang làm vẫn tiếp tục bình thường, tuyệt đối không bị gián đoạn, không cần can thiệp thủ công.**

### **An toàn vì tuân thủ theo cơ chế chuyển đổi tài khoản được các IDEs cho phép. Không can thiệp mã nguồn của IDEs (Antigravity, ChatGPT app, Claude Code, ...), không dùng cơ chế bọc API.**

Ứng dụng Windows viết bằng **Go**, giúp quản lý nhiều tài khoản, theo dõi quota và chuyển đổi tài khoản đang dùng trên các IDEs (**Antigravity, ChatGPT app, Claude Code, ...**) một cách linh hoạt, an toàn. Ứng dụng cung cấp giao diện desktop **Fyne** đồ họa trực quan, hiện đại, mang lại trải nghiệm Zero-Console mượt mà, cài đặt gọn sạch qua bộ cài Windows chính thức và tự động cập nhật nền.

Ứng dụng tích hợp toàn diện hệ thống **Chuyển Đổi Tài Khoản Tự Động (Autonomous Multi-Account Switcher & Failover Daemon)** với đường ống 3 giai đoạn nâng cao (v1.0.3.2) tích hợp bộ lọc chống nhảy tài khoản lặp (Anti-Thrashing Guard). Người dùng có thể linh hoạt chọn giữa chuyển tài khoản thủ công (bằng nút **Chuyển** trên GUI) và chuyển đổi tự động hoàn toàn (AutoSwitch). Khi bật chế độ Tự động, hệ thống tự động giám sát quota, phát hiện cạn kiệt tài nguyên, tự phục hồi thử lại trong bộ nhớ, sàng lọc ứng viên sạch và tự động chọn tài khoản dự phòng tối ưu nhất theo thuật toán **Burn-down Sorter** mà không làm gián đoạn dòng suy nghĩ công việc của lập trình viên.

## Tính năng nổi bật (Trải nghiệm người dùng)

- **Menu khay hệ thống tinh gọn & Đóng ứng dụng an toàn (v1.0.3.2):**
  - Loại bỏ triệt để nút "Quit" bị trùng lặp trên menu chuột phải của biểu tượng khay hệ thống, chỉ giữ một tùy chọn thoát duy nhất theo đúng ngôn ngữ đang chọn ("Thoát" hoặc "Exit").
  - Đảm bảo dừng gọn gàng các tác vụ theo dõi nền và lưu toàn bộ tùy chọn cá nhân trước khi thoát hoàn toàn từ cửa sổ chính hoặc khay hệ thống.
- **Đồng bộ Quota tức thì khi khởi động (Initial Sync tại t = 0):**
  - Xóa bỏ hoàn toàn độ trễ 60 giây khi mở ứng dụng, tự động kéo dữ liệu quota mới nhất từ hệ thống của các IDEs hỗ trợ (**Antigravity, ChatGPT app, Claude Code, ...**) ngay trong giây đầu tiên.
  - Hoạt động tức thì bất kể công tắc AutoSwitch đang BẬT hay TẮT, cập nhật ngay số liệu quota lên toàn bộ thẻ tài khoản.
  - Tự động kích hoạt chuyển đổi tài khoản ngay khi mở app nếu phát hiện tài khoản đang dùng đã cạn kiệt, đảm bảo chuyển đổi dự phòng tức thì mà không cần người dùng thao tác thủ công.
- **Thuật toán AutoSwitch 3 Giai đoạn Thông minh (v1.0.3.2):**
  - **Giai đoạn 1 (Phát hiện):** Giám sát liên tục phát hiện cạn kiệt quota thời gian thực qua mã lỗi 429 và đánh giá telemetry chu kỳ nền chủ động.
  - **Giai đoạn 2 (Lọc ứng viên & Chống nhảy lặp Thrashing):** Áp dụng ngưỡng hạn mức tuần an toàn nghiêm ngặt **> 2%** (loại bỏ hoàn toàn các tài khoản <= 2%) cùng điều kiện "VÀ" bắt buộc (**5h > 2% VÀ Tuần > 2%**), triệt tiêu triệt để hiện tượng nhảy tài khoản liên tục (Thrashing / Flapping Loop).
  - **Giai đoạn 3 (Sắp xếp Burn-down & Preflight an toàn):** Luân chuyển đến tài khoản dự phòng tối ưu nhất theo nguyên tắc Burn-down (ưu tiên tuần thấp nhất trước `w1 < w2`), thực hiện kiểm tra preflight thăm dò quota thực tế trước khi chốt chuyển đổi.
- **Giao diện lưới thẻ tài khoản trực quan:** Danh sách tài khoản hiển thị dạng lưới tiện quan sát với các trạng thái rõ ràng:
  - `[Dùng]`: Tài khoản đang hoạt động trong IDE tương ứng (**Antigravity, ChatGPT app, Claude Code, ...**).
  - `[Chuyển]`: Đổi sang tài khoản này nhanh chóng chỉ với 1 thao tác bấm.
  - `[Cần OAuth]`: Nhắc nhở tài khoản cần đăng nhập trong IDE để cấp quyền truy cập.
- **Nút xóa an toàn:** Hỗ trợ dọn dẹp các tài khoản không còn dùng (Inactive). Tích hợp hộp thoại xác nhận Danger để bảo vệ tuyệt đối, tránh xóa nhầm tài khoản đang hoạt động.
- **Công tắc AutoSwitch tự động:** Gạt bật/tắt chế độ tự động chuyển đổi tài khoản ngay khi cạn kiệt quota, đảm bảo công việc code diễn ra liên tục, không bị đứt mạch suy nghĩ.
- **Thanh trạng thái thời gian thực:** Cập nhật sống động trạng thái hoạt động của hệ thống (`IDLE`, `EVALUATING`, `SWITCHING`, `SWITCHED`...).
- **Dashboard theo dõi Quota chi tiết:** Theo dõi trực quan phần trăm quota còn lại của các mô hình trên từng IDE (**Antigravity, ChatGPT app, Claude Code, ...**) theo cả chu kỳ 5h và chu kỳ Tuần; thanh tiến trình tự đổi màu theo mức độ khả dụng (xanh: dồi dào, vàng: trung bình, đỏ: sắp cạn).
- **Làm mới danh sách & quota tức thì:** Nút làm mới toàn bộ danh sách hoặc làm mới riêng biệt từng tài khoản chỉ trong tích tắc.
- **3 chủ đề giao diện hiện đại:** Tùy chọn chuyển đổi linh hoạt giữa giao diện **Dark**, **Light**, và **Warm** phù hợp với mắt nhìn.
- **Chế độ ghim Always-on-Top:** Giữ cửa sổ ứng dụng luôn nổi trên màn hình để tiện theo dõi hạn mức quota trong lúc làm việc.
- **Thu nhỏ khay hệ thống (System Tray):** Thu gọn ứng dụng xuống Taskbar/Tray góc màn hình khi không cần mở lớn, với menu ngữ cảnh tinh gọn, không trùng lặp nút thoát và hỗ trợ đóng an toàn.

## Cài đặt & Khởi chạy

### 1. Bản phát hành Windows chính thức (Bộ cài MSI)

Ứng dụng được phát hành chính thức qua GitHub Releases dưới dạng bộ cài Windows gắn phiên bản (`AS_Auto_Switcher_<version>.msi`, ví dụ `AS_Auto_Switcher_1.3.9.msi`):
- Tải về từ trang **Releases** chính thức và đối chiếu mã kiểm tra trong `checksums.txt`.
- Chạy bộ cài để cài đặt và khởi chạy giao diện.
- Các bản cập nhật mới tiếp theo sẽ được kiểm tra và nâng cấp tự động qua kênh GitHub Releases.

### 2. Hướng dẫn sử dụng nhanh

1. **Lưu tài khoản:** Đăng nhập tài khoản của bạn trong IDE tương ứng (**Antigravity**, **ChatGPT app**, **Claude Code**, ...), sau đó mở Switcher và bấm **Danh sách tài khoản** để tự động lưu phiên. Lặp lại với các tài khoản khác khi cần lưu thêm.
2. **Chuyển đổi thủ công:** Bấm nút **Chuyển** trên thẻ tài khoản đã lưu để hoán đổi tài khoản đang làm việc.
3. **Chuyển đổi tự động:** Gạt bật công tắc **Tự động** (AutoSwitch). Ứng dụng sẽ tự động phát hiện khi tài khoản hiện tại hết hạn mức và tự động chuyển sang tài khoản kế tiếp tốt nhất mà không cần bạn can thiệp.

## An toàn, Bảo mật & Bản quyền

- **Bảo mật dữ liệu cục bộ:** Toàn bộ dữ liệu phiên và OAuth tài khoản được lưu trữ an toàn ngay trên máy tính cá nhân của bạn, không gửi lên bất kỳ máy chủ bên thứ 3 nào. Kết nối mạng chỉ phục vụ kiểm tra quota với hệ thống chính thức và tự động cập nhật phiên bản mới qua GitHub Releases.
- **Tuân thủ chuẩn mực:** Cơ chế chuyển đổi tuân thủ đúng quy chuẩn được các IDEs cho phép (**Antigravity, ChatGPT app, Claude Code, ...**), không can thiệp mã nguồn của IDEs và không dùng cơ chế bọc API.
- **Bản quyền thương mại:** Copyright (c) 2026 Tam Nguyen / CheapApp Auto switcher. All Rights Reserved. Đây là phần mềm thương mại độc quyền (không phải mã nguồn mở hoặc phần mềm miễn phí). Xem chi tiết tại [`LICENSE`](LICENSE).

## 📜 Lịch sử Phiên bản

## [Version 1.4.9] - 2026-11-20
- **Độ Chính Xác Quota Kép (Dual-Cycle) & Bộ Nhớ Model Hot-Switch:** Ưu tiên chuẩn `PoolClaude` trên mọi parser telemetry/cache, chặn giá trị mặc định từ `-weekly` làm sai lệch `5h`, kiểm tra `Disabled`/`WeeklyDisabled` trước `-1` cùng chuẩn kép `AND` trong `IsModelSupportedByAccount`, và bổ sung `modelCatalog` fallback trong RAM khi model tạm ẩn sau hot-switch (`ErrModelNotInCascadeConfig`).
- **Chế Độ Chờ Option A Standby Wait & Co Giãn Giao Diện Tức Thì:** Tách biệt `StatusWaitingCandidate` (`WAIT_CANDIDATE`) khỏi Hard Safety Stop để giữ `AutoSwitch` bật, reset `RetryCoordinator` và hiển thị cảnh báo song ngữ ở thanh đáy khi còn tài khoản dự phòng `ON`+token đang chờ, đồng thời tự động relayout khung chữ thanh đáy ngay lần hiện đầu và thanh công cụ/thẻ tài khoản trên cả Antigravity lẫn Codex khi đổi ngôn ngữ `EN`/`VN` (giữ nguyên ẩn tài khoản).
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.9.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.8] - 2026-11-19
- **Antigravity Tier-Affinity & Khớp Năng Lực Mô Hình (Model Capability Match):** Bổ sung bộ lọc cứng Tiêu chí 7 (`IsModelSupportedByAccount`) trước khi sắp xếp Burn-down—chặn tài khoản `FREE` khỏi các mô hình giới hạn (`Carbon`, `Argon`, `Hydrogen`, `Orchestrator`, Gemini `>= 4`, Claude `>= 5`) nhưng vẫn giữ nguyên `Claude 4.6` và `Gemini 2.5 Pro`, kiểm tra quyền dùng extension trên `PRO`, đồng thời ưu tiên chuyển sang tài khoản cùng hạng hoặc cao hơn (`ULTRA` > `PRO` > `FREE`) với fallback an toàn.
- **Danh Mục Lỗi Google Thống Nhất, Fallback Telemetry 60s cho FREE & 6 Tình Huống Auto-Switch:** Chuẩn hóa nhận diện lỗi quota/entitlement (`429`/`402`/`401`/`403` theo ngữ cảnh tier) kèm bộ lọc chống bão chuyển đổi (`INVALID_ARGUMENT`, `400 BAD REQUEST`, `SAFETY_VIOLATION`), quy đổi telemetry `-disabled` trên `FREE` về `0.0%` + reset 7 ngày để AutoSwitch không bị treo, và xử lý đầy đủ 6 tình huống chuyển đổi gồm lệch năng lực model đang dùng và chuyển tiếp cascading khi ứng viên thất bại.
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.8.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.7] - 2026-11-19
- **Gộp `Gemini 4 Neon` vào Nhóm Quota `Gemini` Chung (True SSOT):** Hợp nhất `Gemini 4 Neon` vào nhóm quota `PoolGemini` chuẩn (Dòng 1 `Gemini`) thông qua nguồn chân lý duy nhất `model.ResolveQuotaPool`, loại bỏ dòng mở rộng `"neon"` dư thừa trên thẻ tài khoản, tự động làm sạch cache cũ khi khởi động và đồng bộ đánh giá AutoSwitch theo hạn mức `Gemini` chung trong khi vẫn giữ nguyên dòng thứ 4 động cho các mô hình mở rộng độc lập (`Gemini 4 Carbon`).
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.7.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.6] - 2026-11-18
- **Hiển thị chính xác Quota thực tế cho tài khoản Antigravity FREE (`aicode-consumers`):** Sửa hàm `SanitizeCloudCodeProjectID` để giữ lại định danh dự án `"aicode-consumers"` trên các tài khoản cá nhân/FREE, giúp request `fetchAvailableModels` gửi kèm `{"project": "aicode-consumers"}` và trả về đúng phần trăm quota bị tụt thực tế đồng nhất 100% với Antigravity IDE thay vì mức 100% tĩnh mặc định.
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.6.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.5] - 2026-11-18
- **Dải Quote Chạy Tuần Tự Từng Câu:** Tinh chỉnh dải quote phía trên thanh đáy để chỉ hiển thị một câu tại một thời điểm, đợi câu đang chạy trôi hẳn qua mép trái mới xuất hiện câu tiếp theo không lặp lại và màu tương phản mới từ mép phải.
- **Đồng Bộ Thu Phóng, Ngôn Ngữ & Giao Diện:** Giữ nhịp chạy đơn mượt mà khi thay đổi kích thước cửa sổ, chuyển đổi nhanh Việt/Anh, đổi chủ đề **Dark**, **Warm**, **Light** và tạm dừng/chạy tiếp qua khay hệ thống.
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.5.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.4] - 2026-11-18
- **Dải Quote Chữ Chạy Song Ngữ Trên Thanh Đáy:** Bổ sung dải marquee ngang 22px phía trên thanh đáy hiển thị liên tục 45 câu nói truyền cảm hứng tiếng Việt/tiếng Anh được nhúng sẵn trong ứng dụng, sử dụng bảng 20 màu tương phản cao theo giao diện (**Dark**, **Warm**, **Light**) và chọn ngẫu nhiên không lặp liền kề.
- **Đồng Bộ Ngôn Ngữ Tức Thì & Khay Hệ Thống:** Tự động chuyển đổi ngôn ngữ quote mượt mà khi đổi Việt/Anh mà vẫn giữ nhịp chạy liên tục, đồng thời tự tạm dừng khi thu gọn xuống khay hệ thống và chạy tiếp khi khôi phục cửa sổ.
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.4.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.3] - 2026-11-18
- **Trạng thái hoạt động Codex thời gian thực ở thanh đáy:** Cập nhật góc trái thanh đáy tab Codex để phản ánh trực tiếp trạng thái tiến trình ChatGPT Desktop (`Codex: Hoạt động` / `Codex: Không hoạt động`) ngay khi khởi động, theo chu kỳ nền độc lập và khi chuyển đổi ngôn ngữ.
- **Đồng bộ hiển thị phiên bản ứng dụng:** Thống nhất góc phải thanh đáy trên cả tab Antigravity và tab Codex cùng hiển thị phiên bản chính thức của ứng dụng (`Version: 1.4.3`).
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.3.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.2] - 2026-11-18
- **Hiển thị Quota tuần trên tài khoản Antigravity FREE:** Bổ sung hiển thị chính xác phần trăm hạn mức tuần và thời gian làm mới 7 ngày cho `Gemini` và `Claude` trên tài khoản `FREE`, giữ nguyên hiển thị `--` cho cột `5h` và `Gemini 4 Carbon`, `[LOCKED]` cho `Gemini 4 Argon`, đồng thời tự động phục hồi các mục cache `SUBSCRIPTION_REQUIRED` cũ khi khởi động.
- **Đồng bộ nhãn `[Cần OAuth]` trên thẻ tài khoản:** Gom trạng thái yêu cầu xác thực lại OAuth về vị trí nút hành động góc trên bên phải (`[Cần OAuth]` / `[Need OAuth]`) đối với tài khoản chưa kích hoạt và loại bỏ dòng cảnh báo tràn ở đáy thẻ trên mọi giao diện.
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.2.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.1] - 2026-11-18
- **Hiển thị Quota Gemini 4 Carbon trên tài khoản ULTRA:** Bổ sung trích xuất phần trăm hạn mức tuần và thời gian làm mới cho mô hình mở rộng `Gemini 4 Carbon` đang hoạt động trên tài khoản Antigravity `ULTRA`, đồng thời giữ nguyên hiển thị `--` đối với các mục bị vô hiệu hóa trên tài khoản `PRO` và `FREE`.
- **Nhận diện phân loại Carbon cho AutoSwitch:** Đồng bộ bộ phân loại mô hình đang chọn để chế độ tự động chuyển đổi đánh giá chính xác hạn mức của `Gemini 4 Carbon`.
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.1.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.

## [Version 1.4.0] - 2026-11-16
- **Chat Codex hết hạn mức:** Cập nhật việc chọn chat khi chuyển tài khoản thủ công để nhận các chat mới nhất bị giới hạn quota trong phiên Desktop đang hoạt động mà không cần dấu hiệu quota từ trước; vẫn loại chat đã hoàn tất, bị ngắt, đang chờ và lỗi không liên quan.
- **Theo dõi hoạt động gần nhất:** Đồng bộ cách đọc thời điểm hoạt động của chat với các trường thời gian hiện tại của Desktop, giúp nhận diện công việc mới khi dữ liệu hoạt động đã lưu còn cũ.
- **Gói cài Windows:** Cung cấp `AS_Auto_Switcher_1.4.0.msi` cùng mã đối chiếu SHA-256 qua kênh cập nhật MSI hiện có.
- **Giới hạn kiểm chứng:** Chuyển tài khoản, phục hồi quota và tự động tiếp tục chat trên Desktop thực vẫn đang chờ kiểm chứng bằng phiên làm việc thật.

## [Version 1.3.9] - 2026-11-15
- **Phát hành duy nhất bộ cài MSI gắn phiên bản:** Tinh gọn kênh phát hành chính thức chỉ còn một bộ cài Windows gắn sẵn số phiên bản (`AS_Auto_Switcher_1.3.9.msi`) kèm tệp đối chiếu `checksums.txt`, loại bỏ các gói trùng lặp và bản chạy rời.
- **Đồng bộ tự động cập nhật theo gói MSI gắn phiên bản:** Các bản đã cài đặt sẽ tự động tìm, kiểm tra toàn vẹn SHA-256 và nâng cấp bằng đúng gói `AS_Auto_Switcher_<version>.msi` từ GitHub Releases mà vẫn giữ nguyên tài khoản và thiết lập cá nhân.
- **Lưu ý nâng cấp thủ công một lần (`1.3.6–1.3.8`):** Người dùng đang ở phiên bản `1.3.6–1.3.8` cần tải và chạy bộ cài `AS_Auto_Switcher_1.3.9.msi` một lần để chuyển sang cơ chế mới; từ `1.3.9` trở đi mọi bản cập nhật sẽ tự động hoàn toàn.

## [Version 1.3.8] - 2026-11-14
- **Tự thử lại thông minh & Phục hồi nhanh:** Kiểm tra bản mới mỗi giờ và tự động thử lại theo nhịp tăng dần khi có bản phát hành mới, rớt mạng tạm thời hoặc giới hạn truy cập thay vì phải chờ nhiều giờ.
- **Bảo vệ tải gói cài đặt trên mạng chậm:** Tách riêng thời gian chờ kết nối với thời gian tải bộ cài lớn, tự ngắt kết nối bị treo và luôn giữ nguyên bản cập nhật đã xác thực sẵn sàng trên máy nếu lần kiểm tra mới gặp lỗi.
- **Nhật ký cập nhật gọn nhẹ tự xoay vòng:** Ghi nhận chẩn đoán cập nhật theo dung lượng giới hạn tự xoay vòng, không lưu thông tin cá nhân hay tài khoản, đồng thời cung cấp thêm gói cài đặt gắn sẵn số phiên bản bên cạnh bản chuẩn.

## [Version 1.3.7] - 2026-11-14
- **Cập nhật Bản quyền Thương mại & Thương hiệu:** Đồng bộ thông tin bản quyền thương mại CheapApp và nhận diện thương hiệu trên tài liệu phát hành cùng gói cài đặt Windows.
- **Mở rộng Tài liệu Đa công cụ AI / IDE:** Chuẩn hóa hướng dẫn tiếng Việt và tiếng Anh cho các công cụ AI và IDE được hỗ trợ (`Antigravity`, `ChatGPT app`, `Claude Code` và các quy trình tương thích).
- **Đồng bộ Phát hành:** Đồng bộ nhất quán số phiên bản giữa ứng dụng desktop, bộ cài đặt Windows và tệp đối chiếu mã kiểm tra.

## [Version 1.3.6] - 2026-11-14
- **Tự động Kiểm tra & Cài đặt Bản cập nhật:** Tự động kiểm tra bản phát hành mới từ kênh GitHub Releases chính thức và xác thực toàn vẹn SHA-256 trước khi cài đặt.
- **Nút Update Một chạm Trên Thanh Tiêu đề:** Hiển thị nút **Update** gọn nhẹ ngay trên thanh tiêu đề khi bản mới đã sẵn sàng, đồng thời bảo vệ an toàn không nâng cấp khi đang chuyển đổi tài khoản.
- **Làm mới Biểu tượng Thương hiệu & Gom nhóm Mô hình:** Cập nhật biểu tượng CA đồng bộ trên ứng dụng, khay hệ thống, bộ cài đặt Windows và gom nhóm hiển thị hạn mức mô hình trực quan hơn.

## [Version 1.3.5] - 2026-11-10
- **Bộ cài đặt Windows MSI & Khay Hệ thống:** Bổ sung trình cài đặt Windows MSI chuẩn 3 phần hỗ trợ gỡ cài đặt sạch, thu gọn xuống khay hệ thống kèm khôi phục cửa sổ nhanh và chuẩn hóa thư mục lưu trữ cục bộ.
- **Quản lý Tài khoản ChatGPT / Codex Desktop:** Hỗ trợ chuyển đổi tài khoản độc lập và tự động dự phòng trên cả Antigravity lẫn Codex, nối tiếp phiên làm việc mượt mà và tăng cường bảo vệ tài khoản.
- **Cập nhật Hạn mức Nền & Độ ổn định Dự phòng:** Mở rộng theo dõi hạn mức mô hình theo chu kỳ tuần, đồng bộ ngay sau khi chuyển tài khoản và ổn định cơ chế phục hồi dự phòng.
