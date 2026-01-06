create database ptit_cntt1_it202_sesson06_bt01;

use ptit_cntt1_it202_sesson06_bt01;

create table customer(
	customer_id int auto_increment primary key,
    full_name varchar(255) not null,
	city varchar(255)
);

create table orders(
	order_id INT auto_increment primary key,
	customer_id INT,
	order_date DATE default(current_date()),
	foreign key (customer_id) references customer (customer_id),
	status ENUM('pending', 'completed', 'cancelled')
);

-- Thêm dữ liệu vào bảng customers tối thiếu 5 dữ liệu
insert into customer (full_name, city) values 
('Nguyễn Văn An', 'Hà Nội'),
('Trần Thị Bình', 'TP. Hồ Chí Minh'),
('Lê Quốc Cường', 'Đà Nẵng'),
('Phạm Minh Đức', 'Hải Phòng'),
('Hoàng Thu Hà', 'Cần Thơ'),
('Vũ Anh Huy', 'Bắc Ninh'),
('Đặng Thị Lan', 'Nam Định'),
('Bùi Quang Long', 'Quảng Ninh');

-- Thêm dữ liệu vào bảng orders tối thiểu 5 dữ liệud
insert into orders (customer_id, order_date, status) values 
(2, '2025-01-06', 'pending'),
(3, '2025-01-07', 'completed'),
(1, '2025-01-08', 'cancelled'),
(4, '2025-01-08', 'completed'),
(3, '2025-01-09', 'pending'),
(2, '2025-01-01', 'completed'),
(3, '2025-01-10', 'pending'),
(1, '2025-01-11', 'completed'),
(3, '2025-01-11', 'cancelled'),
(1, '2025-01-12', 'completed'),
(2, '2025-01-12', 'pending');


-- BAI 1:
-- Viết các câu truy vấn SQL:
	-- Hiển thị danh sách đơn hàng kèm tên khách hàng
select order_id as 'Ma don hang', order_date as 'Ngay dat hang', status as 'Trang thai don hang', full_name as 'Ten khach hang' 
from orders join customer on orders.customer_id = customer.customer_id;
-- Hiển thị mỗi khách hàng đã đặt bao nhiêu đơn hàng
select full_name as 'Khach hang', count(ord.order_id) as 'So don hang' 
from orders ord right join customer c on ord.customer_id = c.customer_id
group by c.customer_id; 
	-- truy van long
    

	-- Chỉ hiển thị các khách hàng có ít nhất 1 đơn hàng
select c.customer_id as 'Ma khach hang', full_name as 'Khach hang', c.city as 'Thanh pho', count(ord.order_id) as 'So don hang' 
from orders ord right join customer c on ord.customer_id = c.customer_id
group by c.customer_id, c.full_name
having count(ord.order_id) >= 1; 


-- BAI 2:
alter table orders add total_amount decimal(10,2); -- Tổng tiền đơn
-- Viết SQL các câu lệnh DML:
-- Sửa lại thông tin dữ liệu trong bảng thêm dữ liệu cho mỗi orders có thêm dữ liệu của trường dữ liệu ở cột total_amount
update orders set total_amount = 12000000 where order_id = 23;
update orders set total_amount = 2000000 where order_id = 24;
update orders set total_amount = 150000 where order_id = 25;
update orders set total_amount = 2000000 where order_id = 26;
update orders set total_amount = 4000000 where order_id = 27;
update orders set total_amount = 16000000 where order_id = 28;
update orders set total_amount = 21000000 where order_id = 29;
update orders set total_amount = 280000 where order_id = 30;
update orders set total_amount = 15000000 where order_id = 31;
update orders set total_amount = 21000000 where order_id = 32;
update orders set total_amount = 280000 where order_id = 33;
update orders set total_amount = 15000000 where order_id = 34;
select * from orders;

-- Bai 2:
-- Viết SQL truy vấn:
-- Hiển thị tổng tiền mà mỗi khách hàng đã chi tiêu
select c.customer_id as 'Ma khach hang', c.full_name as 'Khach hang', sum(total_amount) as 'Tong tien hang'
from orders ord left join customer c on ord.customer_id = c.customer_id group by c.customer_id having sum(total_amount);

-- Hiển thị giá trị đơn hàng cao nhất của từng khách
select c.customer_id as 'Ma khach hang', c.full_name as 'Khach hang', max(ord.total_amount) as 'Don hang lon nhat'
from orders ord left join customer c on ord.customer_id = c.customer_id group by c.customer_id; 

-- Sắp xếp danh sách khách hàng theo tổng tiền giảm dần
select c.customer_id as 'Ma khach hang', c.full_name as 'Khach hang', c.city as 'Dia chi', sum(total_amount) as 'Tong tien hang'
from customer c left join orders ord on ord.customer_id = c.customer_id group by c.customer_id having sum(total_amount) order by sum(total_amount) desc;



-- Bai 3: Viết SQL truy vấn:
-- Tính tổng doanh thu theo từng ngày
select ord.order_date as 'Ngay dat hang', sum(total_amount) as 'Doanh thu'
from orders ord group by ord.order_date having sum(total_amount);

