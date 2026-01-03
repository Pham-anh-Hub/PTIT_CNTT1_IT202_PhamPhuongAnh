create database ptit_cntt1_it202_sesson05_products;
use ptit_cntt1_it202_sesson05_products;

create table products(
	product_id int auto_increment primary key,
    product_name varchar(255) not null,
    price decimal(10,2) ,
    stock int ,
    status enum('active','inactive')
);
delete from products;
insert into products(product_name, price, stock, status, sold_quantity) values 
('Bút bi', 5000, 100, 'active', 30),
('Áo dài', 2080000, 3, 'inactive', 1),
('Vở viết', 7000, 10, 'inactive', 5),
('Cặp sách', 1500000, 20, 'active', 12),
('Vòng tay', 1000, 20, 'active', 8),
('Bút chì', 3000, 200, 'active', 60),
('Thước kẻ', 4000, 150, 'active', 45),
('Tẩy', 2000, 180, 'active', 70),
('Ba lô', 3200000, 15, 'active', 5),
('Áo thun', 1200000, 50, 'active', 20),
('Mũ lưỡi trai', 80000, 40, 'inactive', 10),
('Giày thể thao', 5500000, 10, 'active', 4),
('Khăn quàng', 60000, 25, 'inactive', 6),
('Sổ tay', 25000, 90, 'active', 35),
('Bình nước', 900000, 30, 'active', 18);

alter table products add sold_quantity int;

-- Bài 1
-- Lấy toàn bộ sản phẩm đang có trong hệ thống
select * from products;
-- Lấy danh sách sản phẩm đang bán (status = 'active')
select * from products where status = 'active';
-- Lấy các sản phẩm có giá lớn hơn 1.000.000
select * from products where price > 1000000;
-- Hiển thị danh sách sản phẩm đang bán, sắp xếp theo giá tăng dần
select * from products order by price asc;

-- Bài 4
-- Lấy 10 sản phẩm bán chạy nhất
select * from products order by sold_quantity desc limit 10 offset 0;
-- Lấy 5 sản phẩm bán chạy tiếp theo (bỏ qua 10 sản phẩm đầu)
select * from products order by sold_quantity desc limit 5 offset 10;
-- Hiển thị danh sách sản phẩm giá < 2.000.000, sắp xếp theo số lượng bán giảm dần
select * from products where price < 2000000 order by sold_quantity desc;


-- Bai 6
-- Tìm các sản phẩm:
-- 		Đang bán (status = 'active')
select * from products where status = 'active';
-- 		Giá từ 1.000.000 đến 3.000.000
select * from products where price >= 1000000 and price <= 3000000;
-- 		Sắp xếp theo giá tăng dần
select * from products order by price asc;
-- Hiển thị 10 sản phẩm mỗi trang
-- Viết truy vấn cho:
-- Trang 1
select * from products limit 10 offset 0;
-- Trang 2
select * from products limit 10 offset 10;