
SQL

---

[back](../README.md)

#### Oracle的基本使用:
``` SQL
-- linux启动oracle数据库：
sqlplus sys/sys as sysdba --以系统管理员的登录
sqlplus / as sysydba
SQL > startup --启动数据库
SQL > shutdowon immeidata --关闭数据库服务
```

启动监听服务： 

	lsnrctl start 

^5cea0a

停止监听服务： ^f6b581

	 lsnrctl stop

使用普通用户登录oracle数据库：

	sqlplus scott/tiger@192.168.10.145:1521/orcl

使用sys用户登录oracle数据库：

	sqlplus sys/sys as sysdba

解锁用户：

	 alter user scott account unlock

锁定用户：

	 alter user scott account lock

修改用户密码：

	password scott

查看当前的语言环境：

	 select userenv('language') from dual;

sqlplus的基本操作：

``` SQL
desc tables; -- 查看表的结构
show user; -- 显示当前的用户
select  * from tab; -- 查看当前用户下的表
set linesize 140; -- 设置行宽
set pagsize 100; -- 设置页面显示的行数

col 字段 for 9999; -- 设置显示字段的宽度, 若字段的类型是number类型，用9，若字段类型是varchar，用a
col 字段 for a15;
```

sql基本语句

``` SQL
select col_1, col_2 ... from tabl_name
	where condition -- 一般过滤条件
	group by col_n .... -- group by 按照某些字段进行分组
	having condition -- 想要筛选某些分组，必须使用having
	order bt col_n ...
```

#### 查询操作
``` SQL
-- SELECT *|{[DISTINCT] column|expression [alias],...} FROM	table;

select * from emp; -- 1 查询所有员工的所有记录

select empno, ename, sal, comm, sal*12 from emp; -- 2 查询员工号，姓名，月薪，奖金，年薪

select empno, ename, sal as 工资, comm 奖金, sal*12 "年 薪" from emp; -- 3 对案例2使用别名
-- 关于别名的结论: (1) as可以省略； (2)如果别名中间有空格, 需要使用""引起来

select empno, ename, sal, comm, sal*12 年薪, sal*12+nvl(comm, 0) 年收入 from emp;　-- ４　查询员工号，姓名，月薪，奖金，年薪，年收入
-- 结论: (1)包含有null的表达式都为空; (2)nvl的用法: nvl(a, b): 如果a为空, 则取b的值.

select distinct deptno from emp; -- 5 查看员工表不同的部门编号

select distinct detpno, job from emp; -- 6 查看不同部门的不同工种
-- 结论:distinct的作用范围: distinct作用于后面出现的所有的列

select 3+20*5, sysdate from dual; -- 7 输出计算表达式 3+20*5，显示当前日期  sysdate
-- 注意: dual表是一个伪表, 主要是为了满足sql的语法规定
```

保存查询结果:

	spool名的使用: 
	spool d:\results.txt
	select * from emp;
	spool 

这样会将查询结果保存到文件中.


#### 使用比较运算符 
``` SQL
-- > >= < <= != (<>) between and 

select * from emp where deptno=10; -- 1 查询10号部门的员工信息

select * from emp where ename = 'KING'; -- 2 查询员工名字为king的员工信息
-- 结论: 表中的列的值是区分大小写的; 但是关键字不区分大小写

select * from emp where sal!=1250; -- 3 查找薪水不等于1250员工的信息
select * from emp where sal<>1250; -- 3 查找薪水不等于1250员工的信息

select * from emp where hiredate='1981-11-17'; --查询错误
select * from emp where hiredate='17-11月-81'; -- 4 查询入职日期为1981年11月17日的员工信息

select * from v$nls_parameters; -- 查询当前使用的日期格式
alter session set NLS_DATE_FORMAT='yyyy-mm-dd'; -- 修改日期格式
alter session set NLS_DATE_FORMAT='DD-MON-RR';	-- 修改成原有的格式 
-- 说明: 需要注意日期格式, 默认是DD-MON-RR

select * from emp where sal>=1000 and sal<=2000; -- 5 查找工资介于1000-2000之间的员工信息
select * from emp where sal between 1000 and 2000; -- 5 查找工资介于1000-2000之间的员工信息
-- 结论: between and是闭区间
```

