create database miniproject_social_network;

use miniproject_social_network;

create table users(
	user_id int auto_increment primary key,
    username varchar(50) not null,
    password varchar(255) not null,
    email varchar(100) unique not null,
    status enum ('active', 'inactive') default('active'),
    created_at datetime default(current_timestamp())
);


create table posts (
	post_id  int auto_increment primary key,
    user_id int,
    content text not null,
    created_at datetime default (current_timestamp()),
    foreign key (user_id) references users (user_id)
);

create table comments (
	comment_id  int auto_increment primary key,
    post_id int,
    user_id int,
    content text not null,
    created_at datetime default(current_timestamp()),
    foreign key (user_id) references users (user_id),
    foreign key (post_id) references posts(post_id)
);

create table friends (
	user_id int,
    friend_id int,
    status varchar(20) not null,
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id),
    check (status in ('pending', 'accepted')),
    primary key (user_id, friend_id)
);

create table likes (
	user_id int,
    post_id int,
    created_at datetime default(current_timestamp()),
    foreign key (user_id) references users(user_id),
    foreign key (post_id) references posts(post_id),
    primary key (user_id, post_id)
);

-- Bài 1. Quản lý người dùng
-- Thêm người dùng mới
insert into users (username, password, status, email) values
('anhpham',   '123456a', 'active',   'anhpham@gmail.com'),
('minhtran',  '123456b', 'active',   'minhtran@gmail.com'),
('lannguyen', '123456c', 'active',   'lannguyen@gmail.com'),
('hoangvu',   '123456d', 'inactive', 'hoangvu@gmail.com'),
('thanhle',   '123456e', 'active',   'thanhle@gmail.com'),
('huongdo',   '123456f', 'active',   'huongdo@gmail.com'),
('namnguyen', '123456g', 'active',   'namnguyen@gmail.com'),
('tuanpham',  '123456h', 'inactive', 'tuanpham@gmail.com'),
('linhtran',  '123456i', 'active',   'linhtran@gmail.com'),
('quangnguyen','123456j', 'active',   'quangnguyen@gmail.com'),
('phuongle',  '123456k', 'active',   'phuongle@gmail.com'),
('vietdo',    '123456l', 'inactive', 'vietdo@gmail.com'),
('hainguyen', '123456m', 'active',   'hainguyen@gmail.com'),
('sonpham',   '123456n', 'active',   'sonpham@gmail.com'),
('thaoho',    '123456o', 'inactive', 'thaoho@gmail.com'),
('longtran',  '123456p', 'active',   'longtran@gmail.com'),
('mynguyen',  '123456q', 'active',   'mynguyen@gmail.com'),
('khanhle',   '123456r', 'inactive', 'khanhle@gmail.com'),
('duongpham', '123456s', 'active',   'duongpham@gmail.com'),
('trinhdo',   '123456t', 'active',   'trinhdo@gmail.com');


insert into posts (user_id, content) values
(1, 'Hôm nay trời đẹp quá'),
(2, 'Lần đầu học SQL thấy cũng thú vị'),
(3, 'Ai đang học IT giống mình không'),
(4, 'Chia sẻ một chút về cuộc sống sinh viên'),
(5, 'Cuối tuần đi chơi đâu đây'),
(6, 'Học nhóm tối nay nhé'),
(7, 'Mọi người nghĩ sao về công nghệ AI'),
(8, 'Deadline nhiều quá 😢'),
(9, 'Vừa hoàn thành xong bài tập lớn'),
(10,'Chào buổi sáng mọi người'),
(11,'Hôm nay học MySQL'),
(12,'Cố gắng mỗi ngày một chút'),
(13,'Chia sẻ tài liệu học tập'),
(14,'Có ai rảnh cà phê không'),
(15,'Tối nay xem phim'),
(16,'Học code hơi mệt'),
(17,'Cuối kỳ rồi cố lên'),
(18,'SQL JOIN khá là đau đầu'),
(19,'Mong sớm được nghỉ lễ'),
(20,'Ngày mới năng lượng nhé');

