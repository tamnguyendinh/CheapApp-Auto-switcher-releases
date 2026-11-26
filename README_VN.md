# AS Auto Switcher - **Version 1.5.8**

[Tiếng Việt](README_VN.md) | [English](README_EN.md)

Nếu bạn có 1 tài khoản cá nhân, 1 tài khoản công ty, 1 tài khoản để làm dự án bên ngoài; mỗi khi chuyển tài khoản để làm việc cứ phải sign in/out mất thời gian thì công cụ này chính là dành cho bạn.

### **Khi tài khoản được chuyển tự động, tất cả công việc đang làm vẫn tiếp tục bình thường, tuyệt đối không bị gián đoạn, không cần can thiệp thủ công.**

### **An toàn vì tuân thủ theo cơ chế chuyển đổi tài khoản được các IDEs cho phép. Không can thiệp mã nguồn của IDEs (Antigravity, ChatGPT app, Claude Code, ...), không dùng cơ chế bọc API.**

Ứng dụng Windows viết bằng **Go**, giúp quản lý nhiều tài khoản, theo dõi quota và chuyển đổi tài khoản đang dùng trên các IDEs (**Antigravity, ChatGPT app, Claude Code, ...**) một cách linh hoạt, an toàn. Ứng dụng cung cấp giao diện desktop **Fyne** đồ họa trực quan, hiện đại, mang lại trải nghiệm Zero-Console mượt mà, cài đặt gọn sạch qua bộ cài Windows chính thức và tự động cập nhật nền.

Ứng dụng tích hợp toàn diện hệ thống **Chuyển Đổi Tài Khoản Tự Động (Autonomous Multi-Account Switcher & Failover Daemon)** với đường ống 3 giai đoạn nâng cao (v1.0.3.2) tích hợp bộ lọc chống nhảy tài khoản lặp (Anti-Thrashing Guard). Người dùng có thể linh hoạt chọn giữa chuyển tài khoản thủ công (bằng nút **Chuyển** trên GUI) và chuyển đổi tự động hoàn toàn (AutoSwitch). Khi bật chế độ Tự động, hệ thống tự động giám sát quota, phát hiện cạn kiệt tài nguyên, tự phục hồi thử lại trong bộ nhớ, sàng lọc ứng viên sạch và tự động chọn tài khoản dự phòng tối ưu nhất theo thuật toán **Burn-down Sorter** mà không làm gián đoạn dòng suy nghĩ công việc của lập trình viên.

## Tính năng nổi bật (Trải nghiệm người dùng)

- **Cửa sổ không viền mượt mà & Đóng ứng dụng an toàn:**
  - Điều khiển cửa sổ không viền bằng cơ chế gốc Windows (phản hồi ngay cú bấm đầu tiên, Aero Snap, kéo viền đổi kích thước và bo góc/viền tối Windows 11).
  - Đảm bảo dừng gọn gàng các tác vụ theo dõi nền và lưu toàn bộ tùy chọn cá nhân trước khi thoát hoàn toàn từ cửa sổ chính.
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
- **Thu nhỏ thẳng xuống Taskbar:** Thu gọn ứng dụng trực tiếp xuống thanh Taskbar (tự tạm dừng dải quote khi thu nhỏ) và khôi phục mượt mà không làm mất trạng thái phóng to.

## Cài đặt & Khởi chạy

### 1. Bản phát hành Windows chính thức (Bộ cài MSI)

Ứng dụng được phát hành chính thức qua GitHub Releases dưới dạng bộ cài Windows gắn phiên bản (`AS_Auto_Switcher_<version>-windows-amd64.msi`, ví dụ `AS_Auto_Switcher_1.5.7-windows-amd64.msi`):
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

## [Version 1.5.8] - 2026-11-26
- **Hộp thoại xác nhận khi đóng ứng dụng:** Bấm nút đóng (`X`) hoặc nhấn `Alt+F4` sẽ mở hộp thoại theo giao diện hiện tại để chọn **Thu nhỏ xuống Tray** hoặc **Tắt hoàn toàn** (nhấn `Esc` hoặc bấm ra ngoài để hủy); nút thu nhỏ (`-`) vẫn thu thẳng xuống thanh Taskbar.
- **Khay hệ thống động (Windows, macOS & Linux):** Biểu tượng khay hệ thống chỉ xuất hiện khi bạn thu nhỏ vào tray và tự ẩn ngay khi mở lại cửa sổ hoặc thoát, đi kèm menu **Mở Auto Switcher tool** / **Thoát**, tự tạm dừng dải quote khi ẩn và tăng độ ổn định khay hệ thống trên Linux.
- **Mở lại cửa sổ đang chạy từ tray:** Khởi chạy lại ứng dụng khi đã có phiên đang ẩn trong khay hệ thống hoặc thu nhỏ dưới Taskbar sẽ tự khôi phục cửa sổ sẵn có mà không làm mất trạng thái phóng to.
- **Hỗ trợ song ngữ Anh – Việt:** Hộp thoại đóng ứng dụng và menu khay hệ thống đồng bộ mượt theo chủ đề (Dark, Light, Warm) và ngôn ngữ đang chọn.
- **Gói cài đặt:** Windows (`AS_Auto_Switcher_1.5.8-windows-amd64.msi`), Linux (x64 / ARM64), macOS (Apple Silicon / Intel), script cài đặt và mã kiểm tra. Lưu ý: tính năng kết nối trực tiếp với ứng dụng desktop trên macOS đang chờ kiểm chứng trên máy Mac thật.