#### 使用逻辑运算符
```  SQL
-- or and not

select * from emp where deptno=10 or deptno=20;	-- 1 查询10号部门或者20部门的员工信息

select * from emp where deptno=10 and sal=1300; -- 2 查询10号部门员工工资为1300的员工信息

select * from emp where hiredate>='1-2月-81' and hiredate<='31-1月-82';
select * from emp where hiredate between '1-2月-81' and '31-1月-82'; 
-- 3 查询81年2月(含2月)-82年2月(不含2月)入职的员工信息(大于等于81年2月1日，小于等于82年1月31日). 说明: 注意日期格式问题,注意月份单月不要在前面加0,否则会报错

-- -- -- -- --
-- 关于and or 操作符的sql优化问题:
-- where条件在进行逻辑表达式计算的时候,是从右往左进行的, 所以对于and来说, 要把容易出现假的放在最右边, 对于or来说, 要把容易出现真的表达式放在最右边.
-- where a and b and c and d;
-- where a or b or c or d; 
-- -- -- -- --

select * from emp where comm=null; -- 不正确的写法
select * from emp where comm is null; -- 4 查询奖金为空的员工信息-null

select * from emp where comm!=null; -- 5 查询奖金不为空的员工信息
select * from emp where comm is not null;
-- 关于null的在where条件中使用的结论: where条件后面为空应该用is null, where条件后面不为空使用is not null

-- -- -- -- --
-- 分析下面的sql语句:
select * from emp where deptno=10 or deptno=30 and sal=1250;
-- 注意: 在有or和and的where条件中, and的优先级比or高, 所以若表示10部门或者20部门, 且sal为1250的, 应该
select * from emp where (deptno=10 or deptno=30) and sal=1250;
-- 结论: 在where条件表达式中有or的时候, 应该使用()括起来 
-- -- -- -- --
```
#### in用于集合中
``` SQL
select * from emp where deptno=10 or deptno=20; -- 1 查询部门号是10或者20的员工信息
select * from emp where deptno in(10,20);

-- -- -- -- --
-- 思考: 可以在in的集合中使用null吗?
select * from emp where deptno in(10,20,null);
select * from emp where deptno=10 or deptno=20 or deptno=null;
-- -- -- -- --

select * from emp where deptno!=10 and deptno!=20; -- 2 查询不是10和20号部门的员工信息
select * from emp where deptno not in(10,20);

-- -- -- -- --
-- 思考: 若not in的集合中有null会怎么样呢?
select * from emp where deptno in(10,20,null);
select * from emp where deptno=10 or deptno=20 or deptno=null;
-- -> not in后面不能出现null
-- -- -- -- --
```

#### 使用模糊查找（like）
``` SQL
select * from emp where ename like 'S%'; -- 1 查询员工首字母是S的员工信息

select * from emp where empno like '79%'; -- 2 查询员工编号为79开头的员工信息

select * from emp where ename like '____'; -- 3 查询名字为四个字母长度的员工信息

-- 插入一条记录, 用于测试转义字符
insert into 
	emp(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
	values (1000, 'TOM_CAT', 'CLERK', 9999, to_date('23-01-1982', 'dd-mm-yyyy'), 1200.00, null, 10);   

select * from emp where ename like '%\_%' escape '\'; -- 4 查询员工姓名带_的员工信息, 使用escape显示指定'\'是一个转义字符
```

#### 排序操作
``` SQL
select  ... from ... 
	where condition 
	order by colname|alias|expr|number(序号)
-- order by有两种排序方法; 一种是升序, 一种是降序: 默认是升序的(asc), 降序为desc

select * from emp order by hiredate asc; -- 1 员工信息按入职日期先后排序
select * from emp order by hiredate;  --asc可以省略不写

select * from emp order by sal desc; -- 2 员工薪水按从大到小排序

select * from emp order by comm desc; -- 3 查询员工信息按奖金逆序
select * from emp order by comm desc nulls last;
-- 注意: null值表现为无穷大, 可以使用nulls last来使null放在最后

select * from emp order by deptno, sal desc; -- 4 员工信息按部门升序、薪水降序排列

-- -- -- -- --
-- 根据排序结果得出结论:
--asc和desc作用于最近的前面的一列
-- 按照多个列进行排序的时候, 先按照第一列进行排序, 若第一列相同,则按照第二列排序
-- -- -- -- --

-- 使用序号进行排序:(并说明什么序号)
select empno, ename, sal from emp order by 3; -- 5 查询员工编号, 员工姓名和工资, 按照序号(工资)进行排序
-- 序号: select后面出现的列的次序, 次序从1开始.

-- 使用别名进行排序
select empno, ename, sal, sal*12+nvl(comm, 0) yearcomm from emp order by yearcomm; -- 6 按员工的年收入进行排序

-- 使用表达式进行排序
select empno, ename, sal, sal*12  from emp order by sal*12; -- 7 按照员工的年薪进行排序

-- -- -- -- --
-- 关于排序的几点说明:
-- 1 要了解排序可以使用哪几种方式
-- 列名   序号   别名   表达式
-- 2 如果有多列进行排序, 应该如何排序, 可以结合案例理解.
-- 若有多列进行排序, 优先按第1列进行排序, 如果第1列相同,再按照第2列进行排序.
-- -- -- -- --
```

#### 单行函数
	单行函数:只对针对一行进行, 返回一行记录
###### 1.字符串相关函数

