create database ptit_cntt1_it202_Session03_btth;

use ptit_cntt1_it202_Session03_btth;

create table student(
	student_id int auto_increment primary key unique,
    full_name varchar(30) not null,
    date_of_birth date not null,
    email varchar(45) not null unique
);

create table subjects(
	subjects_id int auto_increment primary key unique,
    subjects_name varchar(50) not null,
    credits int check(credits > 0),
    student_id int,
    foreign key(student_id) references student(student_id)
);

create table enrollment(
	student_id int not null,
    subjects_id int not null,
    primary key(student_id, subjects_id),
    enroll_date datetime default current_timestamp,
    
    foreign key (student_id) references student (student_id),
    foreign key (subjects_id) references subjects (subjects_id)
);

create table score (
    student_id INT NOT NULL,
    subjects_id INT NOT NULL,
    mid_score DECIMAL(4,2) DEFAULT 0 CHECK (mid_score >= 0 and mid_score <= 10),
    final_score DECIMAL(4,2) DEFAULT 0 CHECK (final_score >= 0 and final_score <= 10),

    PRIMARY KEY (student_id, subjects_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (subjects_id) REFERENCES subjects(subjects_id)
);

-- 1. Thêm một sinh viên mới
insert into student (full_name, date_of_birth, email) values ('Nguyen Van A', '2000-05-09', 'nva@gmail.com');

-- Thêm môn học
insert into subjects (subjects_name, credits, student_id) values ('Javascript', 4, 1),('HTML', 3, 1);

select * from subjects;


-- 2. Đăng ký ít nhất 2 môn học cho sinh viên đó
insert into enrollment (student_id, subjects_id) values (1, 3), (1, 2);

-- 3. Thêm và cập nhật điểm cho sinh viên vừa thêm
insert into score (student_id, subjects_id, mid_score, final_score) values (1, 1, 6.5, 8);

-- Thêm lượt đki không hợp lệ
insert into enrollment (student_id, subjects_id) values (2, 3);

-- select * from enrollment;

-- 4. Xóa một lượt đăng ký không hợp lệ
delete from enrollment where student_id = 1 and subjects_id = 2;

-- 5. Lấy ra danh sách sinh viên và điểm số tương ứng
select * from student;
select * from score;






