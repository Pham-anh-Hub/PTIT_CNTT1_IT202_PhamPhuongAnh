create database ptit_cntt1_it202_sesson13_bai1;

use ptit_cntt1_it202_sesson13_bai1;

-- BÀI 1;
create table users(
	user_id int auto_increment primary key,
    username varchar(50) not null,
    email varchar(100) unique not null,
    created_at date default(current_date()),
    follower_count int default(0), 
    post_count int default(0)
);


create table posts (
	post_id int auto_increment primary key,
    user_id int,
    content text, 
    created_at datetime default(current_timestamp()),
    like_count int default(0),
    foreign key (user_id) references users(user_id)
);

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

select * from users;


-- 3) Tạo 2 trigger:
-- Trigger AFTER INSERT trên posts: Khi thêm bài đăng mới, tăng post_count của người dùng tương ứng lên 1.
delimiter //
create trigger trigger_after_insert_post after insert on posts 
for each row
begin 
	update users set post_count = post_count + 1 where user_id = new.user_id;
end //
delimiter ;

insert into posts (user_id, content, created_at) values
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');
	
-- Trigger AFTER DELETE trên posts: Khi xóa bài đăng, giảm post_count của người dùng tương ứng đi 1.
delimiter //
create trigger trigger_after_delete_post after delete on posts
for each row
begin
	update users set post_count = post_count - 1 where user_id = old.user_id;
end //
delimiter ;

drop trigger if exists trigger_after_delete_post;
 
delete from posts where post_id = 1;





-- Bài 2: 

create table likes(
	like_id int auto_increment primary key, 
    user_id int,
    post_id int, 
    liked_at datetime default(current_timestamp())
);


-- 2) Thêm dữ liệu mẫu vào likes (sử dụng các post_id hiện có
INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- 3) Tạo trigger AFTER INSERT và AFTER DELETE trên likes để tự động cập nhật like_count trong bảng posts
delimiter //
create trigger trigger_after_insert_like after insert on likes
for each row
begin
	update posts set like_count = like_count + 1 where post_id = new.post_id;
end //
delimiter ;

-- 4) tạo một view tên user_statistics hiển thị: user_id, username, post_count, total_likes
create or replace view user_statistics as
select
    u.user_id,
    u.username,
    count(p.post_id) as post_count,
    ifnull(sum(p.like_count), 0) as total_likes
from posts p join users u on p.user_id = u.user_id
group by u.user_id, u.username;

-- 5) thực hiện thêm một lượt thích và kiểm chứng
insert into likes (user_id, post_id, liked_at)
values (2, 4, now());

select * from likes;
select * from user_statistics;

-- 6) xóa một lượt thích và kiểm chứng lại view
delete from likes where post_id = 4 limit 1;
select * from user_statistics;




-- Bài 3:
-- 2)Thêm dữ liệu mẫu bổ sung nếu cần.
insert into users (username, email, follower_count) values ('pkngan', 'pngan@gmail.com', 0);
insert into posts (user_id, content) values (2, 'Nội dung bài đăng của user 2');
insert into likes (user_id, post_id, liked_at) values (1, 4, now());

-- 	3) Tạo/cập nhật trigger trên likes:
-- BEFORE INSERT: Kiểm tra không cho phép user like bài đăng của chính mình (nếu user_id = user_id của post thì RAISE ERROR).
delimiter //
create trigger trigger_before_insert_likes before insert  on likes
for each row
begin 
	if exists (select 1 from posts where user_id = new.user_id and post_id = new.post_id) then 
		signal sqlstate '45000'
        set message_text = 'Người dùng không thể like bài viết của chính mình';
		end if;
end //
delimiter ;
-- AFTER INSERT/DELETE/UPDATE: Cập nhật like_count trong posts tương ứng (tăng/giảm khi thêm/xóa, điều chỉnh khi UPDATE post_id).
delimiter //
create trigger trigger_after_insert_likes after insert on likes
for each row
begin
	update posts  set like_count = like_count + 1 where post_id = new.post_id;	
end //
delimiter ;

delimiter //
create trigger trigger_after_delete_likes after delete on likes
for each row
begin
	update posts  set like_count = like_count - 1 where post_id = old.post_id;	
end //
delimiter ;

delimiter //
create trigger trigger_after_after_likes after update on likes
for each row
begin
	if old.post_id <> new.post_id then
        -- giảm like của bài cũ
        update posts set like_count = like_count - 1 where post_id = old.post_id;

        -- tăng like của bài mới
        update posts set like_count = like_count + 1 where post_id = new.post_id;
        end if;
end //
delimiter ;

-- 	4) Thực hiện các thao tác kiểm thử:
-- UPDATE một like sang post khác, kiểm tra like_count của cả hai post.
-- Xóa like và kiểm tra.
select * from posts;
-- Thử like bài của chính mình (phải báo lỗi).
insert into likes (user_id, post_id) values (2, 3);
-- Thêm like hợp lệ, kiểm tra like_count.
insert into likes (user_id, post_id) values (1, 5);
-- UPDATE một like sang post khác, kiểm tra like_count của cả hai post.
update likes set post_id = 3 where like_id = 10;

select * from posts;

