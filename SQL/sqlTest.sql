use DB;

-- create table 课程表
-- (
-- 课程号 char(9) primary key not null,
-- 课名 varchar(50) not null,
-- 学时 int not null,
-- 学分 float not null,
-- 备注 text null
-- );

-- select * from 课程表;
-- desc 课程表;
-- show tables;

-- create table 学生表
-- (
-- 学号 char(9) primary key not null,
-- 姓名 char(8) not null,
-- 性别 char(1), -- 0 男, 1 女
-- 专业 varchar(50) not null,
-- 出生年月 datetime null,
-- 家庭住址 varchar(90) null,
-- 联系方式  char(11) null,
-- 总学分 float default(0)
-- )

-- create table 选课表
-- (
-- 学号 char(9) not null,
-- 课程号 char(9) not null,
-- 成绩 float null,
-- primary key(学号, 课程号),
-- foreign key(学号) references 学生表(学号),
-- foreign key(课程号) references 课程表(课程号)
-- )

-- show tables;

-- create table 部门表
-- (
-- 部门编号 char(5) not null primary key,
-- 部门名称 varchar(50) not null,
-- 部门地址 varchar(100) null
-- )

-- create table 教师表
-- (
-- 教师号 char(6) not null primary key,
-- 姓名 char(8) not null,
-- 职称 char(8) not null,
-- 部门编号 char(50) not null,
-- 联系方式 char(12) null,
-- foreign key(部门编号) references 部门表(部门编号)
-- )

-- create table 授课表
-- (
-- 教师号 char(6) not null,
-- 课程号 char(9) not null,
-- 开课时间 datetime,
-- primary key(教师号,课程号),
-- foreign key(教师号) references 教师表(教师号),
-- foreign key(课程号) references 课程表(课程号)
-- )

show tables;
desc 教师表;
use DB;
-- insert into 部门表 values('1', '计算机',null);
-- insert into 部门表 values('2', '非计算机',null);

-- insert into 教师表 values('j1001','胜','教授','1','13202151567');
-- insert into 教师表 values('j1002','李培育','讲师','1','13578451278');
-- insert into 教师表 values('j1003', '张为民', '副教授', '1', '15787451256');

-- insert into 教师表 values('j1004', '张三', '讲师', '1', '1123721356');
-- insert into 教师表 values('j1005', '李民', '教授', '2', '156234451256');
-- insert into 教师表 values('j1006', '王五', '讲师', '1', '18123141256');
-- insert into 教师表 values('j1007', '李流', '副教授', '2', '147873326');
-- insert into 教师表 values('j1008', '莎师大', '副教授', '1', '1323425324');


-- insert into 课程表 values('1001','数据库技术', 70, 4, '适合电子信息专业课程');
-- insert into 课程表 values('1002','C语言程序设计',70,4,'适合电子信息专业课程');
-- insert into 课程表 values('1004','网店运营',68,3,null);
-- insert into 课程表 values('1005','大学英语',70, 4, '不适合电子信息专业课程'); 
-- insert into 课程表 values('1006','计算机基础',60, 3, '适合电子信息专业课程'); 
-- insert into 课程表 values('1007','大学法律',70, 4, '不适合电子信息专业课程'); 


-- insert into 授课表 values('j1001','1001','2010/9/1');
-- insert into 授课表 values('j1002','1002','2011/2/7');
-- insert into 授课表 values('j1003','1004','2011/2/7');
-- insert into 授课表 values('j1004','1003','2011/2/7');
-- insert into 授课表 values('j1005','1005','2011/2/7');
-- insert into 授课表 values('j1006','1006','2011/2/7');
-- insert into 授课表 values('j1007','1007','2011/2/7');

-- insert into 学生表 values('01000101', '周建明', '男', '应用电子', '1991/7/22', '杭州文化路1号', '1351274563', 62);
-- insert into 学生表 values('01000102', '董山', '女', '应用电子', '1992/11/7', '金华光明路2号', '1364585214', 58);
-- insert into 学生表 values('01000103', '钱鑫鑫', '男', '应用电子', '1994/3/25', '温州学东路5号', '1375851245', 60);
-- insert into 学生表 values('01000104', '爱仕达', '男', '应子', '1994/3/25', '温州学东路5号', '1375851245', 60);

-- insert into 选课表 values('01000101','1004',90);
-- insert into 选课表 values('01000102','1002',91);
-- insert into 选课表 values('01000103','1004',85);

-- insert into 选课表 values('01000102','1003',82);
-- insert into 选课表 values('01000103','1005',85);
-- insert into 选课表 values('01000102','1006',92);
-- insert into 选课表 values('01000103','1007',75);

-- select * from 选课表;

select x.学号, y.姓名, x.成绩, z.课名 from  选课表 x
	join 学生表 y on x.学号 = y.学号
    join 课程表 z on x.课程号 = z.课程号 ;
   --  order by x.成绩  desc;
    
 select x.学号, x.姓名, z.课名, y.成绩 from 学生表 x 
	join 选课表 y on x.学号 = y.学号
	join 课程表 z on z.课程号  = y.课程号
		where 课名 = '大学英语' or 课名 = '计算机基础';

select x.教师号, x.姓名, z.课名, z.学时, z.学分 from 教师表 x
	join 授课表 y on x.教师号 = y.教师号
    join 课程表 z on z.课程号 = y.课程号;
    
 select x.教师号,x.姓名,z.课名,z.学时,z.学分 from 教师表 x
	join 授课表 y on x.教师号 = y.教师号
	join 课程表 z on z.课程号 = y.课程号
		where 课名 = '大学英语' or 课名 = '计算机基础';
        
        
select y.姓名, max(x.成绩), min(x.成绩), avg(x.成绩) from 选课表 x
	join 学生表 y on x.学号 = y.学号
    group by y.姓名;

select x.学号, x.姓名,z.课名, y.成绩 from 学生表 x
	join 选课表 y on y.学号 = x.学号
    join 课程表 z on z.课程号 = y.课程号
    where z.课名 like '大学英语' or z.课名 like '计算机基础';
    

select x.姓名, max(成绩), min(成绩), avg(成绩), sum(成绩) from 学生表 x
	join 选课表 y on x.学号 = y.学号
    join 课程表 z on z.课程号 = y.课程号
    group by x.姓名;
    
-- insert 课程表 values('1008', 'SQL', 80, 4, null);
select * from 课程表 ;
select * from 选课表 x
 right join 课程表 y on x.课程号 = y.课程号;
 
 select * from 授课表 x
	right join 课程表 y on x.课程号 = y.课程号;
    
    