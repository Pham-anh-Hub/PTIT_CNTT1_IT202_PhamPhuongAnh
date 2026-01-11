CREATE DATABASE social_network_sesson09;

use social_network_sesson09;

select * from users;

-- 2) Tạo một view có tên view_users_firstname để hiển thị danh sách các người dùng có họ “Nguyễn”. View này cần bao gồm các cột: user_id, username, full_name, email, created_at.
create or replace view view_users_firstname as 
select user_id, username, full_name, email, created_at from users where  full_name like 'Nguyễn%';

-- 3) Tiến hành hiển thị lại view vừa tạo được.
select * from view_users_firstname;

-- 4) Thêm một nhân viên mới vào bảng User có họ “Nguyễn”.
insert into users ( username, password, full_name, email) values 
('lan', 'nan12345','Nguyễn Thị Lan', 'ntl@gmail.com');
-- Sau đó, truy vấn lại view view_users_firstname để kiểm tra xem nhân viên vừa thêm có xuất hiện trong view hay không.
select * from view_users_firstname;


-- 5)  Thực hiện xóa nhân viên vừa thêm khỏi bảng Users
delete from users where username = 'lan';
-- Sau đó, truy vấn lại view view_users_firstname để kiểm tra xem nhân viên vừa bị xóa có còn xuất hiện trong view không.
select * from view_users_firstname;


-- Bai 2:

-- 2) Tạo một view tên view_user_post hiển thị danh sách các User với các cột: user_id(mã người dùng) và total_user_post (Tổng số bài viết mà từng người dùng đã đăng).
create or replace view view_user_post as 
select p.user_id, count(*) as total_user_post from users u join posts p on p.user_id = u.user_id group by user_id;

-- 3) Tiến hành hiển thị lại view_user_post để kiểm chứng
select * from view_user_post;

-- 4) Kết hợp view view_user_post với bảng users để hiển thị các cột: full_name(họ tên) và  total_user_post (Tổng số bài viết mà từng người dùng đã đăng).
select full_name, total_user_post from view_user_post vup join users u on u.user_id = vup.user_id; 




-- BAI 3:
--  Viết câu truy vấn Select tìm tất cả những User ở Hà Nội. Sử dụng EXPLAIN ANALYZE để kiểm tra truy vấn thực tế.
explain analyze
select * from users where hometown='Hà Nội';

-- 3) Tạo một chỉ mục có tên idx_hometown cho cột hometown của bảng User. 
create index idx_hometown on users(hometown);

-- 4) Chạy lại yêu cầu số (2) với EXPLAIN ANALYZE để kiểm tra kết quả sau khi đánh chỉ mục . So sánh kết quả trước và sau khi đánh chỉ mục.
explain analyze
select * from users where hometown='Hà Nội';

-- 6) Hãy xóa chỉ mục idx_hometown khỏi bảng user.
drop index idx_hometown on users;



-- Bai 4
-- 2) Tạo chỉ mục phức hợp (Composite Index)
-- Tạo một truy vấn để tìm tất cả các bài viết (posts) trong năm 2026 của người dùng có user_id là 1. Trả về các cột post_id, content, và created_at.
select post_id, content, created_at from posts where user_id=1  and year(created_at)=2026;

-- Tạo chỉ mục phức hợp với tên idx_created_at_user_id trên bảng posts sử dụng các cột created_at và user_id.
create index idx_created_at_user_id on posts(created_at, user_id);

-- Sử dụng EXPLAIN ANALYZE để kiểm tra kế hoạch thực thi của truy vấn trên trước và sau khi tạo chỉ mục idx_created_at_user_id. So sánh kết quả thực thi giữa hai lần này.
explain analyze
select post_id, content, created_at from posts where user_id=1 and year(created_at)=2026;


--     3) Tạo chỉ mục duy nhất (Unique Index)
-- Tạo một truy vấn để tìm tất cả các người dùng (users) có email là 'an@gmail.com'. Trả về các cột user_id, username, và email.
select user_id, username, email from users where email='an@gmail.com';

-- Tạo chỉ mục duy nhất với tên idx_email trên cột email trong bảng users.
create unique index idx_email on users(email);

-- Sử dụng EXPLAIN ANALYZE để kiểm tra kế hoạch thực thi của truy vấn trên trước và sau khi tạo chỉ mục idx_email. So sánh kết quả thực thi giữa hai lần này.
explain analyze 
select user_id, username, email from users where email='an@gmail.com';

--     4) Xóa chỉ mục
-- Xóa chỉ mục idx_created_at_user_id khỏi bảng posts.
drop index idx_created_at_user_id on posts;
-- Xóa chỉ mục idx_email khỏi bảng users.
drop index idx_email on users;




-- Bai 5:
--     2) Tạo chỉ mục có tên idx_hometown trên cột hometown của bảng users
create index idx_hometown ON users(hometown);

--     3) Thực hiện truy vấn với các yêu cầu sau:
-- Viết một câu truy vấn để tìm tất cả các người dùng (users) có hometown là "Hà Nội"
select * from users where hometown='Hà Nội';

-- Kết hợp với bảng posts để hiển thị thêm post_id và content về các lần đăng bài.
select u.*, post_id, content from users u join posts p on p.user_id=u.user_id and u.hometown='Hà Nội' ;

