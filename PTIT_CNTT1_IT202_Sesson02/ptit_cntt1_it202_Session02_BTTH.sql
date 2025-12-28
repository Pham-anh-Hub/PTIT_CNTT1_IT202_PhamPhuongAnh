-- bai tap thuc hanh
create database btth_session02;
use btth_session02;

create table students(
	student_id int auto_increment primary key,
    fullname varchar(45),
    age int,
    email varchar(50)
);

create table subjects(
	subject_id int auto_increment primary key,
    subject_name varchar(35) not null,
    content varchar(255),
    credits int not null,
    student_id int not null,
    foreign key(student_id) references students (student_id)
);

create table enrollment(
	enroll_id int auto_increment primary key,
    title varchar(45) not null,
    content varchar(255) not null,
    enroll_date date not null,
    student_id int,
    subject_id int,
    foreign key(student_id) references students(student_id),
    foreign key(subject_id) references subjects(subject_id)
);

-- 1. Thêm mới 1 cột vào bảng students 
alter table students add phone varchar(11);
-- 2. Bổ sung ràng buộc UNIQUE cho cột email
-- alter table students add constraint -- 