insert into comments (post_id, user_id, content) values
(1, 2, 'Chuẩn luôn'),
(1, 3, 'Đồng ý'),
(2, 1, 'Cố gắng là quen thôi'),
(2, 4, 'SQL rất cần thiết'),
(3, 5, 'Mình cũng học IT'),
(4, 6, 'Bài viết hay'),
(5, 7, 'Đi chơi đi'),
(6, 8, 'Ok luôn'),
(7, 9, 'AI đang hot mà'),
(8, 10, 'Cố lên bạn'),
(9, 11, 'Chúc mừng nhé'),
(10,12, 'Chào buổi sáng'),
(11,13, 'MySQL khá dễ'),
(12,14, 'Chuẩn luôn'),
(13,15, 'Cảm ơn bạn'),
(14,16, 'Cho mình đi với'),
(15,17, 'Xem phim gì vậy'),
(16,18, 'Ráng chút nữa'),
(17,19, 'Sắp xong rồi'),
(18,20, 'JOIN quen là ổn');


insert into friends (user_id, friend_id, status) values
(1, 2, 'accepted'),
(1, 3, 'accepted'),
(2, 3, 'accepted'),
(2, 4, 'pending'),
(3, 5, 'accepted'),
(4, 6, 'pending'),
(5, 6, 'accepted'),
(6, 7, 'accepted'),
(7, 8, 'pending'),
(8, 9, 'accepted'),
(9, 10,'accepted'),
(10,11,'pending'),
(11,12,'accepted'),
(12,13,'accepted'),
(13,14,'pending'),
(14,15,'accepted'),
(15,16,'accepted'),
(16,17,'pending'),
(17,18,'accepted'),
(18,19,'accepted');


insert into likes (user_id, post_id) values
(2, 1),
(3, 1),
(1, 2),
(4, 2),
(5, 3),
(6, 4),
(7, 5),
(8, 6),
(9, 7),
(10,8),
(11,9),
(12,10),
(13,11),
(14,12),
(15,13),
(16,14),
(17,15),
(18,16),
(19,17),
(20,18);



-- Hiển thị danh sách người dùng.
select * from users;




-- Bài 2. Hiển thị thông tin công khai bằng VIEW
-- Tạo View vw_public_users chỉ hiển thị: user_id, username, created_at.
create or replace view vw_public_users as select user_id, username, created_at from users;
-- Thực hiện:
-- SELECT từ View
select * from vw_public_users;
-- So sánh với SELECT trực tiếp từ bảng Users.
	-- Đối với view, ta có thể cho phép hiển thị giới hạn số cột cần thiết mà không cần lấy ra từng cột truyeefn thống
-- Giải thích:
-- Lợi ích bảo mật của View: CHo phép ẩn đi những thôgn tin nhạy cảm như email, mật khẩu




-- Bài 3. Tối ưu tìm kiếm người dùng bằng INDEX
-- Tạo Index cho: username trong bảng Users.
create index index_user_name on users(username);
-- Viết truy vấn: Tìm user theo username.
select * from users where username = 'phuongle';
-- So sánh:
-- Tăng tốc độ câu lệnh SELECT (đặc biệt là WHERE, JOIN, ORDER BY).
-- Giảm tải cho CPU và ổ cứng của Server.




-- Bài 4. Quản lý bài viết bằng Stored Procedure
-- Yêu cầu Chức năng mô phỏng: Đăng bài viết
-- Viết Procedure sp_create_post:
delimiter //
create procedure sp_create_post (
	in p_user_id int,
    in p_content text
)
begin
	insert into posts(user_id, content) values ((select user_id from users where user_id = p_user_id), p_content);
end //
delimiter ;

-- Gọi Procedure bằng CALL.
call sp_create_post(12, 'ôi, quên hết cú pháp rồi');
-- select * from posts order by created_at desc;




