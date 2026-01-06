create database ptit_cntt1_it202_Sesson07;

use ptit_cntt1_it202_Sesson07;

create table customer(
	customer_id int auto_increment primary key,
	name varchar(255),
	email varchar(255) unique
);

-- Bai 1
create table orders(
	order_id int auto_increment primary key,
	customer_id int,
	order_date date default(current_date()),
    foreign key (customer_id) references customer (customer_id),
	total_amount decimal(10, 2)
);

insert into customer (name, email) values
('Nguyen Van An', 'an.nguyen@gmail.com'),
('Tran Thi Binh', 'binh.tran@gmail.com'),
('Le Hoang Cuong', 'cuong.le@gmail.com'),
('Pham Minh Duc', 'duc.pham@gmail.com'),
('Vo Thi Em', 'em.vo@gmail.com'),
('Do Thanh Hai', 'hai.do@gmail.com'),
('Bui Quoc Khang', 'khang.bui@gmail.com');

insert into orders (order_id, customer_id, order_date, total_amount) values 
(101, 1, '2024-01-05', 1500000),
(102, 2, '2024-01-10', 2300000),
(103, 1, '2024-02-01',  980000),
(104, 3, '2024-02-15', 3200000),
(105, 4, '2024-03-03', 1250000),
(106, 3, '2024-03-18', 2750000),
(107, 5, '2024-04-01',  890000);


-- Lấy danh sách khách hàng đã từng đặt đơn hàng
select customer_id, name, email from customer where customer_id in 
(select customer_id from orders);



-- Bai 2:
create table products(
	id int auto_increment primary key,
	name varchar(255),
	price decimal(10,2)
);

create table order_items(
	order_id int,
	id int, 
	quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (id) references products (id)
);

insert into products (name, price) values 
('Laptop Dell Inspiron', 1500.00),
('Laptop HP Pavilion', 1400.00),
('Chuột Logitech M331', 25.50),
('Bàn phím cơ Keychron K2', 89.99),
('Màn hình LG 24 inch', 210.00),
('Tai nghe Sony WH-1000XM4', 320.00),
('USB Sandisk 64GB', 15.00);

insert into order_items (order_id, id, quantity) values
(101, 1, 1), -- 1 Laptop Dell
(101, 3, 2), -- 2 Chuột
(102, 2, 1), -- 1 Laptop HP
(102, 4, 1), -- 1 Bàn phím
(103, 6, 2), -- 2 Màn hình
(103, 1, 3), -- 3 USB
(104, 6, 1), -- 1 Tai nghe
(105, 3, 1), -- 1 Chuột
(105, 4, 2); -- 2 USB 

select * from products;

-- Lấy danh sách sản phẩm đã từng được bán
select id, name, price from products where id in (select id from order_items);


-- Lấy danh sách đơn hàng có giá trị lớn hơn giá trị trung bình của tất cả đơn hàng
select order_id, customer_id, order_date, total_amount from orders where total_amount > (select avg(total_amount) from orders);


-- Hiển thị tên khách hàng, số lượng đơn hàng của từng khách
select name, (select count(*) from orders o where o.customer_id = customer.customer_id) as 'So luong don' from customer;


-- Tìm khách hàng có tổng số tiền mua hàng lớn nhất
select customer_id, name, email from customer where customer_id = (select customer_id from orders o group by customer_id order by sum(total_amount) desc limit 1);

-- Lấy danh sách khách hàng có tổng tiền mua hàng lớn hơn tổng tiền trung bình của tất cả khách hàng
select c.customer_id, c.name, c.email from customer c where customer_id in(
select customer_id from orders ord group by ord.customer_id having sum(ord.total_amount) > 
(select avg(total_order) from 
(select sum(ord.total_amount) as total_order from orders ord group by ord.customer_id) t ));