``` SQL
-- lower, upper, initcap, concat, ||, substr, instr, lpad, rpad, trim, replace, length, lengthb

select lower('HELLO WORLD') "小写", upper('Hello world') "大写", initcap('hello world') "首字母大写" from dual; -- 1 lower 小写, upper 大写, initcap	单词的首字母大写

select concat('hello ','world') from dual; -- 2 concat(连接符||)
-- 注意: concat函数只能连接两个字符串, 若想连接三个的话只能嵌套调用:
select concat(concat('hello ','world'), ' nihao') from dual;
select 'hello ' || 'world ' || 'nihao' from dual;
-- 注意: || 可以连接多个字符串, 建议使用||来连接字符串.

-- -- -- -- --
-- 总结: concat只能用于两个字符串的连接, ||可以用于多个字符串的连接, 在使用的使用建议尽量的使用||.
-- -- -- -- --

select substr('helloworld',1,3), substr('helloworld',1), substr('helloworld',-3) from dual; -- 3 substr(str,pos,len)截取字符串
-- 总结:pos是从1开始的, 若len为0表示从pos开始, 截取到最后, 若pos为负数, 表示从末尾倒数开始截取,

select instr('hello llo', 'llo'),  instr('hello llo', 'ow')from dual; -- 4 instr(str, substr):判断substr是否在str中存在, 若存在返回第一次出现的位置, 若不存在则返回0

select lpad('aaaa', 10, '$'), rpad('aaaa', 10, '#') from dual; -- 5 lpad和rpad--l(r)pad(str, len, ch):返回len长度的字符串, 如果str不够len的话, 在左(右)填充ch这个字符

select 'aaa'||trim('  hello world  ')||'bbb' from dual; -- 6 trim:去掉首部和尾部的空格,中间的空格不去掉
select trim('x' from 'xxxxxhello worldxxxxx') from dual; -- trim(c from str):去掉str中的c字符

select replace('hello world','llo','yy') from dual; -- 7 replace(str, old, new):将str字符串中的old字符串替换成new字符串

select length('hello world') 字符数, lengthb('hello world') 字节数 from dual; -- 8  length和lengthb
select length('哈喽我的') 字符数, lengthb('哈喽我的') 字节数 from dual; 
--注意:对于length函数一个汉字是一个字符, 对于lengthb函数,一个汉字占两个, 这两个函数对于普通字符串没有什么区别.
```

###### 2.数值函数 
``` SQL
-- round, trunc, mod, ceil, floor

select round(45.926, 2) 一, round(45.926, 1) 二, round(45.926, 0) 三, round(45.926, -1) 四, round(45.926, -2) 五 from dual; -- 1 round: 四舍五入

select trunc(45.926, 2) 一, trunc(45.926, 1) 二, trunc(45.926, 0) 三, trunc(45.926, -1) 四, trunc(45.926, -2) 五 from dual; -- trunc: 截取

select mod(1600, 300) from dual; -- 2 mod

select ceil(121/30), floor(121/30) from dual; -- 3 ceil:向上取整, floor:向下取整
```

###### 3.转换函数
``` SQl
-- to_char, to_number, to_date, 

select empno,sal,to_char(sal,'L9,999') from emp; -- 1 to_char,把薪水转换为本地货币字符型
select to_number('￥2,975','L9,999') from dual; --to_number,把上述某个结果转回数值型

select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss "今天是" day') from dual; --2 to_char, 显示 "yyyy-mm-dd hh24:mi:ss 今天是 星期几"

select to_date('2017-12-04 01:12:48 今天是 星期一', 'yyyy-mm-dd hh24:mi:ss "今天是" day') from dual;  -- to_date, 将上述输出字符串反转回日期

select * from emp where to_char(hiredate, 'YYYY-MM-DD')='1981-11-17'; -- --查询1981-11-17日入职的员工信息:
select * from emp where hiredate = to_date('1981-11-17', 'YYYY-MM-DD');

select 11+'22' from dual; -- oracle的隐式转换和显示转换:
select 11+to_number('22') from dual;
对于select 11+'22' from dual; -- 会做隐式转换, 将'22'转换成22

select '11' || 22 from dual;
select '11' || to_char(22) from dual;
对于select 11+'22' from dual; -- 会做隐式转换, 将22转换成'22'

select 11+'1a' from dual;  --报错, 1a不是数字, 所以不能转
-- 总结: 当没有明确转换函数的时候, 如果类型不一致, 会进行隐式转换, 隐式有一个前提, 它必须能转换, 但应尽量避免隐式转换。
```

#### 时间和日期函数
``` SQL
-- sysdate(), months_between(), add_month(), last_day(), next_day(), ronund(), trunc()

select sysdate from dual; --显示当前的系统日期, 在mysql中，必须sysdate()

select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') from dual; -- 显示当前的系统日期显示到秒  

select to_char(sysdate, 'day') from dual; -- 显示当前日期星期几

select sysdate-1 昨天,sysdate 今天,sysdate+1 明天 from dual; -- 显示昨天，今天，明天--oracle日期型+1代表加一天

select empno,ename,sysdate-hiredate 日,(sysdate-hiredate)/7 周,(sysdate-hiredate)/30 月,(sysdate-hiredate)/365 年 from emp; -- 计算员工工龄 可以按日，周，月，年 日期差减方法


select empno, ename, months_between(sysdate,hiredate), (sysdate-hiredate)/30 月 from emp; --日期函数 months_between  add_months  last_day  next_day

select add_months(sysdate, 2) from dual; --add_months:增加月份

select add_months(sysdate,12) from dual; --求明年的今天

select last_day(sysdate) from dual; --last_day:最后一天--指定日期所在月份的最后一天

select next_day(sysdate, '星期一') from dual; --next_day:求指定日期的下一个星期几

--round、trunc 对日期型数据进行四舍五入和截断	
select round(sysdate, 'month'), round(sysdate, 'year') from dual;
select trunc (sysdate, 'month'), trunc(sysdate, 'year') from dual;
```

#### 条件表达式
``` SQl
-- case
select empno, ename, job, sal "涨前薪水",
   case job
	 when 'PRESIDENT' then
	  sal + 1000
	 when 'MANAGER' then
	  sal + 800
	 else
	  sal + 400
   end "涨后薪水"
from emp;

-- decode
 select empno, ename, job, sal "涨前薪水",
	decode(job, 'PRESIDENT', sal + 1000,
		   'MANAGER', sal + 800,
		   sal + 400) "涨后薪水"
from emp;
```