-- 	5) Truy vấn SELECT từ posts và user_statistics (từ bài 2) để kiểm chứng.
select * from posts;
select * from user_statistics;





-- [Bài tập 4] Quản lý lịch sử bài đăng với trigger trên 3 bảng 
-- Bảng post_history 
create table post_history(
	history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
	changed_at datetime default (current_timestamp()),
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id)
);

insert into post_history (post_id, old_content, new_content) values
(2, 'noi dung cu cua bai viet 1', 'noi dung moi cua bai viet 1'),
(2, 'noi dung cu cua bai viet 2', 'noi dung moi cua bai viet 2'),
(3, 'noi dung cu cua bai viet 3', 'noi dung moi cua bai viet 3');

-- BEFORE UPDATE trên posts: Nếu content thay đổi, INSERT bản ghi vào post_history với old_content (OLD.content), new_content (NEW.content), changed_at NOW(), và giả sử changed_by_user_id là user_id của post.
delimiter // 
create trigger trigger_before_update_post before update on posts
for each row
begin
	if(old.content <> new.content) then
	insert into post_history(post_id, old_content, new_content, changed_by_user_id)
    values (old.post_id, old.content, new.content, old.user_id);
    end if;
end //
delimiter ;
-- AFTER DELETE trên posts: Có thể ghi log hoặc để CASCADE.
delimiter // 
create trigger trigger_after_delete_post after delete on posts
for each row
begin
	insert into post_history(post_id, old_content, new_content, changed_by_user_id)
    values (old.post_id, old.content, null, old.user_id);
end //
delimiter ;

-- 4) Thực hiện UPDATE nội dung một số bài đăng, sau đó SELECT từ post_history để xem lịch sử.
update posts set content = 'noi dung moi sau khi sua' where post_id = 3;
update posts set like_count = like_count + 1 where post_id = 3;
-- 5) Kiểm tra kết hợp với trigger like_count từ bài trước vẫn hoạt động khi UPDATE post.
select * from post_history;
select post_id, like_count from posts where post_id = 4;
insert into likes (user_id, post_id) values (2, 4);






-- Bai 5: 
-- 1)Tạo Stored Procedure add_user(username, email, created_at) thực hiện INSERT vào users.
delimiter //
create procedure add_user(
    in p_username varchar(255),
    in p_email varchar(255),
    in p_created_at datetime
)
begin
    insert into users(username, email, created_at)
    values (p_username, p_email, p_created_at);
end //
delimiter ;

-- 2) Tạo trigger BEFORE INSERT trên users:
-- Kiểm tra email chứa '@' và '.'.
-- Kiểm tra username chỉ chứa chữ cái, số và underscore.
-- Nếu không hợp lệ thì RAISE ERROR.
delimiter //
create trigger trigger_before_insert_users
before insert on users
for each row
begin
    -- kiểm tra email
    if new.email not like '%@%.%' then -- kiểm tra format email
        signal sqlstate '45000'
        set message_text = 'Email không hợp lệ';
    end if;

    -- kiểm tra username
    if new.username not regexp '^[a-zA-Z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'Username chỉ được chứa chữ, số và dấu gạch dưới';
    end if;
end //
delimiter ;
-- 3) Gọi procedure với dữ liệu hợp lệ và không hợp lệ để kiểm thử.
call add_user('pham_anh123', 'phanh@gmail.com', now());
call add_user('lthu', 'lthugmail.com', now());
-- 4) SELECT * FROM users để xem kết quả.
SELECT * FROM users;






-- Bài 6: Tự động hóa quản lý theo dõi với Trigger, View và Procedure
-- 1) Tạo bảng friendships .
create table friendships (
	follower_id int,
    followee_id int,
    primary key(follower_id, followee_id),
    status ENUM('pending', 'accepted') default('accepted'),
    foreign key(follower_id) references users(user_id),
    foreign key(followee_id) references users(user_id)
);

-- 2) Tạo trigger AFTER INSERT/DELETE trên friendships để cập nhật follower_count của followee.
delimiter //
create trigger trigger_after_insert_friendship after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users set follower_count = follower_count + 1 where user_id = new.followee_id;
    end if;
end //
delimiter ;


delimiter //
create trigger trigger_after_delete_friendship
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users set follower_count = follower_count - 1 where user_id = old.followee_id;
    end if;
end //
delimiter ;

-- 3) Tạo Procedure follow_user(follower_id, followee_id, status) xử lý logic (tránh tự follow, tránh trùng).
delimiter //
create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending', 'accepted')
)
begin
    -- không cho tự follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'Không thể tự follow chính mình';
    end if;

    -- tránh follow trùng
    if exists (
        select 1
        from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'Đã follow người dùng này';
    end if;

    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end //
delimiter ;

-- 4) Tạo View user_profile chi tiết.
create or replace view user_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    count(distinct p.post_id) as post_count,
    sum(p.like_count) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count;

-- 5) Thực hiện một số follow/unfollow và kiểm chứng follower_count, View.
-- follow
call follow_user(1, 2, 'accepted');
call follow_user(3, 2, 'accepted');
-- unfollow
delete from friendships where follower_id = 1 and followee_id = 2;
select user_id, username, follower_count from users;
select * from user_profile;

