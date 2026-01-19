create database quanlybanhang;
use quanlybanhang;

-- Bảng Customers (Khách hàng) : Lưu thông tin về khách hàng
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255)
);
-- Products (Sản phẩm) : Lưu thông tin sản phẩm
create table products (
	product_id int auto_increment primary key,
    product_name varchar(100) not null unique,
    price decimal(10,2) not null,
	quantity int not null check(quantity >= 0),
	category varchar(50) not null
);

-- Bảng Employees (Nhân viên): Lưu thông tin nhân viên
create table employees (
	employee_id int auto_increment primary key,
	employee_name varchar(100) not null,
	birthday_date date,
	position varchar(50) not null,
	salary decimal(10,2) not null,
	revenue decimal(10,2) default(0)
);

-- Bảng Orders (Đơn hàng): Lưu thông tin đơn hàng
create table orders (
	order_id int auto_increment primary key,
    customer_id int, 
    employee_id int,
    order_date datetime default(current_timestamp()),
    total_amount decimal(10, 2) default 0,
    foreign key (customer_id) references customers(customer_id),
    foreign key (employee_id) references employees(employee_id)
);

-- Bảng OrderDetails (Chi tiết đơn hàng) : Lưu thông tin chi tiết về đơn hàng
create table OrderDetails (
	order_detail_id int auto_increment primary key,
    order_id int ,
    product_id int,
    quantity int not null check (quantity > 0),
    unit_price decimal(10, 2) not null,
    foreign key (order_id) references orders(order_id), 
    foreign key (product_id) references products (product_id)
);


-- Câu 3 - Chỉnh sửa cấu trúc bảng
-- 3.1 Thêm cột email có kiểu dữ liệu varchar(100) not null unique vào bảng Customers
alter table customers add column email varchar(100) not null unique;
-- 3.2 Xóa cột ngày sinh ra khỏi bảng Employees
alter table employees drop column birthday_date;


-- PHẦN 2: TRUY VẤN DỮ LIỆU
-- Câu 4 - Chèn dữ liệu
-- Viết câu lệnh chèn dữ liệu vào bảng (mỗi bảng ít nhất 5 bản ghi phù hợp)
insert into customers (customer_name, phone, email, address) values
('Nguyễn Văn An', '0901000001', 'an.nguyen@gmail.com', 'Hà Nội'),
('Trần Thị Bình', '0901000002', 'binh.tran@gmail.com', 'Hải Phòng'),
('Lê Văn Cường', '0901000003', 'cuong.le@gmail.com', 'Đà Nẵng'),
('Phạm Thị Dung', '0901000004', 'dung.pham@gmail.com', 'Thành phố Hồ Chí Minh'),
('Hoàng Văn Em', '0901000005', 'em.hoang@gmail.com', 'Cần Thơ'),
('Vũ Thị Phương', '0901000006', 'phuong.vu@gmail.com', 'Nam Định'),
('Đỗ Văn Giang', '0901000007', 'giang.do@gmail.com', 'Thái Bình'),
('Bùi Thị Hạnh', '0901000008', 'hanh.bui@gmail.com', 'Bắc Ninh');

insert into products (product_name, price, quantity, category) values
('Laptop Dell', 15000000, 20, 'Điện tử'),
('iPhone 13', 18000000, 15, 'Điện tử'),
('Tai nghe Bluetooth', 800000, 50, 'Phụ kiện'),
('Bàn phím cơ', 1200000, 30, 'Phụ kiện'),
('Chuột không dây', 600000, 40, 'Phụ kiện'),
('Màn hình LG', 4500000, 25, 'Điện tử'),
('USB 64GB', 300000, 100, 'Lưu trữ'),
('SSD 512GB', 2200000, 35, 'Lưu trữ');

