create database sesson15_student_management;
use sesson15_student_management;

-- table students
create table students(
	student_id char(5) primary key,
	fullname varchar(50) not null,
	total_debt decimal(10, 2) default(0)
);

-- table subjects
create table subjects(
	subject_id char(5) primary key,
    subject_name varchar(50) not null, 
    credits int check(credits > 0)
);

-- Table: Grades
CREATE TABLE grades (
    student_id CHAR(5),
    subject_id CHAR(5),
    score DECIMAL(4,2) CHECK (score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Table: GradeLog
CREATE TABLE gradelog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    student_id CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO students (student_id, fullname, total_debt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO subjects (subject_id, subject_name, credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO grades (student_id, subject_id, score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed




-- Câu 1 (Trigger - 2đ): Nhà trường yêu cầu điểm số (Score) nhập vào hệ thống phải luôn hợp lệ (từ 0 đến 10). 
-- Hãy viết một Trigger có tên tg_CheckScore chạy trước khi thêm (BEFORE INSERT) dữ liệu vào bảng Grades.
-- Nếu người dùng nhập Score < 0 thì tự động gán về 0.
-- Nếu người dùng nhập Score > 10 thì tự động gán về 10.
delimiter // 
create trigger tg_CheckScore before insert on grades 
for each row
begin 
	if(new.score < 0) then set new.score = 0;
    elseif(new.score > 10) then set new.score = 10;
    end if;
end //
delimiter ;

insert into grades(student_id, subject_id, score) values ('SV03', 'SB03', -9);
insert into grades(student_id, subject_id, score) values ('SV03', 'SB03', 15);



-- Câu 2 (Transaction - 2đ): Viết một đoạn script sử dụng Transaction để thêm một sinh viên mới. 
-- Yêu cầu đảm bảo tính trọn vẹn "All or Nothing" của dữ liệu:
-- Bắt đầu Transaction.
-- Thêm sinh viên mới vào bảng Students: StudentID = 'SV02', FullName = 'Ha Bich Ngoc'.
-- Cập nhật nợ học phí (TotalDebt) cho sinh viên này là 5,000,000.
-- Xác nhận (COMMIT) Transaction.

start transaction;
insert into students (student_id, fullname) values ('SV02', 'Ha Bich Ngoc');
update students set total_debt = 5000000 where student_id = 'SV02';
commit;





-- Câu 3 (Trigger - 1.5đ): Để chống tiêu cực trong thi cử, mọi hành động sửa đổi điểm số cần được ghi lại. 
-- Hãy viết Trigger tên tg_LogGradeUpdate chạy sau khi cập nhật (AFTER UPDATE) trên bảng Grades.
-- Yêu cầu: Khi điểm số thay đổi, hãy tự động chèn một dòng vào bảng GradeLog với các thông tin: 
-- StudentID, OldScore (lấy từ OLD), NewScore (lấy từ NEW), và ChangeDate là thời gian hiện tại (NOW()).

delimiter //
create trigger trigger_log_grade_after_update after update on grades
for each row
begin 
	if(old.score <> new.score) then 
		insert into gradelog (student_id, oldscore, newscore, change_date) values (old.student_id, old.score, new.score, now());
	end if;
end //
delimiter ;




-- Câu 4 (Transaction & Procedure cơ bản - 1.5đ): Viết một Stored Procedure đơn giản tên sp_PayTuition 
-- thực hiện việc đóng học phí cho sinh viên 'SV01' với số tiền 2,000,000.
-- Bắt đầu Transaction.
-- Trừ 2,000,000 trong cột TotalDebt của bảng Students (StudentID = 'SV01').
-- Kiểm tra logic: Nếu sau khi trừ, TotalDebt < 0, hãy ROLLBACK để hủy bỏ. Ngược lại, hãy COMMIT.

delimiter //
create procedure sp_PayTuition (
    p_student_id char(5),
    p_tuition decimal(10,2)
)
begin
    start transaction;
    update students set total_debt = total_debt - p_tuition where student_id = p_student_id;
    if (select total_debt from students where student_id = p_student_id) < 0 then 
		rollback;
    else
        commit;
    end if;
end //
delimiter ;




-- Câu 5 (Trigger nâng cao - 1.5đ): Viết Trigger tên tg_PreventPassUpdate.
-- Quy tắc nghiệp vụ: Sinh viên đã qua môn (Điểm cũ >= 4.0) thì không được phép sửa điểm nữa để đảm bảo tính minh bạch.
-- Yêu cầu: Viết trigger BEFORE UPDATE trên bảng Grades. Nếu OldScore (OLD.Score) >= 4.0, 
-- hãy hủy thao tác cập nhật bằng cách phát sinh lỗi (Sử dụng SIGNAL SQLSTATE với thông báo lỗi tùy ý).





