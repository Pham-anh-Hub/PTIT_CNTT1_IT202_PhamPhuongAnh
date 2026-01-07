create database mini_project_ss08;
use mini_project_ss08;


create table guests(
	guest_id int auto_increment primary key,
	guest_name varchar(255),
	phone varchar(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
create table bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);


insert into guests (guest_name, phone) values
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555'),
('Trần Thị Giang', '0902662222'),
('Lê Văn Hương', '0903333333'),
('Phạm Văn Khoa', '0904878444');

insert into rooms (room_type, price_per_day) values
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000),
('Standard', 500000),
('Deluxe', 800000),
('VIP', 1500000);


insert into bookings (guest_id, room_id, check_in, check_out) values
(1, 7, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2025-03-05', '2025-03-10'), -- 5 ngày
(2, 2, '2026-02-01', '2026-02-03'), -- 2 ngày
(6, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'), -- 1 ngày
(5, 8, '2024-03-05', '2024-03-10'), -- 5 ngày
(4, 6, '2025-02-01', '2025-02-03'), -- 2 ngày
(3, 6, '2024-04-15', '2024-04-18'); -- 3 ngày; 



-- PHẦN I – TRUY VẤN DỮ LIỆU CƠ BẢN
-- Liệt kê tên khách và số điện thoại của tất cả khách hàng
select guest_name, phone from guests;

-- Liệt kê các loại phòng khác nhau trong khách sạn
select distinct room_type from rooms;

-- Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần
select room_type, price_per_day from rooms order by price_per_day asc;

-- Hiển thị các phòng có giá thuê lớn hơn 1.000.000
select * from rooms where price_per_day > 1000000;

-- Liệt kê các lần đặt phòng diễn ra trong năm 2024
select * from bookings where year(check_in) = 2024 and year(check_out) = 2024;

-- Cho biết số lượng phòng của từng loại phòng
select distinct room_type as 'Loại phòng', count(*) as 'Số lượng phòng' from rooms group by room_type;




-- PHẦN II – TRUY VẤN NÂNG CAO
-- Hãy liệt kê danh sách các lần đặt phòng, Với mỗi lần đặt phòng, hãy hiển thị: Tên khách hàng, Loại phòng đã đặt, Ngày nhận phòng (check_in)
select guest_name, room_type, check_in from bookings b
join rooms r on b.room_id = r.room_id
join guests g on g.guest_id = b.guest_id;

-- Cho biết mỗi khách đã đặt phòng bao nhiêu lần
select distinct g.guest_id, g.guest_name, count(check_in) from bookings b
join guests g on b.guest_id = g.guest_id group by b.guest_id;

-- Tính doanh thu của mỗi phòng, với công thức: “Doanh thu = số ngày ở × giá thuê theo ngày”
select b.booking_id, room_type, abs(datediff(b.check_in, b.check_out)) as 'số ngày ở',  abs(datediff(b.check_in, b.check_out) * r.price_per_day) as 'Doanh thu' from bookings b 
join rooms r on r.room_id = b.room_id;

-- Hiển thị tổng doanh thu của từng loại phòng
select distinct r.room_type, sum(abs(datediff(b.check_in, b.check_out) * r.price_per_day)) as total_income from rooms r
join bookings b on b.room_id = r.room_id group by r.room_type;

-- Tìm những khách đã đặt phòng từ 2 lần trở lên
select g.guest_id, g.guest_name, count(booking_id) as booking_time from bookings b
join guests g on b.guest_id = g.guest_id group by g.guest_id, g.guest_name;

-- Tìm loại phòng có số lượt đặt phòng nhiều nhất
select r.room_type, count(booking_id) from bookings b
join rooms r on b.room_id = r.room_id group by room_type order by count(booking_id) desc limit 1;


-- PHẦN III – TRUY VẤN LỒNG
-- Hiển thị những phòng có giá thuê cao hơn giá trung bình của tất cả các phòng
select * from rooms where price_per_day > (select avg(price_per_day) from rooms);

-- Hiển thị những khách chưa từng đặt phòng
select * from guests g where g.guest_id not in (select guest_id from bookings);


-- Tìm phòng được đặt nhiều lần nhất
select * from rooms where room_id = (select room_id from bookings group by room_id order by count(booking_id) desc limit 1);






	