alter table employees add column birthday_date date after employee_name;
insert into employees (employee_name, birthday_date, position, salary, revenue) values
('Nguyễn Thị Lan', '1995-05-12', 'Bán hàng', 8000000, 0),
('Trần Văn Minh', '1992-03-20', 'Bán hàng', 8500000, 0),
('Lê Quang Huy', '1990-11-02', 'Quản lý', 15000000, 0),
('Phạm Thị Hoa', '1998-07-15', 'Bán hàng', 7800000, 0),
('Đoàn Văn Nam', '1994-09-10', 'Kho', 7000000, 0),
('Bùi Thị Yến', '1996-12-05', 'Kế toán', 9000000, 0),
('Hoàng Văn Long', '1989-01-25', 'Quản lý', 16000000, 0),
('Vũ Thị Mai', '1997-06-18', 'Bán hàng', 8200000, 0);

insert into orders (customer_id, employee_id, total_amount) values
(1, 1, 15800000),
(2, 2, 18000000),
(1, 4, 2000000),
(4, 1, 5100000),
(6, 8, 300000),
(3, 2, 2200000),
(7, 4, 1200000),
(2, 1, 600000);

insert into orderdetails (order_id, product_id, quantity, unit_price) values
(1, 1, 1, 15000000),
(1, 3, 1, 800000),
(2, 2, 1, 18000000),
(3, 4, 1, 1200000),
(3, 5, 1, 800000),
(4, 6, 1, 4500000),
(4, 7, 2, 300000),
(5, 7, 1, 300000),
(6, 8, 1, 2200000),
(7, 4, 1, 1200000),
(8, 5, 1, 600000);


-- Câu 5 - Truy vấn cơ bản
-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách
-- hàng, tên khách hàng, email, số điện thoại và địa chỉ
select customer_id, customer_name, email, phone, address from customers;

-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name=
-- “Laptop Dell XPS” và price = 99.99
update products set product_name = 'Laptop Dell XPS', price = 99.99 where product_id = 1;

-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân
-- viên, tổng tiền và ngày đặt hàng.
select order_id, customer_name, employee_name, total_amount, order_date from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id;



-- Câu 6 - Truy vấn đầy đủ
-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên
-- khách hàng, tổng số đơn
select c.customer_id, c.customer_name, count(o.order_id) from orders o 
join customers c on c.customer_id = o.customer_id group by customer_id;
-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm :
-- mã nhân viên, tên nhân viên, doanh thu
select e.employee_id, e.employee_name, sum(total_amount) as total_revenue from employees e
left join orders o on e.employee_id = o.employee_id group by employee_id;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại.
-- Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng
-- giảm dần
select p.product_id, p.product_name, sum(od.quantity) as 'Số lượng đặt' from orderdetails od
join products p on od.product_id = p.product_id
join orders o on od.order_id = o.order_id where month(o.order_date) = month(current_date()) group by product_id having sum(od.quantity) > 0 order by sum(od.quantity) desc;




-- Câu 7 - Truy vấn nâng cao
-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và
-- tên khách hàng
select customer_id, customer_name from customers where customer_id not in (select customer_id from orders);

-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select * from products where price > (select avg(price) from products);

-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. Thông tin gồm : mã khách hàng,
-- tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)
select c.customer_id, c.customer_name, sum(total_amount) as total_amount from orders o
join customers c on c.customer_id = o.customer_id group by c.customer_id, c.customer_name having total_amount = (
select sum(total_amount) from orders o
join customers c on c.customer_id = o.customer_id group by c.customer_id, c.customer_name order by sum(total_amount) desc limit 1);




-- Câu 8 - Tạo view
-- 8.1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng,
-- tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. Các bản ghi sắp xếp theo thứ tự
-- ngày đặt mới nhất
create or replace view view_order_list as select order_id, customer_name, employee_name, total_amount, order_date
from orders o join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id order by order_date desc;
select * from view_order_list;

-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã
-- chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. Thông tin sắp xếp
-- theo số lượng giảm dần
create or replace view view_order_detail_product as select order_detail_id, product_name, od.quantity, unit_price
from orderdetails od join orders o on od.order_id = o.order_id
join products p on p.product_id = od.product_id order by od.quantity desc;
select * from view_order_detail_product;