## [Version 1.5.7] - 2026-11-25
- **Cửa sổ Windows không viền mượt mà & bấm ăn ngay từ cú click đầu:** Kéo cửa sổ, đổi kích thước từ viền/góc, Windows Snap, phóng to/thu nhỏ và bo góc/viền tối Windows 11 nay dùng cơ chế gốc của Windows, giúp mọi nút phản hồi ngay ở cú bấm đầu tiên.
- **Thu nhỏ thẳng xuống Taskbar (bỏ hẳn khay hệ thống):** Bấm thu nhỏ sẽ giữ ứng dụng ngay trên thanh Taskbar, bấm đóng sẽ thoát gọn gàng, và mở lại ứng dụng sẽ khôi phục cửa sổ sẵn có mà không làm mất trạng thái phóng to.
- **Giao diện, tooltip & dải quote mượt hơn:** Tooltip khi di chuột không còn chặn cú bấm; thẻ tài khoản cập nhật mượt tại chỗ kết hợp lưu nền; dải quote tự tạm dừng khi thu nhỏ, không hoạt động hoặc đang kéo đổi kích thước.
- **Đồng bộ tên bộ cài Windows & lưu ý nâng cấp thủ công một lần:** Bộ cài Windows đổi sang tên chuẩn `AS_Auto_Switcher_1.5.7-windows-amd64.msi`. Người dùng Windows từ bản `1.5.6` trở xuống cần tải và cài tay bản `1.5.7` một lần (giữ nguyên toàn bộ tài khoản và thiết lập); từ bản `1.5.7` trở đi, ứng dụng sẽ tự động cập nhật mượt mà theo tên gói mới.
- **Gói cài đặt:** Windows (`AS_Auto_Switcher_1.5.7-windows-amd64.msi`), Linux (x64 / ARM64), macOS (Apple Silicon / Intel), script cài đặt và mã kiểm tra. Lưu ý: tính năng kết nối trực tiếp với ứng dụng desktop trên macOS đang chờ kiểm chứng trên máy Mac thật.

## [Version 1.5.6] - 2026-11-24
- **Chuyển tài khoản ngay khi gặp cảnh báo Điều khoản dịch vụ & hết hạn mức dài:** Tự động chuyển sang tài khoản dự phòng ngay khi gặp lỗi vi phạm Điều khoản dịch vụ (TOS) hoặc lỗi `429` hết hạn mức dài, vẫn giữ 3 lần thử lại cho lỗi `429` nghẽn tức thời và tránh quay lại tài khoản đang bị chặn.
- **Hiển thị cảnh báo `WARNING` đỏ đậm trên thẻ tài khoản:** Thẻ tài khoản bị cảnh báo hiển thị thêm dòng `WARNING` đỏ đậm ngay dưới bảng hạn mức, giữ nguyên toàn bộ các nút thao tác và tự giãn/co chiều cao thẻ mượt mà.
- **Đồng bộ trạng thái đăng nhập rõ ràng hơn:** Tài khoản gặp lỗi xác thực `401` tự động chuyển sang `[Cần OAuth]`; dòng cảnh báo được ẩn khi thẻ tắt hoặc cần đăng nhập lại.
- **Thẻ Antigravity gọn còn 2 hàng:** Toàn bộ các model Gemini hiện có được gom vào chung hàng `Gemini` giúp thẻ tài khoản gọn còn 2 hàng (`Gemini` và `Claude`), đồng thời vẫn giữ nguyên cơ chế tự động mở hàng riêng cho các model mới phát sinh trong tương lai.
- **Gói cài đặt:** Windows, Linux (x64 / ARM64), macOS (Apple Silicon / Intel), script cài đặt và mã kiểm tra. Lưu ý: tính năng kết nối trực tiếp với ứng dụng desktop trên macOS đang chờ kiểm chứng trên máy Mac thật.