-- Bài 5. Hiển thị News Feed bằng VIEW
-- Tạo View vw_recent_posts:
-- Lấy bài viết trong 7 ngày gần nhất.
create or replace view vw_recent_posts as select * from posts where datediff(current_timestamp(), created_at) <= 7; 
-- Viết truy vấn:
-- Hiển thị danh sách bài viết mới nhất.
select * from vw_recent_posts order by created_at desc limit 1;




-- Bài 6. Tối ưu truy vấn bài viết
-- select * from posts where user_id = 12 order by created_at desc;
-- Tạo: Index cho Posts.user_id
-- Composite Index ().
create index idx_user_id on posts(user_id);
create index idx_user_post on posts(user_id, created_at);
-- Viết truy vấn:
-- Lấy danh sách bài viết của 1 user theo thời gian giảm dần.
select * from posts where user_id = 12 order by created_at desc;
-- Phân tích:
-- Vai trò của Composite Index: Cho phép tạo index trên nhiều cột cùng lúc




-- Bài 7. Thống kê hoạt động bằng Stored Procedure
-- Viết Procedure sp_count_posts:
-- IN p_user_id
-- OUT p_total.
delimiter //
create procedure sp_count_posts (
	in p_user_id int,
    out p_total int
)
begin
	select count(*) into p_total from posts where user_id = p_user_id;

end //
delimiter ;
-- Gọi Procedure và hiển thị kết quả.

call sp_count_posts(12, @p_total);
select @p_total;




-- Bài 8. Kiểm soát dữ liệu bằng View WITH CHECK OPTION
-- Tạo View vw_active_users có:
-- Điều kiện lọc user đang hoạt động.
create or replace view vw_active_users as select * from users where status = 'active' 
with check option;

-- Áp dụng:
-- WITH CHECK OPTION.
-- Thực hiện:
-- INSERT / UPDATE thông qua View
insert into vw_active_users(username, password, status, email) values ('linhthu', '123456t', 'active', 'lthu@gmail.com');
insert into vw_active_users(username, password, status, email) values ('kimngan', '123456s', 'inactive', 'kngan@gmail.com'); -- Báo lỗi check option
-- Kiểm tra dữ liệu bị từ chối khi không thỏa điều kiện.






-- Bài 9. Quản lý kết bạn bằng Stored Procedure
-- Viết Procedure sp_add_friend: IN p_user_id, IN p_friend_id.
-- Kiểm tra:
delimiter // 
create procedure sp_add_friend (
	in p_user_id int,
    in p_friend_id int
)
begin
	if(p_user_id <> p_friend_id) then
		insert into friends (user_id, friend_id, status) values (p_user_id, p_friend_id, 'pending');
	end if;
end //
delimiter ;
-- Không cho kết bạn với chính mình.
-- Sử dụng:
-- IF / ELSE.




-- Bài 10. Gợi ý bạn bè bằng Procedure nâng cao
-- Viết Procedure sp_suggest_friends:
-- IN p_user_id
-- INOUT p_limit.
delimiter //
create procedure sp_suggest_friends (
	in p_user_id int,
    inout p_limit int
)
begin
	if p_limit <= 0 then
        set p_limit = 5;
    end if;

    -- Trả danh sách gợi ý bạn bè
    select username, email, created_at
    from users
    where user_id <> p_user_id
    limit p_limit;
end //
delimiter ;

-- Áp dụng:
-- Biến
-- IF / ELSE
-- WHILE.
-- Trả về:
-- Danh sách gợi ý bạn bè.




-- Bài 11. Thống kê tương tác nâng cao
-- Viết truy vấn:
-- Top 5 bài viết nhiều lượt thích nhất.
-- Tạo View:
-- vw_top_posts.
create or replace view vw_top_posts as select  p.post_id,
    p.user_id as p_owner_id,
    p.content,
    p.created_at,
    count(l.user_id) as total_likes from posts p 
join likes l on l.post_id = p.post_id group by l.post_id order by count(l.user_id) desc limit 5;

explain analyze select * from vw_top_posts group by post_id;

-- Tạo Index:
-- Cho Likes.post_id.
create index idx_post_id on likes(post_id);






