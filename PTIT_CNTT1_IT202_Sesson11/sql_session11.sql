create database db_k24_cntt01_session11;

use db_k24_cntt01_session11;

create table students(
	id int auto_increment primary key,
    full_name varchar(50),
    gender bit,
    birthday date,
    address varchar(200),
    class_name varchar(100)
);

-- Thủ tục insert dl cho bảng students
delimiter //
create procedure pr_insert_students(
	full_name_in varchar(50),
    gender_in bit,
    birthday_in date,
    address_in varchar(200),
    class_name_in varchar(100))
    begin
		insert into students(full_name,gender,birthday,address,class_name) values
        (full_name_in,gender_in,birthday_in,address_in,class_name_in);
    end //
delimiter ;

call pr_insert_students('Nguyễn Văn Cường',1,'2005-12-21','Hưng Yên','CNTT01');

-- Thủ tục lấy hết dữ liệu từ bảng students
delimiter //
create procedure get_students()
begin
	select * from students;    
end //
delimiter ;

call get_students();

-- Thủ tục lấy dữ liệu của bảng students có phân trang
delimiter //
create procedure get_students_in_page(
	page int,
    item_per_page int
)
begin
	declare offset_value int;
    set offset_value = (page-1)*item_per_page;
	select * from students limit item_per_page offset offset_value ;
end //
delimiter ;

-- call thủ tục insert dl
call pr_insert_students('Nguyễn Thành Nam',1,'2005-05-15','Thái Bình','CNTT01');
call pr_insert_students('Trần Thanh Huyền',0,'2005-11-30','Hải Phòng','CNTT01');
call pr_insert_students('Đinh Tiến Dũng',1,'2005-05-15','Phú Thọ','CNTT01');

-- call thủ tục lấy dữ liệu phân trang
call get_students_in_page(1,2);

call get_students_in_page(2,2);

-- Tham số ra
delimiter //
create procedure count_students(
	out total_student int
)
begin
	set total_student = (select count(*) from students);
end //
delimiter ;

-- Gọi thủ tục có tham số ra
call count_students(@total);
select @total as 'Tổng số sinh viên';

-- Cài đặt thủ tục homework_02
delimiter //
create procedure CalculatePostLikes(
)
begin

end //
delimiter ;








    
    
    
    