## [Version 1.5.5] - 2026-11-23
- **Ghi chú phát hành dễ hiểu hơn:** Nhật ký thay đổi và lịch sử phiên bản trong README (tiếng Anh và tiếng Việt) được viết lại bằng ngôn ngữ đơn giản, tập trung vào những gì bạn thấy trong ứng dụng.
- **Không thay đổi tính năng** trong phiên bản này.
- **Gói cài đặt:** Windows, Linux (x64 / ARM64), macOS (Apple Silicon / Intel), script cài đặt và mã kiểm tra. Lưu ý: tính năng kết nối trực tiếp với ứng dụng desktop trên macOS đang chờ kiểm chứng trên máy Mac thật.

## [Version 1.5.4] - 2026-11-23
- **Nhãn "LOCKED" trên thẻ Antigravity hiển thị chính xác:** Mọi dòng quota (Gemini, Claude, Argon, Carbon) dùng chung một cách xét khóa, hiển thị giống nhau khi mở app và khi làm mới.
- **Sửa lỗi báo khóa sai:** Tài khoản PRO hết quota tuần Claude (0%) không còn bị báo khóa nhầm ở cột 5 giờ; Gemini 4 Carbon trên PRO chưa có quyền và Argon/Carbon trên FREE hiện đúng "-- | LOCKED"; dữ liệu cũ hiện "-- | --" thay vì khóa oan.
- **Gói cài đặt:** Windows, Linux (x64 / ARM64), macOS (Apple Silicon / Intel), script cài đặt và mã kiểm tra. Lưu ý: tính năng kết nối trực tiếp với ứng dụng desktop trên macOS đang chờ kiểm chứng trên máy Mac thật.

## [Version 1.5.3] - 2026-11-22
- **Tự động tiếp tục thông minh hơn:** Sau khi chuyển tài khoản Antigravity, chỉ tiếp tục các hội thoại đang chạy hoặc bị dừng do hết quota trong 5 phút gần nhất; hội thoại đã xong hoặc đã hủy không còn bị gửi nhầm "Continue...". Các tác vụ nhiều bước được tiếp tục đúng thứ tự.
- **Antigravity và Codex hoạt động độc lập:** Chức năng tự tiếp tục của hai bên tách riêng; Codex giữ nguyên cách hoạt động.
- **Gói cài đặt:** Windows, Linux, macOS, script cài đặt và mã kiểm tra.

## [Version 1.5.2] - 2026-11-22
- **Phát hành đầy đủ cho mọi hệ điều hành:** Mỗi bản phát hành có đủ gói Windows, Linux (x64 / ARM64) và macOS (Apple Silicon / Intel), kèm mã kiểm tra.
- **Script cài đặt đáng tin cậy hơn:** Kiểm tra gói trước khi tải trên Linux/macOS, tránh tải lỗi.
- **Ổn định hơn** khi cập nhật trên Windows, Linux và macOS.

## [Version 1.5.1] - 2026-11-22
- **Chuyển tài khoản ngay khi hết quota cá nhân**, không mất thời gian thử lại.
- **Mỗi hội thoại giữ đúng model của mình** khi thử lại và tự tiếp tục, không bị ép sang model mặc định.
- **Kiểm tra mọi hội thoại đang chạy** để model đang dùng bị cạn không bị che khuất, và ưu tiên tài khoản dự phòng hỗ trợ model cần dùng.

## [Version 1.5.0] - 2026-11-22
- **Quota & AutoSwitch chính xác hơn** cho Antigravity và Codex, phân biệt rõ hạn mức 5 giờ/tuần và tài khoản FREE/trả phí. AutoSwitch chờ thay vì tắt hẳn khi tài khoản dự phòng tạm thời chưa dùng được.
- **Cải tiến Codex:** Chuyển nhanh khi tài khoản cần đăng nhập lại, bỏ qua tài khoản lỗi, dừng an toàn khi hết tài khoản dự phòng.
- **Hỗ trợ macOS và Linux (bản thử nghiệm)** với lệnh cài đặt một dòng không cần quyền quản trị, và cập nhật an toàn hơn.

## [Version 1.4.11] - 2026-11-21
- **Hỗ trợ Antigravity 2.34.0 trở lên**, vẫn tương thích phiên bản cũ.
- **Nhận diện model mới** như Gemini 4 Neon và Gemini 3.8 Flash.
- **Tìm đúng model đang dùng** kể cả khi thiết lập lưu trong Antigravity đã cũ.

## [Version 1.4.10] - 2026-11-20
- **Dải quote gọn hơn:** Bỏ đường viền phía trên và làm dải mỏng hơn một chút, trên mọi giao diện và cả hai tab.