#### 分组函数和分组数据
分组函数:也称之为组函数或者聚合函数
``` SQl
-- oracle提供的常用的分组函数有:sum, avg, count, max, min

-- 1 统计员工总数
select count(empno) from emp;

-- 2 统计工种总数
select count(job) from emp;
select count(distinct job) from emp;

-- 3 求员工的平均工资
select avg(sal) from emp;

-- 4 求员工的平均奖金
select avg(comm), sum(comm)/count(comm), sum(comm)/count(empno) from emp; 

-- 5 求员工表中最高工资和最低工资
select max(sal), min(sal) from emp;

--6 如何去掉分组函数的滤空功能呢??  --提示: nvl函数

-- 分组函数具有滤空功能.

-- -- -- -- -- 

-- 分组数据
-- select ..., count() from emp where ... group by .. 
-- 说明: 按照group by 后给定的表达式，将from后面的table进行分组, 针对每一组, 使用组函数。
-- group by x1, x2,.... 按照x1, x2....依次进行分组，分组优先级依次降低，在x1分组内再对x2进行分组操作


-- 1 统计各个部门的平均工资？
select deptno, avg(sal) from emp group by deptno;

-- 2 统计各个部门不同工种的平均工资?
select deptno, job, avg(sal) from emp group by deptno, job;

--请思考通过案例1和案例2得出什么样的结论??  select后面的列和group后面的列有什么关系?
select a, b, c.., count(f) from table group by a, b, c
-- [*] select后面没有出现在分组函数中的列名, 一定要出现在group by子句中.
-- [*] 换言之，select后出现的字段名，若不在分组函数内，则其一定要出现在group by中
-- 在group by子句中出现的列, 不要求一定出现在select后面的列中

--　3 统计各个部门平均工资高于2000?
select deptno, avg(sal) from emp group by deptno having avg(sal)>2000;
-- 对分组数据进行过滤, 不能够使用where, 应该使用having

-- 4 求10号部门员工的平均薪水
select deptno, avg(sal) from emp where deptno=10 group by deptno;
select deptno, avg(sal) from emp group by deptno having deptno=10;

-- 比较两种方法, 应该优先使用那种方法??
-- 第一种方法好, 原因是第一种是先对整个表的数据进行过滤, 然后在分组统计
-- 第二种方法, 是先对整个表进行分组统计, 然后再过滤
-- 如果表的数据量很大, 第一种方法效率要高于第二种.


-- 使用分组函数统计分组数据不当的情况:
select deptno, job, avg(sal) from emp group by deptno;
select deptno, avg(sal) from emp group by deptno, job;

-- where和having:
-- 1 where用于对数据的第一次过滤, having只能用于分组数据之后的过滤
-- 2 如果where和having同时出现了, 则where应该出现在having前面.
```

#### 其他对象

- 视图
``` SQL
-- 1 什么是视图:
-- 视图本身没有数据, 数据存储在表中

-- 2 如何创建视图
create view vm_emp 
	as select * from emp;
create or replace view vm_emp 
	as select * from emp;
create or replace view vm_emp 
	as select deptno, empno, ename from emp where deptno=10;
select view_name from user_views;

-- 3 如何删除视图
drop view vm_emp;

-- 4 使用视图的优点: 可以限制用户对某些数据的访问; 可以简化查询;	

-- 5 使用视图注意点: 不要通过视图去修改表的数据. 可以将视图设置为只读属性:with read only
create or replace view vm_emp as select * from emp with read only;
```

- 索引
``` SQL
-- 索引:使用是索引的目的是提高查询的效率.
-- 1 如何创建?
create index idx_emp on emp(empno);	

-- 2 如何删除
drop index idx_emp_bak;

-- 3 查询创建的索引?
select index_name from user_indexes;
select xxxx_name from user_xxxxs;

-- 4 索引的原理: 在查询的时候, where条件后面要使用创建索引的时候的列, oracle先查询索引表, 从索引表中找到该列的值对应的rowid, 找到rowid再从表中根据rowid找到那一行记录.

-- 5 注意点: 创建索引的列最后是值的分布很广泛且重复的概率很低.	

-- 使用索引的实验:
-- 没有索引的情况下: 创建一个表mytest, 往表中insert n条数据, 打开时间显示, 然后执行语句，记录一个时间
set timing on;
select * from mytest where id='88888';

-- 有索引的情况下: 给mytest创建一个索引，打开时间显示, 然后执行语句，记录一个时间
set timing on;
create index idx_mytest on mytest(id);
select * from mytest where id='88888';

-- 最后比较这两个时间, 时间短的表明查询效率高.
```

- 序列
``` SQL
-- 1 序列的用处: 由于表的主键要求是非空且唯一的, 为了保证主键是非空和唯一的, 可以使用序列.
-- 2 如何创建序列
 create sequence seq_mytest;
-- 3 序列的属性 currval 和 nextval, 但是第一次使用的时候先要取nextval的值.
-- 4 如何删除序列	
drop sequence seq_mytest;
```

