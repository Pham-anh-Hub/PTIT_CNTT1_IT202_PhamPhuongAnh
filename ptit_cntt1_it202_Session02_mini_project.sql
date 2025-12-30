-- CSDL quản lý thư viện 
create database library_manage_miniProject;

use library_manage_miniProject;

-- Câu 1. (DDL – 5 điểm)
-- 1. Bảng Reader
create table reader(
	reader_id int auto_increment primary key,
    reader_name varchar(100) not null,
    phone varchar(15) unique,
    register_date date default(current_date())
);
-- 2. Bảng Book
create table book(
	book_id int primary key,
    book_title varchar(150) not null,
    author varchar(100),
    publish_year int check(publish_year >= 1900)
);
-- 3. Bảng Borrow
create table borrow(
	reader_id int,
    book_id int, 
    borrow_date date default(current_date()),
    return_date date,
    
    primary key(reader_id, book_id),
    foreign key (reader_id) references reader (reader_id),
    foreign key (book_id) references book (book_id)
);

-- Câu 2. (DDL – 2 điểm)
-- Thêm cột email (VARCHAR(100), UNIQUE) vào bảng Reader
alter table reader add email varchar(100) unique;
-- Sửa kiểu dữ liệu cột author thành VARCHAR(150)
alter table book modify author varchar(150);
-- Thêm ràng buộc để return_date lớn hơn hoặc bằng borrow_date
alter table borrow 
add constraint return_date check(return_date >= borrow_date);

-- Câu 3. (DML)
-- 1. Thêm dữ liệu
insert into reader
(reader_name, phone, email)
 values
('Nguyễn Văn An','0901234567','an.nguyen@gmail.com'),
('Trần Thị Bình','0912345678','binh.tran@gmail.com'),
('Lê Minh Châu','0923456789','chau.le@gmail.com');
select * from reader;

-- 2. Bảng Book (Sách)

insert into book (book_id, book_title, author, publish_year) values 
('101','Lập trình C căn bản' , 'Nguyễn Văn A', '2018'),
('102','Cơ sở dữ liệu' , 'Trần Thị B', '2020'),
('103','Lập trình Java', 'Lê Minh C', '2019'),
('104','Hệ quản trị MySQL' , 'Phạm Văn D', '2021');
select * from book;

insert into borrow (reader_id, book_id) values
('1','101'),
('2','102'),
('3','103');

-- 2. Cập nhật dữ liệu
update borrow set return_date = '2026-10-01' where reader_id = 1;
update book set publish_year = 2021 where publish_year >= 2021;

-- 3. Xóa dữ liệu: Xóa các lượt mượn sách có borrow_date < '2024-09-18'

delete from borrow where borrow_date < '2024-09-18'; -- không có, vì ngày mượn được thêm dùng theo ngày hiện tại


-- 4.Truy vấn dữ liệu: Viết các câu SELECT lấy ra dữ liệu ở 3 bảng.
select * from reader;
select * from book;
select * from borrow;