## [Version 1.4.9] - 2026-11-20
- **Quota 5 giờ + tuần chính xác hơn** cho Claude, và model vẫn được theo dõi sau khi đổi trong phiên.
- **Chế độ chờ dự phòng:** AutoSwitch vẫn bật và hiện thông báo song ngữ ở thanh đáy khi còn tài khoản dự phòng nhưng chưa dùng được. Sửa lỗi bố cục khi hiện thông báo và khi đổi ngôn ngữ.

## [Version 1.4.8] - 2026-11-19
- **Chọn tài khoản dự phòng thông minh hơn:** Chỉ chọn tài khoản hỗ trợ model đang dùng, ưu tiên gói cùng hạng hoặc cao hơn (ULTRA > PRO > FREE).
- **Nhận diện lỗi tốt hơn** với lỗi quota, thanh toán, quyền truy cập, và không chuyển đổi vô ích khi lỗi do yêu cầu. Tài khoản FREE không còn làm AutoSwitch bị treo; xử lý đầy đủ các tình huống chuyển đổi.

## [Version 1.4.7] - 2026-11-19
- **Gemini 4 Neon dùng chung dòng quota Gemini**, thẻ tài khoản gọn hơn; Gemini 4 Carbon vẫn có dòng riêng.

## [Version 1.4.6] - 2026-11-18
- **Quota thực tế cho tài khoản FREE:** Hiển thị đúng mức đã dùng, khớp với cài đặt trong Antigravity thay vì luôn 100%.

## [Version 1.4.5] - 2026-11-18
- **Mỗi lần một câu quote:** Dải quote chỉ chạy một câu tại một thời điểm, vẫn mượt khi đổi kích thước cửa sổ, đổi ngôn ngữ/giao diện hoặc thu xuống khay hệ thống.

## [Version 1.4.4] - 2026-11-18
- **Dải quote song ngữ:** 45 câu nói truyền cảm hứng tiếng Việt/tiếng Anh chạy phía trên thanh đáy, màu sắc theo giao diện, tự tạm dừng khi thu xuống khay hệ thống.

## [Version 1.4.3] - 2026-11-18
- **Trạng thái Codex trực tiếp** ở thanh đáy tab Codex, và hiển thị phiên bản ứng dụng trên cả hai tab.

## [Version 1.4.2] - 2026-11-18
- **Quota tuần cho tài khoản FREE** kèm thời gian làm mới 7 ngày cho Gemini và Claude.
- **Nhãn "Cần OAuth" gọn hơn** ở góc trên bên phải thẻ tài khoản.

## [Version 1.4.1] - 2026-11-18
- **Quota Gemini 4 Carbon cho tài khoản ULTRA**, hiển thị "--" cho model không khả dụng trên PRO/FREE, và AutoSwitch nhận diện đúng Carbon.

## [Version 1.4.0] - 2026-11-16
- **Phục hồi chat Codex:** Khi chuyển thủ công, các chat bị dừng do hết quota được nhận để tiếp tục, và hoạt động gần đây được nhận diện chính xác hơn.
- **Lưu ý:** Chuyển tài khoản và tự tiếp tục trên ứng dụng Desktop thật vẫn đang chờ kiểm chứng.

## [Version 1.3.9] - 2026-11-15
- **Một bộ cài Windows duy nhất gắn số phiên bản**, tự động cập nhật mà vẫn giữ tài khoản và thiết lập.
- **Nâng cấp thủ công một lần:** Người dùng bản 1.3.6–1.3.8 cần chạy bộ cài 1.3.9 một lần; các bản sau sẽ tự cập nhật.

## [Version 1.3.8] - 2026-11-14
- **Tự động cập nhật ổn định hơn:** Kiểm tra mỗi giờ, tự thử lại khi rớt mạng, bảo vệ khi mạng chậm, nhật ký gọn nhẹ không chứa thông tin cá nhân.

## [Version 1.3.7] - 2026-11-14
- **Cập nhật bản quyền, thương hiệu và tài liệu** cho các công cụ AI / IDE được hỗ trợ bằng tiếng Việt và tiếng Anh.

## [Version 1.3.6] - 2026-11-14
- **Tự động cập nhật** với nút Update một chạm trên thanh tiêu đề.
- **Logo CA mới** và nhóm hiển thị quota model rõ ràng hơn.

## [Version 1.3.5] - 2026-11-10
- **Bộ cài Windows chính thức & khay hệ thống**, gỡ cài đặt sạch, khôi phục cửa sổ nhanh.
- **Quản lý tài khoản Codex / ChatGPT Desktop**, chuyển đổi độc lập và tiếp tục phiên làm việc mượt mà.
- **Theo dõi quota Antigravity tốt hơn** với thời gian làm mới theo tuần và dự phòng ổn định hơn.