- 同义词
``` SQL
-- 1 什么是同义词: 同义词就是别名.
-- 2 同义词使用的场合. xiaohong想访问scott用户的emp表, 需要scott用户给xiaohong赋访问emp表的权限, 然后使用xiaohong用户登录oracle, 为了在访问scott.emp表的时候不用再使用scott.emp,可以给scott.emp创建同义词;
grant select on emp to xiaohong;
sqlplus xiaohong/xiaohong@oracle;
SQL> select * from scott.emp;

-- 3 如何创建同义词:
create synonym emp for scott.emp;
 
-- 如何创建一个新的oracle用户, 使用sys用户创建新的用户和给这个新用户添加权限
create user xiaohei identified by xiaohei;
grant connect, resource to xiaohei;
grant create synonym to xiaohei;

-- 4 删除同义词:
drop synonym emp;
```
#### 多表查询
  笛卡尔积(作用是处理多表查询)，即全排列
  笛卡尔积行数=A表的行数\*B表的行数
  笛卡尔积列数=A表的列数+B表的列数

``` SQL
-- 1 等值连接, 内连接，取交集
select e.empno, e.ename, e.sal, d.dname from emp e, dept d 
	where e.deptno=d.deptno; -- In Oracle
select e.empno, e.ename, e.sal, d.dname from emp e 
	join dept d on e.deptno=d.deptno; -- In MySql

-- 2 不等值连接(结合笛卡尔积讲解)
select e.empno, e.ename, e.sal, s.grade from emp e, salgrade s 
	where e.sal between s.losal and s.hisal;

-- 3 回想分组函数
select d.deptno, d.dname, count(e.empno) from emp e, dept d 
	where e.deptno=d.deptno 
	group by d.deptno, d.dname;

-- 4 右外连接, 以右侧为主导结果集，因此右表中可能包含左表不存在的字段，因此要在Oracle中左表中加上‘(+)’，表示以右表为主导结果集
select d.deptno, d.dname, count(e.empno) from emp e, dept d 
	where e.deptno(+)=d.deptno 
	group by d.deptno, d.dname; -- In Oracle
select d.deptno, d.dname, count(e.enpno) from emp e 
	right join dept d on e.deptno=d.deptno 
	group by d.deptno, d.dname;

-- 5 左外连接，以左侧为主导结果集，因此右表中可能包含右表不存在的字段，因此要在Oracle中右表中加上‘(+)’，表示以左表为主导结果集
select d.deptno, d.dname, count(e.empno) from emp e, dept d 
	where d.deptno=e.deptno(+) 
	group by d.deptno, d.dname; -- In Oracle
select d.deptno, d.dname, count(e.empno) from emp e 
	left join  dept d on d.deptno=e.deptno(+) 
	group by d.deptno, d.dname; -- In MySql

--  解释一下count(*)和count(e.empno)的区别
--  count(*): 只要一行中有一个字段不为空就被统计上; count(e.empno): 只有e.empno不为空才会被统计上

-- 6 自连接
--查询员工信息：xxx的老板是 yyy
-- 分析: emp表中的mgr列表示员工的老板的员工编号, 可以将emp表分别看做员工表和老板表, 员工表的老板是老板表的员工:
select e.ename || ' 的老板是 ' ||  nvl(b.ename, ' HIS WIFE') from emp e, emp b where e.mgr=b.empno(+);

-- 7 子查询, 嵌套查询
-- select sal from emp where ename = 'SCOTT';  ---3000.00
-- select * from emp where sal>3000;
select * from emp where sal > (select sal from emp where ename = 'SCOTT');

-- select avg(sal) from emp where deptno=30;
-- select deptno, avg(sal) from emp group by deptno;
select deptno, avg(sal) from emp
	group by deptno
	having avg(sal) > (select avg(sal) from emp where deptno = 30);

-- select min(sal) from emp where deptno=30;  --950
-- select deptno, min(sal) from emp group by deptno;
-- select deptno, min(sal) from emp group by deptno having min(sal) > 950;
select deptno, min(sal) from emp
	group by deptno
	having min(sal) > (select min(sal) from emp where deptno = 30);

-- 8 子查询中的null值 [*]
select distinct mgr from emp;
select * from emp where empno not in (select distinct mgr from emp);
select * from emp where empno not in (select distinct mgr from emp where mgr is not null);
总结: not in 后面集合中不能出现null
empno not in(a, b, null)---> empno!=a and empno!=b and empno!=null;

-- 9 集合运算
-- union 两个集合相同的部分保留一份
-- union all 两个集合相同的部分都保留
-- intersect 两个集合交集只保留相同的部分
-- minus  集合A-集合B，减去A和B都有的部分, 保留A中与B不同的部分
select * from emp where deptno = 10 
	union select * from emp 
	where deptno in(20,10);
select * from emp where deptno = 10 
	union all select * from emp 
	where deptno in(20,10);
select * from emp where deptno = 10 
	intersect select * from emp 
	where deptno in(20,10);
select * from emp where deptno in(10,30) 
	minus  select * from emp 
	where deptno in(20,10);

-- 10 数据处理
-- DML data manipulation language 数据操作语言，对应 insert delete update select
-- DDL data definition language 数据定义语言, 对应 create, drop, truncate
-- DCL data control language 数据控制语言， 对应 grant, revoke, commit, rollback savepoint
-- DML语句:
	  -- insert语句: insert into tablename[col1,…] values(val1,…);
	    -- 插入全部列
		  	insert into dept values(51,'51name','51loc');
		-- 插入部分列
			insert into dept(deptno, dname) values(55, '55name');
		-- 隐式插入null
			insert into dept(deptno,dname) values(52,'52name');
		-- 显示插入null
			insert into dept(deptno,dname,loc) values(53,'53name',null);
        -- &符号的使用:
	        insert into dept(deptno, dname, loc) values(&t1, &t2, &t3);
      -- 拷贝表结构:
         create table tname_YYYY_MM_DD as select * from tname_xxxxx where 1=2; --- where条件为假, 只拷贝表结构

      -- 批量插入: insert into tname_bak select * from tname where .....;

      -- update语句: update tablename set col1=val1, col2=val where  cond;
         update emp set sal=sal+100 where ename='TOM_CAT';
         update emp set sal=null where ename='TOM_CAT';
         -- 注意: 在update的时候, null可以使用等号
         -- 注意: 在update的时候, 一定要使用where条件, 否则会修改表中所有的记录

      -- delete语句: delete from tablename where cond;
		 delete from emp where ename='TOM_CAT';
		 delete from dept where ename = &dpt;
		 -- 注意: 在使用delete删除的时候一定要有where条件, 否则会删除整个表的记录

      -- delete和truncate的区别: 
	      -- 1. delete逐条删除表"内容", truncate先摧毁表再重建。
			  -- (由于delete使用频繁，Oracle对delete优化后delete快于truncate)

		  -- 2. delete 是DML语句, truncate是DDL语句
			  -- DML语句可以闪回(flashback), DDL语句不可以闪回。闪回:做错了一个操作并且commit了, 对应的撤销行为）
		
		  -- 3. 由于delete是逐条操作数据，所以delete会产生碎片，truncate不会产生碎片。
		      --（同样是由于Oracle对delete进行了优化, 让delete不产生碎片）。两个数据之间的数据被删除, 删除的数据——碎片, 整理碎片, 数据连续, 行移动
		
		  -- 4. delete不会释放空间, truncate会释放空间
			  -- 用delete删除一张10M的表, 空间不会释放。而truncate会。所以当确定表不再使用，应truncate
		
		  -- 5. delete可以回滚rollback, truncate不可以回滚rollback

-- 11 事务
-- 数据库事务, 是由有限的数据库操作序列组成的逻辑执行单元, 这一系列操作要么全部执行, 要么全部放弃执行. 数据库事务由以下的部分组成:
	-- 	a 一个或多个DML语句
	--	b 一个 DDL(Data Definition Language – 数据定义语言) 语句
	--	c 一个 DCL(Data Control Language – 数据控制语言) 语句
	--  事务的特点：要么都成功，要么都失败。

-- 事务开始: 
	-- 事务以DML语句开始, 执行一系列的数据插入或者是修改操作
-- 事务结束: 
	-- 1 提交结束: commit;
	  -- 隐式提交: 执行了DDL语句(如create了一个表), 正常退出
	  
	-- 2 显示回滚: rollback;
	  -- 隐式回滚: 断电, 宕机, 异常退出等

   -- 事物的特性:原子性、一致性、隔离性、持久性

-- 保存点:使用保存点的目的是把一个大的事物分成几段进行保存, 类似于编写word文档的时候使用ctrl+s分段保存.
	create table testsp (tid number, tname varchar2(20)); 
	insert into testsp values(1, 'Tom');
	insert into testsp values(2, 'Mary');
	savepoint aaa; -- create aaa savepoint
	
	insert into testsp values(3, 'Moke');
	savepoint bbb; -- create bbb savepoint
	
	update testsp set tname='tomson' where tid=1;
	delete from testsp where tid=1;
	rollback to savepoint bbb;
	
			SQL> select * from testsp;
				   TID TNAME
			---------- --------------------
					 1 Tom
					 2 Mary
					 3 Moke
					 
	rollback to savepoint aaa; -- 此时不能再回退到bbb

			rollback ;--事务结束
			select * from testsp;
			-- 说明: 当执行commit或者rollback后保存点就会全部无效了.

-- 13 表的创建和管理:
	--创建前提条件：表空间的使用权限和create table的权限
	--表名的注意事项: 以字母开头, 长度不能超过30个字符, 不能是oracle的关键字或保留字, 不能与其他对象重名
	
	--创建表的语句: 	
		create table tbl(id number, name varchar2(20));
		insert into tbl values(01, 'xiaoliu');

	--在创建表的时候为某一列设置默认值
		  create table tbl(id number, name varchar2(20), hiredate date default sysdate);
	      insert into tbl(id, name) values(02, 'xiaohong');  -- 若没有插入hiredate的值, 则使用默认值
	      
	-- 通过已有的表创建一个表, 相当于表结构的复制
	      create table tbl_bak as select * from tbl where 1=2;
	      
	-- 修改表
		-- 增加一个列
			alter table tbl add email varchar2(30);
		-- 修改列属性
			alter table tbl modify email varchar2(40);
		-- 重命名列
			alter table tbl rename column email to address;
		-- 删除列
			alter table tbl drop column address;
				
	-- 表名的重命名
		rename t1 to t2;
	
	--删除表
		drop table tbl;       --删除的表可以闪回
		drop table tbl purge; --purge的作用删除不经过回收站, 删除的表不可以闪回
			
-- 14 表的闪回:删除的表恢复回来
	--实现过程: 
		1 create table tbl(id number, name varchar2(20));
		2 drop table tbl;
		3 select * from tab;    ---看tname那一列
		4 show recyclebin;      ----看ORIGINAL NAME那一列
		5 flashback table tbl to before drop;
		
	-- 假如: drop table tbl purge; 则不能闪回了
		1 drop table tbl purge;
		2 select * from tab;
		3 show recyclebin;
		4 flashback table tbl to before drop;表的闪回:删除的表恢复回来
	
	-- 实现过程: 
		1 create table tbl(id number, name varchar2(20));
		2 drop table tbl;
		3 select * from tab;    ---看tname那一列
		4 show recyclebin;      ----看ORIGINAL NAME那一列
		5 flashback table tbl to before drop;
		
	-- 假如: drop table tbl purge; 则不能闪回了
		1 drop table tbl purge;
		2 select * from tab;
		3 show recyclebin;
		4 flashback table tbl to before drop;

-- 15 Oracle表的约束:
	-- ○ 检查 (值是否符合预设的规则) check
	-- ○ 非空 not null 
	-- ○ 唯一 (不能重复) unique
	-- ○ 主键（非空+唯一） primary key
	-- ○ 外键 (取值必须在另外一个表中存在) references 

	create table student(
		id number constraint pk_student primary key,   ---主键(非空唯一)
		name varchar2(30)  not null,                   --非空
		email varchar2(30) unique,                     --唯一
		sex varchar2(10) check(sex in ('男','女')),    --check约束
		sal number check(sal>10000),                   --check约束
		deptno number(2) references dept_bak(deptno) on delete set null  --当dept_bak表的数据被删除以后, 该列设置为null
	);
```

