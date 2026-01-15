create database ptit_cntt1_it202_sesson14_Bai4_6;
use ptit_cntt1_it202_sesson14_Bai4_6;

create table users(
	user_id int auto_increment primary key,
    username varchar(50) not null,
    posts_count int default(0)
);

create table posts(
	post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    like_counts int default(0),
    created_at datetime default(current_timestamp()),
    foreign key(user_id) references users(user_id)
);
insert into users (username, posts_count) values
('anhpham', 2),
('minhtran', 2),
('lannguyen', 1),
('hoangvu', 2),
('thuydo', 1),
('quanghuy', 2),
('tuanle', 1),
('ngocmai', 1),
('ducthanh', 2),
('phuonglinh', 1);

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Bài viết đầu tiên của anhpham', '2026-01-01 08:10:00'),
(1, 'Học SQL cơ bản', '2026-01-02 09:15:00'),
(2, 'Xin chào mọi người', '2026-01-01 10:00:00'),
(2, 'Thực hành MySQL', '2026-01-03 14:20:00'),
(3, 'Bắt đầu học lập trình', '2026-01-02 11:30:00'),
(4, 'Thiết kế cơ sở dữ liệu', '2026-01-03 09:00:00'),
(4, 'Chuẩn hóa bảng dữ liệu', '2026-01-04 15:10:00'),
(5, 'Ôn tập trước kỳ thi', '2026-01-05 20:00:00'),
(6, 'Học HTML cơ bản', '2026-01-01 18:30:00'),
(6, 'CSS giúp giao diện đẹp hơn', '2026-01-02 19:45:00'),
(7, 'JavaScript nhập môn', '2026-01-03 21:00:00'),
(8, 'Làm project nhỏ', '2026-01-04 16:40:00'),
(9, 'Stored Procedure trong MySQL', '2026-01-05 08:50:00'),
(9, 'Trigger và cách sử dụng', '2026-01-06 09:30:00'),
(10, 'Chuẩn bị báo cáo môn CSDL', '2026-01-06 22:00:00');



-- Viết script SQL sử dụng TRANSACTION để thực hiện:
-- INSERT một bản ghi mới vào bảng posts (với user_id và content do bạn chọn)
start transaction ;
insert into posts(user_id, content) values (2, 'Chuẩn bị bài thực hành 15');
-- UPDATE tăng posts_count +1 cho user tương ứng.
update users set posts_count = posts_count + 1 where user_id = 2;
commit;	
-- Nếu thành công, thực hiện COMMIT.

start transaction ;
insert into posts(user_id, content) values (12, 'Insert bài viết cho người dùng không tônf');
-- UPDATE tăng posts_count +1 cho user tương ứng.
update users set posts_count = posts_count + 1 where user_id = 12;
rollback;	
-- Nếu bất kỳ thao tác nào thất bại, thực hiện ROLLBACK.
select * from posts;
select * from users;


-- Bai 2: Thích (Like) một bài viết trên mạng xã hội
create table likes (
	like_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    constraint unique key(post_id, user_id), -- ràng buộc bảng
	foreign key(post_id) references posts(post_id),
    foreign key(user_id) references users(user_id)
);
-- Viết script SQL sử dụng TRANSACTION để:
-- INSERT vào bảng likes (post_id và user_id do bạn chọn).
-- UPDATE tăng likes_count +1 cho bài viết tương ứng.

delimiter //
create procedure sp_insert_like (
	in p_post_id int,
    in p_user_id int
)
begin
	if exists(select 1 from likes where post_id = p_post_id and user_id = p_user_id) then
    rollback;
    else
    start transaction;
		insert into likes(user_id, post_id) values (p_user_id, p_post_id);
        update posts set likes_count = likes_count + 1 where post_id = p_post_id;
	commit;
	end if;
end //
delimiter ;
-- Nếu vi phạm UNIQUE constraint (đã like trước đó) hoặc lỗi khác, ROLLBACK.





-- Bai 3
create table followers (
	follower_id int not null,
    followee_id int not null,
    primary key(follower_id, followee_id)
);

-- Thêm cột following_count INT DEFAULT 0 và followers_count INT DEFAULT 0 vào bảng users 
alter table users add  followers_count INT DEFAULT(0);
alter table users add following_count INT DEFAULT(0);


delimiter //

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    if p_follower_id = p_followed_id then
        rollback;

    elseif not exists (select 1 from users where user_id = p_follower_id)
        or not exists (select 1 from users where user_id = p_followed_id) then
        rollback;

    elseif exists (
        select 1 from followers
        where follower_id = p_follower_id
          and followee_id = p_followed_id
    ) then
        rollback;

    else
        insert into followers(follower_id, followee_id)
        values (p_follower_id, p_followed_id);

        update users set following_count = following_count + 1
        where user_id = p_follower_id;

        update users set followers_count = followers_count + 1
        where user_id = p_followed_id;

        commit;
    end if;