-- BÀI 12. QUẢN LÝ BÌNH LUẬN
Stored Procedure thêm bình luận:
-- Viết Procedure sp_add_comment:

-- Tham số: IN p_user_id, IN p_post_id, IN p_content
-- Chức năng:
-- Kiểm tra:
-- User tồn tại
-- Post tồn tại
-- Nếu hợp lệ → thêm bình luận.
-- Nếu không → thông báo lỗi.
delimiter //
create procedure sp_add_comment(
	in p_user_id int,
    in p_post_id int 
)
begin
	declare inform_message text;
	if(select * from posts where user_id = p_user_id and post_id = p_post_id) then
		insert into comments (post_id, user_id, content) values (p_user_id, p_post_id, 'Nội dung bình luận');
	else 
		set inform_message = 'Thêm bình luận chưa thành công';
		select inform_message;
        end if;
end //
delimiter ;
-- Bắt buộc dùng:
-- DECLARE
-- IF / ELSE.

-- View hiển thị bình luận
-- Tạo View vw_post_comments:
create or replace view vw_post_comments as select c.content, u.username, c.created_at from comments c join users u;

-- Hiển thị:
-- Nội dung bình luận
-- Tên người bình luận
-- Thời gian.
select * from vw_post_comments;







-- BÀI 13. QUẢN LÝ LƯỢT THÍCH

-- Stored Procedure ghi nhận lượt thích
-- Viết Procedure sp_like_post:
-- Tham số: IN p_user_id, IN p_post_id
-- Chức năng:
delimiter //
create procedure sp_like_post (
	in p_user_id int,
    in p_post_id int
)
begin
	declare inform_message text;
	if(select post_id from likes where post_id = p_post_id and user_id = p_user_id) then
		set inform_message = 'Đã thích bài viết này';
        select inform_message;
	else
		set inform_message = 'Đã thích';
		insert into likes (user_id, post_id) values (p_user_id, p_user_id);
        select inform_message;
	end if;
end //
delimiter ;
-- Kiểm tra: User đã thích post chưa.
-- Nếu chưa → thêm vào Likes.
-- Nếu rồi → không cho thêm trùng.
call sp_like_post(5, 1);

-- View thống kê lượt thích
-- Tạo View vw_post_likes:
select * from likes;
create or replace view vw_post_likes as select post_id, count(*) from likes group by post_id;

-- Hiển thị:
-- post_id
-- Số lượt thích (COUNT(*)).
select * from vw_post_likes;

drop procedure if exists sp_like_post;






-- Bài 14. TÌM KIẾM NGƯỜI DÙNG & BÀI VIẾT
-- viết Stored Procedure có tên sp_search_social với các tham số:
-- p_option INT
-- p_keyword VARCHAR(100)
-- Trong đó:
delimiter //
create procedure sp_search_social(
	in p_option int,
    in p_keyword varchar(100)
)
begin
	declare notice_message text;
    if(p_option <> 1 and p_option <> 2) then
		set notice_message = 'Lựa chọn không hợp lệ';
        select notice_message;
	elseif(length(p_keyword) > 100 and length(trim(p_keyword)) = 0) then 
		set notice_message = 'Từ khóa tìm kiếm chưa hợp lệ';
        select notice_message;
	else 
		if(p_option = 1) then 
			select user_id, username, email, created_at from users where username like  concat('%', p_keyword, '%');
		elseif(p_option = 2) then 
			select * from posts where content like  concat('%', p_keyword, '%');
            end if;
    end if;
end //
delimiter ;

-- Nếu p_option = 1 → tìm người dùng theo username.
-- Nếu p_option = 2 → tìm bài viết theo content.
-- Nếu giá trị khác → trả về thông báo lỗi.
-- Procedure phải sử dụng:

-- Cấu trúc điều kiện IF / ELSEIF / ELSE.
-- Hãy viết lệnh CALL để:
-- Tìm người dùng có username chứa từ "an".
-- Tìm bài viết có nội dung chứa từ "database".

call sp_search_social(1, 'an');
call sp_search_social(2, 'học');

drop procedure sp_search_social;