-- Tính số lượng đơn hàng theo từng ngày
select ord.order_date as 'Ngay dat hang', count(order_id) as 'So don'
from orders ord group by ord.order_date;

-- Chỉ hiển thị các ngày có doanh thu > 10.000.000
select ord.order_date as 'Ngay dat hang', sum(total_amount) as 'Doanh thu'
from orders ord group by ord.order_date having sum(total_amount) > 10000000;



-- Bai 4:
-- Tạo 2 bảng với thông tin ở trên
-- Tạo liên kết giữa các bảng
create table products(
	product_id int auto_increment primary key,
    product_name varchar(255) not null,
    price decimal(10, 2)
);

create table order_items(
	order_id int,
    product_id int,
    quantity int not null,
    foreign key (order_id) references orders (order_id),
    foreign key (product_id) references products (product_id)
);

-- Thêm dữ liệu cho 2 bảng mỗi bảng tối thiểu 5 dữ liệu mẫu
insert into products (product_name, price) values
('Laptop Asus Vivobook', 12000000.00), -- id 1
('Điện thoại Samsung A15', 4000000.00), -- id 2
('Tai nghe Bluetooth', 2000000.00), -- id 3
('Chuột không dây', 150000.00), -- id 4
('Màn hình LG 24 inch', 8000000.00), -- id 5
('Bàn phím cơ', 280000.00), -- id 6
('Laptop Dell XPS', 21000000.00),  -- id 7
('iPad Gen 9', 16000000.00); -- id 8

insert into order_items (order_id, product_id, quantity) values
(23, 1, 1), -- Laptop Asus
(24, 3, 1), -- Tai nghe
(25, 4, 1), -- Chuột
(26, 3, 1), -- Tai nghe
(27, 2, 1), -- Samsung A15
(28, 8, 1), -- iPad Gen 9
(29, 7, 1), -- Laptop Dell XPS
(30, 6, 1), -- Bàn phím cơ
(31, 1, 1), -- Laptop Asus (12tr)
(31, 3, 1), -- Tai nghe (2tr)
(31, 4, 1), -- Chuột (150k)
(32, 7, 1), -- Laptop Dell XPS
(33, 6, 1); -- Bàn phím cơ

-- Hiển thị mỗi sản phẩm đã bán được bao nhiêu sản phẩm
select p.product_id, p.product_name, count(quantity) 
from order_items ord_it join products p on ord_it.product_id = p.product_id group by product_id;
-- Tính doanh thu của từng sản phẩm
select p.product_id as 'Ma sản phẩm', p.product_name as 'Sản phẩm', count(quantity) as 'Số lượng', (count(quantity) * p.price) as 'Doanh thu'
from order_items ord_it join products p on ord_it.product_id = p.product_id group by p.product_id;
-- Chỉ hiển thị các sản phẩm có doanh thu > 5.000.000
select p.product_id as 'Ma sản phẩm', p.product_name as 'Sản phẩm', count(quantity) as 'Số lượng', (count(quantity) * p.price) as 'Doanh thu'
from order_items ord_it join products p on ord_it.product_id = p.product_id group by p.product_id having `Doanh thu` > 5000000;


-- Bai 5:
-- Tổng số đơn hàng của mỗi khách
select c.customer_id as 'Mã khách hàng', c.full_name as 'Khách hàng', c.city as 'Địa chỉ', count(order_id) as 'Số đơn hàng'
from customer c join orders ord on c.customer_id = ord.customer_id group by c.customer_id;

-- Tổng số tiền đã chi
select c.customer_id, c.full_name, c.city, sum(p.price * ord_it.quantity) as 'Tổng tiền chi'
from customer c join orders ord on c.customer_id = ord.customer_id
join order_items ord_it on ord.order_id = ord_it.order_id
join products p on ord_it.product_id = p.product_id
group by c.customer_id, c.full_name;

-- Giá trị đơn hàng trung bình
select c.customer_id as 'Mã khách hàng', c.full_name as 'Khách hàng', c.city as 'Địa chỉ', sum(p.price * ord_it.quantity) as 'Tổng tiền chi', count(ord.order_id) as 'Số đơn hàng', sum(p.price * ord_it.quantity)/count(ord.order_id) as 'Giá trị đơn hàng trung bình'
from customer c join orders ord on c.customer_id = ord.customer_id
join order_items ord_it on ord.order_id = ord_it.order_id
join products p on ord_it.product_id = p.product_id
group by c.customer_id, c.full_name;



-- Bai 6:
-- Hiển thị: Tên sản phẩm -- Tổng số lượng bán, Tổng doanh thu, Giá bán trung bình
select p.product_name as 'Tên sản phẩm', sum(ord_it.quantity) as 'Tổng số lượng bán',sum(ord_it.quantity * p.price) as 'Tổng doanh thu', avg(p.price) as 'Giá bán trung bình'
from products p
join order_items ord_it on p.product_id = ord_it.product_id
group by p.product_id, p.product_name
having sum(oi.quantity) >= 10
order by sum(oi.quantity * p.price) desc
limit 5;
