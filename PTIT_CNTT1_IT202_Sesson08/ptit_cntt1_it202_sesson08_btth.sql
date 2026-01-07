create database ptit_cntt1_it202_sesson08_BTTH;

use ptit_cntt1_it202_sesson08_BTTH;


create table customer (
	customer_id int auto_increment primary key,
    customer_name varchar(255) not null,
    email varchar(255) not null unique,
    phone varchar(20) not null unique
);

create table categories (
	category_id int auto_increment primary key,
    category_name varchar(255) not null unique
);

create table products (
	product_id int auto_increment primary key,
    product_name varchar(255) Not null Unique,
    price decimal(10,2) not null check(price > 0),
    category_id int not null,
    foreign key(category_id) references categories (category_id)
);


create table orders (
	order_id int auto_increment primary key,
    customer_id int not null,
    order_date date default(current_date()),
    status enum('Pending', 'Completed', 'Cancel') default 'Pending'
);

create table order_items (
	order_item_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int not null check(quantity > 0),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products (product_id)
);

-- Insert du lieu
insert into customer (customer_name, email, phone) values 
('Nguyễn Văn An', 'an.nguyen@gmail.com', '0901000001'),
('Trần Thị Bình', 'binh.tran@gmail.com', '0901000002'),
('Lê Văn Cường', 'cuong.le@gmail.com', '0901000003'),
('Phạm Thị Dung', 'dung.pham@gmail.com', '0901000004'),
('Hoàng Văn Em', 'em.hoang@gmail.com', '0901000005'),
('Vũ Thị Hoa', 'hoa.vu@gmail.com', '0901000006'),
('Đỗ Văn Khánh', 'khanh.do@gmail.com', '0901000007'),
('Bùi Thị Lan', 'lan.bui@gmail.com', '0901000008');

insert into categories (category_name) values
('Điện thoại'),
('Laptop'),
('Phụ kiện'),
('Gia dụng'),
('Thời trang');


insert into products (product_name, price, category_id) values
('iPhone 15', 25000000, 1),
('Samsung Galaxy S23', 22000000, 1),
('MacBook Air M2', 28000000, 2),
('Dell XPS 13', 26000000, 2),
('Tai nghe AirPods', 4500000, 3),
('Chuột Logitech', 1200000, 3),
('Nồi chiên không dầu', 3500000, 4),
('Áo thun nam', 250000, 5);

insert into orders (customer_id, order_date, status) values
(1, '2025-01-05', 'Completed'), -- 1
(2, '2025-01-06', 'Pending'), -- 2
(3, '2025-01-07', 'Completed'), -- 3
(4, '2025-01-08', 'Cancel'), -- 4
(5, '2025-01-09', 'Completed'), -- 5
(6, '2025-01-10', 'Pending'), -- 6
(7, '2025-01-11', 'Completed'), -- 7
(8, '2025-01-12', 'Pending'), -- 8
(1, '2025-01-05', 'Completed'), -- 9
(2, '2025-01-06', 'Pending'), -- 10
(3, '2025-01-07', 'Completed'), -- 11
(4, '2025-01-08', 'Cancel'); -- 12


insert into order_items (order_id, product_id, quantity) values
(1, 1, 1),
(1, 5, 2),
(2, 3, 3),
(3, 2, 1),
(4, 8, 3),
(5, 4, 1),
(6, 6, 2),
(7, 2, 4);



-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN

-- Lấy danh sách tất cả danh mục sản phẩm trong hệ thống.
select * from categories;

-- Lấy danh sách đơn hàng có trạng thái là COMPLETED
select * from orders where status = 'completed';

-- Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
select * from products order by price desc;

-- Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
select * from products order by price desc limit 5 offset 2;



-- PHẦN B – TRUY VẤN NÂNG CAO
-- Lấy danh sách sản phẩm kèm tên danh mục
select p.product_id, p.product_name, p.price, c.category_name from products p
join categories c on c.category_id = p.category_id;

-- Lấy danh sách đơn hàng gồm: order_id, order_date, customer_name, status
select o.order_id, o.order_date, c.customer_name, o.status from customer c
join orders o on c.customer_id = o.customer_id;

-- Tính tổng số lượng sản phẩm trong từng đơn hàng
select o.order_id, sum(oi.quantity) as total_quantity from order_items oi 
join orders o on o.order_id = oi.order_id group by o.order_id;

-- Thống kê số đơn hàng của mỗi khách hàng
select c.customer_id, c.customer_name, count(order_id) from orders o
join customer c on c.customer_id = o.customer_id group by o.customer_id;

-- Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2
select c.customer_id, c.customer_name, count(order_id) from orders o
join customer c on c.customer_id = o.customer_id group by o.customer_id having count(order_id) >= 2;

-- Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục
select c.category_id, c.category_name, avg(price), max(price), min(price) from products p 
join categories c on c.category_id = p.category_id group by category_id, category_name;


-- PHẦN C – TRUY VẤN LỒNG (SUBQUERY) 

-- Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select * from products p where price > (select avg(price) from products);

-- Lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng
select * from customer c where c.customer_id in (select customer_id from orders);

-- Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất.
select order_id, order_date from orders o 
where order_id in (select order_id from order_items group by order_id 
having sum(quantity) = (select sum(quantity) from order_items group by order_id order by sum(quantity) desc limit 1 ));


-- Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
-- Danh muc co gia trungbinh cao nhat
select customer_name from customer where customer_id in (
select customer_id from orders where order_id in (
select order_id from order_items where product_id in (
select product_id from products where category_id = (
select category_id from products group by category_id order by avg(price) desc limit 1)
		)
	)
);

-- Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
select o.customer_id, (
	select sum(oi.quantity)
	from order_items oi
	where oi.order_id IN (
		select o2.order_id
		from orders o2
		where o2.customer_id = o.customer_id
	)
) as total_item
from orders o
group by o.customer_id
order by total_item desc;

-- Viết lại truy vấn lấy sản phẩm có giá cao nhất
select * from products where price = (select max(price) from products);
 