end //

delimiter ;


call sp_follow_user(1, 2);
-- gọi lại lần nữa
call sp_follow_user(1, 2);

-- user không tồn tại 	 	
call sp_follow_user(999, 1);

drop procedure sp_follow_user;
select * from followers;




-- Bài 4: Đăng bình luận kèm kiểm tra và savepoint
create table comments(
	comment_id int auto_increment primary key,
    post_id int not null,
	user_id int not null, 
    content text not null, 
    created_at datetime default(current_timestamp()),
    foreign key(post_id) references posts(post_id),
    foreign key(user_id) references users(user_id)
);

alter table posts add comments_count int default 0;


delimiter //
create procedure sp_add_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text,
    in p_force_error int  -- 1: gây lỗi ở update, 0: bình thường
)
begin
    declare exit handler for sqlexception -- Bắt các lỗi sql (Vi phạm khóa ngoại, Lỗi cú pháp. Tràn dữ liệu, Lỗi runtime SQL)
    begin
        rollback;
    end;
    start transaction;
insert into comments(post_id, user_id, content)
values (p_post_id, p_user_id, p_content);

savepoint after_insert;

if exists (select 1 from posts where post_id = p_post_id) then
    update posts
    set comments_count = comments_count + 1
    where post_id = p_post_id;
    commit;
else
    rollback to after_insert;
    commit;
end if;

end//

delimiter ;





-- Bai 5: Xóa bài viết và toàn bộ nội dung liên quan
delimiter //
create procedure sp_delete_post (
	p_post_id INT,
    p_user_id INT
)
begin
	declare exit handler for sqlexception
    begin
        rollback;
    end;
    start transaction;
    -- kiểm tra bài viết tồn tại và thuộc user
    if not exists (
        select 1 from posts
        where post_id = p_post_id
          and user_id = p_user_id
    ) then
        rollback;
	else
    start transaction;
		delete from likes where post_id = p_post_id;
        delete from comments where post_id = p_post_id;
        delete from posts where post_id = p_post_id;
        update users set posts_count = posts_count - 1 where user_id = p_user_id;
        insert into delete_log(post_id, deleted_by) values (p_post_id, p_user_id);
	commit;
	end if;
end //
delimiter ;

-- Tạo thêm bảng delete_log để ghi log mỗi lần xóa thành công (post_id, deleted_at, deleted_by).
create table delete_log(
	post_id int,
    deleted_at datetime default(current_timestamp()),
    deleted_by int -- user id
);

select * from posts;
call sp_delete_post(12, 9); -- Lỗi xóa bài không phải của người dùng
call sp_delete_post(12, 8);



-- Bai 6:
create table friend_requests (
    request_id int auto_increment primary key,
    from_user_id int not null,
    to_user_id int not null,
    status enum('pending','accepted','rejected') default 'pending',
    created_at datetime default current_timestamp,
    foreign key (from_user_id) references users(user_id),
    foreign key (to_user_id) references users(user_id),
    constraint uq_friend_request unique (from_user_id, to_user_id)
);

create table friends (
    user_id int not null,
    friend_id int not null,
    created_at datetime default current_timestamp,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
	foreign key (friend_id) references users(user_id)
);

insert into friend_requests (from_user_id, to_user_id, status) values
(1, 2, 'pending'),
(3, 1, 'accepted'),
(4, 5, 'rejected');

insert into friends (user_id, friend_id) values
(1, 3),
(3, 1),
(2, 4);

-- Viết Stored Procedure sp_accept_friend_request với tham số

-- Kiểm tra request tồn tại, status='pending', và to_user_id đúng.
-- INSERT vào friends hai bản ghi (A-B và B-A)
-- UPDATE tăng friends_count +1 cho cả hai user
-- UPDATE friend_requests SET status='accepted'
-- Nếu lỗi (ví dụ: đã là bạn trước đó), ROLLBACK
-- Thành công → COMMIT

delimiter //

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from_user_id int;

    declare exit handler for sqlexception rollback;

    set transaction isolation level repeatable read;
    start transaction;

    select from_user_id into v_from_user_id
    from friend_requests
    where request_id = p_request_id
      and to_user_id = p_to_user_id
      and status = 'pending'
    for update;

    if v_from_user_id is null
       or exists (
            select 1 from friends
            where user_id = v_from_user_id
              and friend_id = p_to_user_id
       ) then
        rollback;
    else
        insert into friends values
            (v_from_user_id, p_to_user_id),
            (p_to_user_id, v_from_user_id);

        update users
        set friends_count = friends_count + 1
        where user_id in (v_from_user_id, p_to_user_id);

        update friend_requests
        set status = 'accepted'
        where request_id = p_request_id;

        commit;
    end if;
end//

delimiter ;


