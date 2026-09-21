-- HỆ THỐNG PAYFLOW (OPTIMIZED SCRIPT)
CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. Tạo bảng Transactions (cấu trúc chuẩn)
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- ========================================================
-- PHẦN 1: TẠO COMPOSITE INDEX TỐI ƯU
-- ========================================================
-- Đặt transaction_type lên trước vì là phép so sánh bằng (=) có tính lọc cao,
-- created_at đặt sau để phục vụ truy vấn khoảng (Range Search).
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- ========================================================
-- PHẦN 2: TRUY VẤN ĐÃ TỐI ƯU (SARGable Query)
-- ========================================================
-- Sử dụng toán tử so sánh khoảng >= và < thay cho các hàm YEAR() / MONTH()
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at <  '2026-07-01 00:00:00';