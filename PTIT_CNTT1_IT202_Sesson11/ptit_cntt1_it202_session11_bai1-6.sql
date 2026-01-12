use social_network_pro;


-- Bai 1
-- 2) Tạo stored procedure có tham số IN nhận vào p_user_id:
-- Tạo stored procedure nhận vào mã người dùng p_user_id và trả về danh sách bài viết của user đó.Thông tin trả về gồm:
-- PostID (post_id)
-- Nội dung (content)
-- Thời gian tạo (created_at)

delimiter //
create procedure select_user_post (
	in p_user_id int
)
begin 
	select post_id, content, created_at from posts where user_id = p_user_id;

end //
delimiter ;

-- 3) Gọi lại thủ tục vừa tạo với user cụ thể mà bạn muốn
select * from users;
call select_user_post(20);

-- 4) Xóa thủ tục vừa tạo.
drop procedure if exists select_user_post;


-- Bai 2
-- 2) Tính tổng like của bài viết
-- Viết stored procedure CalculatePostLikes nhận vào:
-- IN p_post_id: mã bài viết
-- OUT total_likes: tổng số lượt like nhận được trên tất cả bài viết của người dùng đó
delimiter //
create procedure caculate_post_likes (
	in p_post_id int,
    out total_likes int
)
begin
	select count(*) as total_likes from likes where post_id = p_post_id group by post_id;
end //
delimiter ;

-- Logic: truyền vào post_id để đếm số likes post đó
-- 3) Thực hiện gọi stored procedure CalculatePostLikes với một post cụ thể và truy vấn giá trị của tham số OUT total_likes sau khi thủ tục thực thi.
select * from likes where post_id = 000;
call caculate_post_likes(102, @total_likes);

-- 4) Xóa thủ tục vừa mới tạo trên
drop procedure if exists caculate_post_likes;


-- Bai 3
-- 2) viết stored procedure tên calculatebonuspoints nhận hai tham số:
-- p_user_id (int, in) – id của user
-- p_bonus_points (int, inout) – điểm thưởng ban đầu

delimiter //

create procedure calculate_bonus_point (
    in p_user_id int,
    inout p_bonus_points int
)
begin 
    declare total_user_posts int default 0;

    -- đếm số lượng bài viết của user
    select count(post_id)
    into total_user_posts
    from posts
    where user_id = p_user_id;

    -- cộng điểm thưởng
    if total_user_posts >= 20 then
        set p_bonus_points = p_bonus_points + 100;
    elseif total_user_posts >= 10 then
        set p_bonus_points = p_bonus_points + 50;
    end if;

end //

delimiter ;
-- 3) gọi thủ tục trên với giá trị id user và p_bonus_points bất kì mà bạn muốn cập nhật
select * from posts;

set @p_bonus_points = 100;
call calculate_bonus_point(15, @p_bonus_points);

-- 4) select ra p_bonus_points 
select @p_bonus_points;

-- 5) Xóa thủ tục mới khởi tạo trên 
drop procedure if exists calculate_bonus_point;




-- Bai 4

-- 2) Viết procedure tên CreatePostWithValidation nhận IN p_user_id (INT), IN p_content (TEXT). 
-- Nếu độ dài content < 5 ký tự thì không thêm bài viết và SET một biến thông báo lỗi (có thể dùng OUT result_message VARCHAR(255) 
-- để trả về thông báo “Nội dung quá ngắn” hoặc “Thêm bài viết thành công”).

delimiter //
create procedure create_post_with_validation (
	in p_user_id int,
    in p_content text,
    out result_message varchar (255)
) 
begin
	if(length(p_content) >= 5) then  
		insert into posts (user_id, content) values (p_user_id, p_content);
		set result_message = 'Thêm bài viết thành công';
        select result_message;
	else 
		set result_message = 'Nội dung quá ngắn';
        select result_message;
        end if;

end //
delimiter ;

-- 3) Gọi thủ tục và thử insert các trường hợp  Kiểm tra các kết quả

call create_post_with_validation(5, 'haha', @result_message);
call create_post_with_validation(5, ' hehehe', @result_message);
call create_post_with_validation(5, 'haha ', @result_message);

-- 5) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists create_post_with_validation;


-- Bai 5
-- 2)Viết procedure tên CalculateUserActivityScore nhận IN p_user_id (INT), trả về OUT activity_score (INT). 
-- Điểm được tính: mỗi post +10 điểm, mỗi comment +5 điểm, mỗi like nhận được +3 điểm. 
-- Sử dụng CASE hoặc IF để phân loại mức hoạt động (ví dụ: >500 “Rất tích cực”, 200-500 “Tích cực”, <200 “Bình thường”) 
-- và trả thêm OUT activity_level (VARCHAR(50)).

delimiter //
create procedure calculate_user_activity_score (
	in p_user_id int,
    inout activity_score int,
    out activity_level varchar(255)
)

begin
	declare total_posts int default 0;
	declare total_comments int default 0;
    declare total_likes int default 0;
    
    select count(post_id) into total_posts from posts where user_id = p_user_id;
    select count(comment_id) into total_comments from comments where user_id = p_user_id;
    select count(total_likes) into total_likes from likes where user_id = p_user_id; 
    
    set activity_score = activity_score + (total_posts*10 + total_comments*5 + total_likes*3);
    
    if(activity_score > 500) then 
    set activity_level = 'Rất tích cực';
    elseif (activity_score>= 200 and activity_score<=500) then
    set activity_level = 'Tích cực';
    elseif(activity_score < 200) then 
    set activity_level = 'Bình thường';
    end if;
    
    select activity_score, activity_level;
end //
delimiter ;

-- Gợi ý: Dùng các SELECT COUNT riêng cho posts, comments, likes (JOIN posts và likes), tính tổng điểm, sau đó dùng CASE để xác định level.

-- 3) Gọi thủ tục trên select ra activity_score và activity_level
set @activity_score = 200;
call calculate_user_activity_score(10, @activity_score, @activity_level);

-- 4) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists calculate_user_activity_score;






-- Bai 6
-- 2)  Viết stored procedure tên NotifyFriendsOnNewPost nhận hai tham số IN:

-- p_user_id (INT) – ID của người đăng bài
-- p_content (TEXT) – Nội dung bài viết

delimiter //
create procedure notify_friends_on_newpost (
	in p_user_id int,
    in p_content text
)
begin 
	insert into posts (user_id, content) values (p_user_id, p_content);
    insert into notifications (user_id, type, content, is_read)
	select f.friend_id, 'new_post', concat((select full_name from users where user_id = p_user_id), ' đã đăng một bài viết mới'), 0
	from friends f where f.user_id = p_user_id and f.status = 'accepted' and f.friend_id <> p_user_id;
end //
delimiter ;

-- Procedure sẽ thực hiện hai việc:
select * from notifications order by created_at desc;

-- 3) Gọi procedue trên và thêm bài viết mới 
call notify_friends_on_newpost(12, 'Bài học hôm nay khoai phết');

-- 4) Select ra những thông báo của bài viết vừa đăng
select * from notifications order by created_at desc limit 5;

-- 5) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists notify_friends_on_newpost;




