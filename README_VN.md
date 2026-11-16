# AS Auto Switcher - **Version 1.4.0**

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
