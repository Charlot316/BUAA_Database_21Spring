```sql
with
t1 as
(
	select 部门ID, 监理员ID
	from 工程实施, 工程监理
	where 工程实施.工程ID = 工程监理.工程ID
),
t2 as
(
    select 监理员ID
    from t1 tx
    where not exists
    (
    	select *
        from t1 ty
        where 部门ID = 1 and not exists
        (
        	select *
            from t1 tz
            where tz.监理员ID = tx.监理员ID and tz.部门ID = ty.部门ID
        )
    )
)

select 监理姓名
from t2, 监理
where t2.监理员ID = 监理.监理员ID
```



```sql
select 姓名
from 工程监理，监理， 
(
	select 工程ID
	from 工程实施
	where 部门ID = 1
) as 工程项目
where 工程项目.工程ID = 工程监理.工程ID and 工程监理.监理员ID = 监理.监理ID
```



```sql
select 职员ID, 经理ID
from 职员 left outer join 部门 on 职员.部门ID = 部门.部门ID
```



```sql
create view 员工工程预算
as 
select 姓名, sum(工程预算) as 工程总预算
from
(
	select 姓名, 工程预算
    from 职员, 工程, 工程实施
    where 职员.部门ID = 工程实施.部门ID and 工程实施.工程ID = 工程.工程ID
)
where 姓名 like '张%'
group by 姓名
```



```sql
select 工程ID
from 工程
where 工程预算 > all
(
    select 工程预算
    from 工程
    where 工程工期 > 10
)

update 工程
set 工程预算 = 工程预算 - 100
where 工程.工程ID in 
(
	select 工程ID
    from 工程
    where 工程预算 > all
    (
        select 工程预算
        from 工程
        where 工程工期 > 10
    )
)
```



```sql
Select 职员ID,min(考勤时间) as 最早考勤时间
From 职员考勤
Group by 职员ID
```



```sql
create table 工程预算总额
(
	部门ID varchar(20),
    工程预算总额, int
);

insert
into 工程预算总额
(
    
	select 工程ID, sum(工程预算) as 工程预算总额
	from 工程
    where 工程预算总额 > 10000
	group by 工程ID           
)
```



```sql
select 监理姓名
from 监理, 
(
    select 监理员ID
    from 工程监理
    group by 监理员ID
    having count(监理员ID) >= 3
) as t1 
where 监理.监理员ID = t1.监理员ID
```