---

####  MySQL

MySql客户端连接不上数据库
``` SQL
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
flush privileges;

-- 如果还无法登录就关闭系统防火墙  
-- 在linux关闭防火墙, 然后重启系统生效
chkconfig iptables on 
chkconfig iptables off

-- 即时生效，重启后失效 
service iptables start 
service iptables stop 
```

将sql文件的数据导入到mysql中:  source \*.sql

- 数据库CURD: 对数据库进行增(create)、删(delete)、改(update)、查(Retrieve)操作。

1. 数据库CURD
``` SQL
	mysql数据库: root用户 > 库 > 表
	oracle数据库: 数据库 > 用户 > 表
	
	-- 1 创建数据库
		-- 创建数据库, 默认为latin1
		create database mydb1;
		
		-- 指定字符集为utf8
		create database mydb2 character set utf8;
		
		---指定字符集为utf8,并对插入的数据进行检查
		create database mydb3 character set utf8 collate utf8_general_ci;

	-- 2 查看数据库
		--显示所有数据库
		show databases;
		--显示创建数据库的语句信息
		show create database mydb1;
		
		-- 注意 ：mysql默认语言集是latin1，每次在创建数据库的时候应指定字符集.

	-- 3 修改数据库
		--修改mydb1的字符集为utf8(不能修改数据库名)
		alter database mydb1 character set utf8;

	-- 4 删除数据库
		drop database mydb1;
```