-- Sắp xếp danh sách theo username giảm dần và giới hạn kết quả chỉ hiển thị 10 bài đăng đầu tiên.
select u.*, post_id, content from users u join posts p on p.user_id=u.user_id and u.hometown='Hà Nội' order by username desc limit 10 offset 0;

--      4) Sử dụng EXPLAIN ANALYZE để kiểm tra lại kế hoạch thực thi trước và sau khi có chỉ mục.
drop index idx_hometown on users;
select u.*, post_id, content from users u join posts p on p.user_id=u.user_id and u.hometown='Hà Nội';

create index idx_hometown ON users(hometown);
explain analyze
select u.*, post_id, content from users u join posts p on p.user_id=u.user_id and u.hometown='Hà Nội';



-- Bài 6
-- 2) Tạo một view tên view_users_summary để thống kê số lượng bài viết của từng người dùng.user_id (Mã người dùng), username (Tên người dùng), 
-- total_posts (Tổng số lượng bài viết của người dùng)
create or replace view view_users_summary as
select u.user_id, u.username, count(p.post_id) as total_posts
from users u
left join posts p on p.user_id = u.user_id
group by u.user_id, u.username;

-- 3) Truy vấn từ view_users_summary để hiển thị các thông tin về user_id, username và total_posts của các người dùng có total_posts lớn hơn 5.
select * from view_users_summary;



--  Bai 7

-- 2) Tạo một view với tên view_user_activity_status hiển thị các cột:  user_id , username, gender, created_at, status. Trong đó status được xác định như sau: 

-- "Active" nếu người dùng có ít nhất 1 bài viết hoặc 1 bình luận.
-- "Inactive" nếu người dùng không có bài viết và không có bình luận.
create or replace view view_user_activity_status as
select  u.user_id, u.username, u.gender, u.created_at,
    case
        when count(distinct p.post_id) > 0 or count(distinct c.comment_id) > 0
        then 'Active'
        else 'Inactive'
    end as status
from users u
left join posts p on p.user_id = u.user_id
left join comments c on c.user_id = u.user_id
group by u.user_id, u.username, u.gender, u.created_at;

-- 3) Truy vấn view view_user_activity_status và kiểm tra kết quả thu được. Dưới đây là bảng kết quả tượng trưng:
select * from view_user_activity_status;

-- 4)Truy vấn view view_user_activity_status để thống kê số lượng người dùng theo từng trạng thái (Active, Inactive). Thông tin bao gồm: Tên trạng thái (status) và Số lượng người dùng (user_count), sắp xếp theo số lượng người dùng giảm dần.
select status, count(*) as user_count from view_user_activity_status group by status order by user_count desc;

    
    
    
-- Bai 8

-- 2) Tạo một index idx_user_gender trên cột gender của bảng users.
create index idx_user_gender on users(gender);

-- 3) Tạo một View tên view_popular_posts để lưu trữ post_id, username người đăng,content(Nội dung bài viết), số like, số comment (sử dụng JOIN giữa posts, users, likes, comments; GROUP BY post_id).
create or replace view view_popular_posts as
select
    p.post_id,
    u.username,
    p.content,
    count(distinct l.user_id) as like_count,
    count(distinct c.comment_id) as comment_count
from posts p
join users u on u.user_id = p.user_id
left join likes l on l.post_id = p.post_id
left join comments c on c.post_id = p.post_id
group by
    p.post_id,
    u.username,
    p.content;

-- 4) Truy vấn các thông tin của view view_popular_posts 
select * from view_popular_posts;

-- 5) viết query sử dụng View này để liệt kê các bài viết có số like + comment > 10, ORDER BY tổng tương tác giảm dần.
select post_id, username, content, like_count, comment_count, (like_count + comment_count) as total_interactions
from view_popular_posts
where (like_count + comment_count) > 10
order by total_interactions desc;


-- Bai 9
-- 2)Tạo một index có tên idx_user_gender trên cột gender của bảng users:
create index idx_user_gender on users(gender);

-- 3) Tạo một view tên view_user_activity để hiển thị tổng số lượng bài viết và bình luận của mỗi người dùng. Các cột trong view bao gồm: user_id (Mã người dùng), total_posts (Tổng số bài viết), total_comments (Tổng số bình luận).
create or replace view view_user_activity as
select u.user_id, count(distinct p.post_id) as total_posts, count(distinct c.comment_id) as total_comments
from users u
left join posts p on p.user_id = u.user_id
left join comments c on c.user_id = u.user_id
group by u.user_id;

-- 4) Hiển thị lại view trên. 
select * from view_user_activity;

-- 5) Viết truy vấn kết hợp view_user_activity với bảng users để lấy thông tin người dùng:

-- - Điều kiện: total_posts > 5 và total_comments > 20.
-- - Sắp xếp theo total_comments (Tổng số bình luận) giảm dần.
-- - Giới hạn kết quả hiển thị 5 bản ghi đầu tiên.

select u.user_id, u.username, u.gender, v.total_posts, v.total_comments
from users u
join view_user_activity v on v.user_id = u.user_id
where v.total_posts > 5
  and v.total_comments > 20
order by v.total_comments desc
limit 5;

