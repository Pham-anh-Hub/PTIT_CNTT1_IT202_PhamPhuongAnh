create database ptit_cntt1_it202_Sesson04_btth;

use ptit_cntt1_it202_Sesson04_btth;

-- Phần I - Thiết kế & Tạo bảng (DDL)
create table student(
	student_id int auto_increment primary key unique,
    full_name varchar(30) not null,
    date_of_birth date not null,
    email varchar(45) not null unique
);

create table instructor(
	instructor_id int auto_increment primary key unique,
    instructor_name varchar(100) not null,
    email varchar(100) unique
);
create table course(
	course_id int auto_increment primary key unique,
    course_title varchar(50) not null,
    short_discript varchar(255),
    lessons int check(lessons > 0),
    student_id int,
    instructor_id int,
    foreign key(student_id) references student(student_id),
    foreign key(instructor_id) references instructor(instructor_id)
);

create table result (
    student_id int not null unique,
    course_id int not null,
    mid_score DECIMAL(4,2) DEFAULT 0 CHECK (mid_score >= 0 and mid_score <= 10),
    final_score DECIMAL(4,2) DEFAULT 0 CHECK (final_score >= 0 and final_score <= 10),

    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

create table enrollment(
	enroll_date date default(current_date()),
    student_id int unique,
    course_id int,
    primary key(student_id, course_id),
    foreign key (student_id) references student(student_id),
    foreign key (course_id) references course(course_id)
);


alter table instructor  
modify instructor_id int  auto_increment ;

-- Phần II - Nhập dữ liệu ban đầu
-- 1. Thêm ít nhất 5 sinh viên
insert into student (full_name, date_of_birth, email) values 
('Nguyễn Văn A', '2000-05-09', 'nguyenvana@gmail.com'),
('Lê Thị B',     '2000-08-12', 'lethib@gmail.com'),
('Trần Văn C',   '2001-03-22', 'tranvanc@gmail.com'),
('Nguyễn Văn D', '1999-11-30', 'nguyenvand@gmail.com'),
('Lê Minh E',    '2000-01-15', 'leminhe@gmail.com');

-- 2. Thêm ít nhất 5 giảng viên
insert into instructor (instructor_name, email) values 
('Trần Văn A', 'tranva@gmail.com'),
('Nguyễn Thị B', 'nguyenthib@gmail.com'),
('Lê Văn C',     'levanc@gmail.com'),
('Phạm Thị D',   'phamthid@gmail.com'),
('Hoàng Văn E',  'hoangvane@gmail.com');
alter table instructor modify instructor_id int auto_increment;
select * from course;

-- 3. Thêm ít nhất 5 khóa học
insert into course (course_title, short_discript, lessons, student_id, instructor_id) values 
('Lập trình C cơ bản', 'Khóa học nhập môn lập trình C', 20, 1, 1),
('Cơ sở dữ liệu', 'Học về SQL và thiết kế CSDL',  18, 2, 2),
('Lập trình Java', 'Java từ cơ bản đến nâng cao', 25, 3, 3),
('Phát triển Web', 'HTML, CSS, JavaScript cơ bản', 22, 4, 4),
('Hệ quản trị MySQL', 'Quản lý và tối ưu cơ sở dữ liệu', 21, 5, 5);

-- 4. Thêm dữ liệu đăng ký học cho sinh viên
insert into enrollment (enroll_date, student_id, course_id ) values 
('2024-05-21', 1,4), 
('2025-02-18', 2,1), 
(null , 3, 5), 
('2025-05-01', 4,3), 
('2024-01-24', 5,2);

-- 5. Thêm dữ liệu kết quả học tập cho sinh viên
insert into result (student_id, course_id, mid_score, final_score) values 
(1, 1, 7.50, 8.00),
(2, 1, 6.00, 6.50),
(3, 2, 8.25, 7.00),
(4, 3, 5.00, 6.00),
(5, 2, 9.00, 9.0);


-- Phần III - Cập nhật dữ liệu
-- 1. Cập nhật email cho 1 sv: Nguyen Van D
select * from student;
update student set email = 'nvd@gmail.com' where student_id = 4;

-- 2. Cập nhật mô tả cho một khóa học: Cập nhật cho khóa học Cơ sở dữ liệu
select * from course;
update course set short_discript = 'Học về SQL cơ bản và thực hành thiết kế CSDL' where course_title = 'Cơ sở dữ liệu' or course_id = 2;

-- 3. Cập nhật điểm cuối kỳ cho một sinh viên
select * from result;
update result set final_score = 7.5 where student_id = 4;


-- Phần IV - Xóa dữ liệu
-- Xóa một lượt đăng ký học không hợp lệ: xóa luọt đăng kỹ bị lỗi ngày đăng ký
select * from enrollment;
delete from enrollment where enroll_date is null;

-- Lỗi conflict giữa bảng result và enrollment


-- 5. Truy vấn dữ liệu
select * from student;
select * from instructor;
select * from course;
select * from result;
select * from enrollment;