2. 表的CURD
``` SQL
-- 对表本身进行操作：创建，查看，修改，删除

-- 在创建表之前要先指定使用哪个库, 先查看一下有哪些库:
-- 查看有哪些库:
show databases;
--使用指定的库:
use scott;

--创建表常用到的数据类型: 
--常用的数据类型:
-- int  double  char  varchar  time

-- 1 创建表
create table employee(empno int, ename varchar(20), sal int);

-- 2 查看表
show tables;

-- 查看表的创建语句
show create table emp;

-- 查看表结构
desc emp;

-- 3 修改表
-- 更改表名
rename table employee to worker;

-- 增加一个字段
alter table worker add column email varchar(30);

-- 修改一个字段
alter table worker modify column email varchar(50);

-- 删除一个字段
alter table worker drop column email;

-- 修改表的字符集
alter table worker character set utf8;

-- 4 删除表
drop table worker;
-- 注意: mysql删除表不能使用purge. s	
```

3. 数据的CURD
``` SQL
-- 1 创建一个表
	create table employee(
		id int,
		name varchar(20),
		sex int,
		birthday date,
		salary double,
		entry_date date,
		resume text
	);
	
	insert into employee values(1,'张三',1,'1983-04-27',15000,'2012-06-24','一个大牛');
	insert into employee(id,name,sex,birthday,salary,entry_date,resume) values(2,'李四',1,'1984-02-22',10000,'2012-07-24','一个中牛');
	insert into employee(id,name,sex,birthday,salary,entry_date,resume) values(3,'王五',0,'1985-08-28',7000,'2012-08-24','一个小虾');

-- 2 Retrieve数据
	select id, name as "名字", salary "月薪", salary*12 年薪  from employee 
		where id >=2;

-- 3 update数据
	--将所有员工薪水都增加500元。
	update employee set salary=salary+500;
	--将王五的员工薪水修改为10000元，resume改为也是一个中牛
	update employee set salary=10000, resume='也是一个中牛' where name='王五';

-- 4 delete数据
	--删除表中姓名为王五的记录。
	delete from employee where name='王五';
	
	--删除表中所有记录。
	delete from employee;
	
	--使用truncate删除表中记录。
	truncate table employee;
```