-- Câu 9 - Tạo thủ tục lưu trữ
-- 9.1 Tạo thủ tục có tên proc_insert_employee nhận vào các thông tin cần thiết (trừ mã
-- nhân viên và tổng doanh thu) , thực hiện thêm mới dữ liệu vào bảng nhân viên và trả
-- về mã nhân viên vừa mới thêm.
delimiter //
create procedure proc_insert_employee (
	p_employee_name varchar(100),
    p_birthday date,
	p_position varchar(50),
	p_salary decimal(10,2)
)
begin 
	insert into employees (employee_name, birthday_date, position, salary) values
    (p_employee_name, p_birthday, p_position, p_salary);
    select * from employees order by employee_id desc limit 1;
end //
delimiter ;

-- Test
call proc_insert_employee('Phạm Minh Quân', '2025-01-22', 'Quản lý', 12000000);
drop procedure if exists proc_insert_employee;

-- 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo
-- mã đặt hàng.
delimiter //
create procedure proc_get_orderdetails (
	p_order_id int
)
begin
	select * from orderdetails where order_id = p_order_id;
end //
delimiter ;
-- Test
call proc_get_orderdetails(1);

-- 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã
-- đơn hàng và trả về số lượng loại sản phẩm trong đơn hàng đó.
delimiter //
create procedure proc_cal_total_amount_by_order (
	p_order_id int
)
begin 
	select count(distinct product_id) as total_type_product from orderdetails where order_id = p_order_id;
end //
delimiter ;

-- Test
call proc_cal_total_amount_by_order(1);
drop procedure if exists proc_cal_total_amount_by_order;




-- Câu 10 - Tạo trigger
-- Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng
-- sản phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới. 
-- Nếu số lượng trong kho không đủ thì ném ra thông báo lỗi “Số lượng sản phẩm trong kho không đủ” và hủy
-- thao tác chèn.
delimiter //
create trigger trigger_after_insert_order_details before insert on orderdetails
for each row
begin
	declare current_quantity int;
    -- lấy số lượng tồn kho hiện tại
    select quantity into current_quantity from products where product_id = new.product_id;
    -- kiểm tra đủ hàng hay không
    if current_quantity < new.quantity then
        signal sqlstate '45000'
        set message_text = 'Số lượng sản phẩm trong kho không đủ';
    else
        -- cập nhật số lượng tồn kho
        update products set quantity = quantity - new.quantity where product_id = new.product_id;
    end if;	
end //
delimiter ;





-- Câu 11 - Quản lý transaction
-- Tạo một thủ tục có tên proc_insert_order_details nhận vào tham số là mã đơn hàng,
-- mã sản phẩm, số lượng và giá sản phẩm. 
-- Sử dụng transaction thực hiện các yêu cầu sau :
--  - Kiểm tra nếu mã hóa đơn không tồn tại trong bảng order thì ném ra thông báo lỗi “không tồn tại mã hóa đơn”.
--  - Chèn dữ liệu vào bảng order_details
--  - Cập nhật tổng tiền của đơn hàng ở bảng Orders
--  - Nếu như có bất cứ lỗi nào sinh ra, rollback lại Transaction

delimiter //
create procedure proc_insert_order_details (
	p_order_id int,
    p_product_id int, 
    p_quantity int,
    p_price decimal(10,2)
)
begin
	-- Nếu như có bất cứ lỗi nào sinh ra, rollback lại Transaction
	declare exit handler for sqlexception
    begin
        rollback;
    end;
	
    start transaction;
    if not exists (select 1 from orders where order_id = p_order_id) then
		signal sqlstate '45000'
        set message_text = 'Không tồn tại mã hóa đơn';
	end if;
	insert into orderdetails (order_id, product_id, quantity, unit_price) values (p_order_id, p_product_id, p_quantity, p_price);
	update orders set total_amount = total_amount + (p_quantity * p_price) where order_id = p_order_id;
	commit;

end //
delimiter ;

-- Test
call proc_insert_order_details(3, 4, 2, 860000);
select * from orders where order_id = 3;



