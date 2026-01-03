create database sql_sesson05;
 
use sqp_sesson05;

create table students(
	stu_id varchar(10) primary key,
    fullname varchar(50),
    email varchar (45) unique,
    date_of_birth date,
    gender bit,
    address varchar(50)
);

create table class(
	class_id char(20) primary key,
    class_name varchar(35),
    stu_id varchar(10),
    foreign key (stu_id) references students (stu_id)
);