Other
``` SQL
-- top-N问题: 按math成绩从小大的排序, 求math成绩在5-8名的
	 select * from student order by math limit 4, 4;
	 -- limit后面的两个数字的意思: 第一个4: 表示要跳过前面几个; 第二个4: 表示连续取几个.
		

-- 重点说一下分组查询部分
	--查出各个班的总分和最高分
		select class_id, sum(chinese+english+math), max(chinese+english+math) from student group by class_id;
	
	--求各个班级英语的平均分
		select class_id, avg(english) from student group by class_id;
	
	--查询出班级总分大于1300分的班级ID
		select class_id, sum(chinese+english+math) "总分" from student group by class_id having 总分>1300;
		
	-- 注意: having后面若是用"总分"不可以, 但是不加""可以.
				在oracle数据库中, having后面不可以使用别名, mysql可以使用别名(若是中文不要加"")
				
	select colname | * from tablename where cond group by colname having cond order by ...;
```

- 多表查询
``` SQL	
-- 交叉连接, 相当于笛卡尔积
select e.*, d.* from emp e cross join dept d;

	
-- 外连接：left join | right join
	-- 左外连接:
  	select e.*, d.* from emp e right outer join dept d on e.deptno=d.deptno;
  
    -- 右外连接:
	select e.*, d.* from dept d left outer join emp e on e.deptno=d.deptno;
	
    -- SQL99中，外链接取值与关系表达式=号左右位置无关。取值跟from后表的书写顺序有关。 
	"xxx left outer join yyy"  则为取出xxx的内容。
	"xxx right outer join yyy" 则为取出yyy的内容。
```

- 自连接
``` SQL
-- 1 mysql不支持用||连接两个字符串
-- 2 使用concat函数
select concat(e.ename, '的老板是', b.ename) from emp e, emp b 
	where e.mgr=b.empno;
select concat(e.ename, '的老板是', b.ename) from emp e 
	inner join emp b on e.mgr=b.empno;

-- 3 若要显示KING的信息, 需要使用外连接
	-- a mysql不支持nvl函数
	-- b 使用ifnull函数
select concat(e.ename, '的老板是', b.ename) from emp e 
	left outer join emp b on e.mgr=b.empno;
select concat(e.ename, '的老板是', ifnull(b.ename, 'HIMSELF')) from emp e 
	left outer join emp b on e.mgr=b.empno;
select concat(e.ename, '的老板是', ifnull(b.ename, 'HIMSELF')) from emp b 
	right outer join emp e on e.mgr=b.empno;
```

- 表的约束
``` SQL
-- 定义主键约束: 不允许为空，不允许重复　primary key
-- 定义主键自动增长　auto_increment
-- 定义唯一约束　unique
-- 定义非空约束　not null
-- 定义外键约束　constraint ordersid_FK foreign key(ordersid) references orders(id)
-- 删除主键：alter table tablename drop primary key ;

create table class (
	id INT(11) primary key auto_increment,
	name varchar(20) unique
);

create table student (
	id INT(11) primary key auto_increment, 
	name varchar(20) unique,
	passwd varchar(15) not null,
	classid INT(11),
	constraint stu_classid_FK foreign key(classid) references class(id)
);
```

- MySQL乱码相关
1. 使用UTF-8方式登陆数据库后，若insert数据，则使用GBK方式登陆，然后去查看则不能正常显示
2. 操作系统本身必须支持中文显示
3. 连接Linux客户端的SSH工具必须支持中文字符的显示

``` SQL
-- 登陆数据库指定字符集
Mysql -uroot -pxxxx --default_character_set=gbk

-- 查看当前数据库的编码
show variable like 'character%';
```

mysql事务:
``` SQL
start transaction;
set autocommit=0;
set autocommit=1;
commit rollback
```


MySql-C-API
``` C
mysql_init(); // 初始化mysql
mysql_real_connect(); // 连接mysql
mysql_query(); // 查询mysql
mysql_store_result(); // 获取结果集
mysql_affected_rows(); // 获取受影响的行数
mysql_field_count(); // 获取字段个数
mysql_num_fields(); // 获取字段个数，获取结果集前
mysql_fetch_fields(); // 获取字段个数，获取结果集后
mysql_fetch_row(); // 获取每一行
mysql_free_result(); // 释放结果集
mysql_close(); // 释放连接
mysql_error(); // 查看出错信息

MYSQL * mysql = mysql_init(NULL);
//MYSQL *mysql_real_connect(MYSQL *, const char *host, const char *user, const char *passwd, const char *db, unsigned int port, const char *unix_socket, unsigned long client_flag) 
MYSQL * conn = mysql_real_connect(mysql, NULL, "root", "root", "DB", 0, NULL, 0);
int ret = mysql_query(mysql, "select * from mytest");
MYSQL_RES * res = mysql_store_result(conn);
mysql_error(mysql);
mysql_error(conn);
unsigned int num = mysql_field_count(conn);
unsigned int num = mysql_num_fileds(res);
MYSQL_FIELD * fields = mysql_fetch_fields(res);

for(int i = 0; i < num; ++i) { 
	printf("%s\t", fields[i].name);
}
putchar('\n);

MYSQL * row;
while((row = mysql_fetch_row(res))) {
	for(int i = 0; i < num; ++i)
	{
		printf("%s\t", row[i]);
	}
	putchar('\n');
}
mysql_free_result(res);
mysql_close(conn);
```