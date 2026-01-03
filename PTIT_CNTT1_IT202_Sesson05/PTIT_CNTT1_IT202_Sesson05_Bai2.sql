create database ptit_cntt1_it202_sesson05_customer;

use ptit_cntt1_it202_sesson05_customer;

create table customer(
	 customer_id INT auto_increment primary key,
     full_name VARCHAR(255) not null,
     email VARCHAR(255) unique,
     city VARCHAR(255),
     status ENUM( 'active', 'inactive')
);

insert into customer (full_name, email, city, status) values 
('Nguyễn Văn An', 'an.nguyen@gmail.com', 'Hà Nội', 'active'),
('Trần Thị Bình', 'binh.tran@gmail.com', 'Hồ Chí Minh', 'inactive'),
('Lê Văn Cường', 'cuong.le@gmail.com', 'Đà Nẵng', 'active'),
('Phạm Thị Dung', 'dung.pham@gmail.com', 'Hải Phòng', 'active'),
('Hoàng Minh Đức', 'duc.hoang@gmail.com', 'Cần Thơ', 'inactive');

-- Lấy danh sách tất cả khách hàng
select * from customer;
-- Lấy khách hàng ở TP.HCM
select * from customer where city = 'Hồ Chí Minh';
-- Lấy khách hàng đang hoạt động và ở Hà Nội
select * from customer where city = 'Hà Nội' and status = 'active';
-- Sắp xếp danh sách khách hàng theo tên (A → Z)
select * from customer order by full_name asc;
