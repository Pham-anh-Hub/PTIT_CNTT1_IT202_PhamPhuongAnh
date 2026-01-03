create database ptit_cntt1_it202_sesson05_orders;
use ptit_cntt1_it202_sesson05_orders;

create table orders(
	order_id int auto_increment primary key,
    customer_id int,
    total_amount decimal(10, 2),
    order_date date default(current_date()),
	status enum('pending', 'completed', 'cancelled')
);

insert into orders (customer_id, total_amount, order_date, status) values 
(1, 1500000.00, '2025-01-05', 'completed'),
(2, 230000.50,  '2025-01-06', 'pending'),
(3, 780000.00,  '2025-01-06', 'completed'),
(1, 125000.00,  '2025-01-07', 'cancelled'),
(4, 990000.99,  '2025-01-08', 'completed'),
(5, 450000.00,  '2025-01-08', 'pending');

-- Bai 3
-- Lấy danh sách đơn hàng đã hoàn thành
select * from orders where status = 'completed';
-- Lấy các đơn hàng có tổng tiền > 5.000.000
select * from orders where total_amount > 5000000;
-- Hiển thị 5 đơn hàng mới nhất
select * from orders order by order_date desc limit 5 offset 0;
-- Hiển thị các đơn hàng đã hoàn thành, sắp xếp theo tổng tiền giảm dần
select * from orders where status = 'completed' order by total_amount desc;

-- Bai 5
-- Trang 1: hiển thị 5 đơn hàng mới nhất
select * from orders order by order_date desc limit 5 offset 0;
-- Trang 2: hiển thị 5 đơn hàng tiếp theo
select * from orders order by order_date desc limit 5 offset 5;
-- Trang 3: hiển thị 5 đơn hàng tiếp theo
select * from orders order by order_date desc limit 5 offset 10;
-- Chỉ hiển thị các đơn hàng chưa bị hủy
select * from orders where status <> 'cancelled';