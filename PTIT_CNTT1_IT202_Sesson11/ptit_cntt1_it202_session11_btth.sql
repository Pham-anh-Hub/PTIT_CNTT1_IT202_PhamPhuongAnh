create database football_sql_sesson11;
use football_sql_sesson11;

CREATE TABLE doi_bong (
    ma_doi_bong CHAR(15) NOT NULL PRIMARY KEY,
    ten_doi_bong VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE tt_thi_dau (
    ma_tran_dau INT NOT NULL,
    ngay_thi_dau DATE,
    ma_doi_bong CHAR(15) NOT NULL,
    so_ban_thang INT CHECK (so_ban_thang >= 0),
    so_ban_thua INT CHECK (so_ban_thua >= 0),
    diem INT CHECK (diem >= 0 AND diem <= 3),
    PRIMARY KEY (ma_tran_dau , ma_doi_bong)
);

insert into doi_bong(ma_doi_bong,ten_doi_bong) values
('MU','Manchester United'),
('ARS','Arsenal'),
('LIV','Liverpool');

insert into tt_thi_dau(ma_tran_dau,ngay_thi_dau,ma_doi_bong,so_ban_thang,so_ban_thua) values
(1,'2025-10-22','MU',3,1),
(1,'2025-10-22','ARS',1,3),
(2,'2025-10-30','MU',2,2),
(2,'2025-10-30','LIV',2,2),
(3,'2025-11-10','ARS',0,2),
(3,'2025-11-10','LIV',2,0);

-- Tạo các thủ tục sau:
-- 1.	Thủ tục thêm 1 đội bóng mới
delimiter // 
create procedure insert_new_doi_bong (
	in ma_doi_bong_in CHAR(15),
	in ten_doi_bong_in VARCHAR(100)
)

begin 
	insert into doi_bong (ma_doi_bong, ten_doi_bong) values (ma_doi_bong_in, ten_doi_bong_in);
end //
delimiter ;




-- 2.	Thủ tục cập nhật thông tin 1 đội bóng
delimiter //
create procedure update_info_doi_bong (
	in ma_doi_bong_ud char(15),
    in ten_doi_bong_ud varchar(100)
) 
begin 
	update doi_bong set ten_doi_bong = ten_doi_bong_ud where ma_doi_bong = ma_doi_bong_ud;
end //
delimiter ;

-- 3.	Thủ tục xoá thông tin đội bóng
delimiter //
create procedure delete_doi_bong(
	in ma_doi_bong_del char(15)
) 
begin 
	delete from doi_bong where ma_doi_bong=ma_doi_bong_del;
end //
delimiter ;

-- 4.	Thủ tục lấy dữ liệu đội bóng, có phân trang
delimiter //
create procedure select_doi_bong(
	in current_page int,
    in record_per_page int
) 
begin 
	declare page_offset int;
    set page_offset = (current_page-1)*record_per_page;
    select * from doi_bong limit record_per_page offset page_offset;
end //
delimiter ;

-- 5.	Thủ tục thêm mới thông tin thi đấu
delimiter //
create procedure insert_new_match (
	ma_tran_dau INT,
    ngay_thi_dau DATE,
    ma_doi_bong CHAR(15),
    so_ban_thang INT,
    so_ban_thua INT
)
begin
	insert into tt_thi_dau (ma_tran_dau, ngay_thi_dau, ma_doi_bong, so_ban_thang, so_ban_thua) values (ma_tran_dau, ngay_thi_dau, ma_doi_bong, so_ban_thang, so_ban_thua);
end //
delimiter ;
-- 6.	Thủ tục cập nhật dữ liệu điểm (thắng – 3 điểm, hoà – 1 điểm, thua – 0 điểm)

delimiter //
create procedure update_diem_thi_dau ()
begin
	update tt_thi_dau set diem = (
			case when so_ban_thang - so_ban_thua > 0 then 3
			when so_ban_thang - so_ban_thua = 0 then 1
			when so_ban_thang - so_ban_thua < 0 then 0 end
		);
end //
delimiter ;

-- 7.	Thủ tục lấy dữ liệu thông tin thi đấu theo mã trận đấu
delimiter // 
create procedure select_tt_thi_dau (
	in ma_tran_dau_in int
)
begin 
	select * from tt_thi_dau where ma_tran_dau=ma_tran_dau_in;
end //
delimiter ;

call select_tt_thi_dau(3);

-- 8.	Thủ tục thống kê số trận đấu, số trận thắng, số trận thua, hệ số bàn thắng, điểm
delimiter //
create procedure pro_statistical_football()
begin
	select db.ma_doi_bong,db.ten_doi_bong,
    (select count(ma_doi_bong) from tt_thi_dau where ma_doi_bong=db.ma_doi_bong) as 'Số trận đấu',
    (select count(ma_doi_bong) from tt_thi_dau where ma_doi_bong=db.ma_doi_bong and diem=3) as 'Số trận thắng',
    (select count(ma_doi_bong) from tt_thi_dau where ma_doi_bong=db.ma_doi_bong and diem=0) as 'Số trận thua',
    (select sum(so_ban_thang)-sum(so_ban_thua) from tt_thi_dau where ma_doi_bong=db.ma_doi_bong) as 'Hệ số bàn thắng',
    (select sum(diem) from tt_thi_dau where ma_doi_bong=db.ma_doi_bong) as 'Tổng điểm'
    from doi_bong db;
end //
delimiter ;


select * from tt_thi_dau;
-- Gọi thủ tục upate điểm thi đấu
call pro_statistical_football();


