

## 修改mysql数据库用户设置使使用该用户可以进行远程登陆：使用root用户进行操作

```sql
USE mysql;
SELECT * FROM USER WHERE USER='mytest';
UPDATE USER SET HOST = '%' WHERE USER ='mytest' AND HOST='127.0.0.1';
FLUSH PRIVILEGES;
```



## 在服务器上查看MYSQL的版本

```sql
mysql --help|grep Distrib
```

​	

## 默认表名

```sql
select * from dual ...;
```



## 设置自动提交

```sql
SET SESSION AUTOCOMMIT=0	自动提交
SET SESSION AUTOCOMMIT=1	手动提交
```



## 锁表

```sql
SET SESSION AUTOCOMMIT=1	手动提交
update tableName set id=id where id=id;
commit;
```



## 新建数据表

```sql
CREATE TABLE `TABLE_NAME`(
	`ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字段注释信息',
	`fieldName` type DEFAULT NULL COMMENT '字段注释信息',
	`fieldName` type DEFAULT NULL COMMENT '字段注释信息',
	PRIMARY KEY (`ID`),
	UNIQUE KEY `uniquekeyName` (`fieldName`,`fieldName`...)
)ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8 COMMENT '表注释信息';

DROP TABLE IF EXISTS `t_`;  
CREATE TABLE t_ (  
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  create_time CHAR(14) NOT NULL COMMENT '创建时间yyyyMMddHHmmss',
  update_time CHAR(14) NOT NULL COMMENT '修改时间yyyyMMddHHmmss',
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='';  
```



## 插入语句：

### 若表中有自增序列，则可以将该列置未‘0’ 或 ‘null’,这样mysql将会自动处理该列

```sql
INSERT INTO tableName values(0,'name');
INSERT INTO tableName(属性1，属性2...) SELECT '值1','值2'... FROM tableName WHERE ...
```



### 向数据库中插入特殊符号，需要特殊处理

```sql
insert into table values('{\"jymd\":\"3004\",\"dqdh\":\"04\"}');
```



## 更新数据：

```sql
UPDATE [LOW_PRIORITY] [IGNORE] tableName
	SET assignment_list
	[WHERE where_condition]
	[ORDER BY ...]
	[LIMIT ROW_COUNT]
```



## 删除表

```sql
DROP TABLE tableName;
```



## 清除表中所有的数据，但不删除表

```sql
DELETE TABLE tableName;
```



## 删除数据

```sql
DELETE [LOW_PRIORITY] [QUICK] [IGNORE]
	FROM
	  tbl_name [PARTITION (partition_name[,partition_name]...)]
	[WHERE where_condition ]
	[ORDER BY ...]
	[LIMIT ROW_COUNT];
```



## 向表中添加字段

```sql
ALTER TABLE tableName ADD fieldName type DEFAULT COMMENT;
ALTER TABLE tableName ADD (fieldName type DEFAULT COMMENT,fieldName type DEFAULT COMMENT,...);
```



## 表中删除字段

```sql
ALTER TABLE tableName DROP fieldName;
ALTER TABLE tableName DROP fieldName,DROP fieldName,...;
```



## 修改表中的字段名：

```sql
ALTER TABLE tableName CHANGE oldFieldName newFieldName type
```

​	

## 修改表的字段类型或长度

```sql
ALTER TABLE tableName MODIFY COLUMN 字段名 类型 约束等;
```

​	

## 修改表中字段的默认值

```sql
ALTER TABLE 表民 ALTER COLUMN 字段名 SET DEFAULT 默认值;
```



## STRING类型转换为DATE类型	

```sql
SELECT STR_TO_DATE('20180211','%Y%m%d') AS d;
SELECT STR_TO_DATE('102950','%H%i%s') AS t;
SELECT STR_TO_DATE('20180211102950','%Y%m%d%H%i%s') AS t;
```



## DATE类型转换为STRING类型

```sql
SELECT DATE_FORMAT(NOW(),'%Y%m%d%H%i%s');
```



## 日期函数

```sql
--当前日期
	SELECT NOW() AS t;
--当前年月日
	SELECT CURDATE() AS d;
	当前时分秒
	SELECT CURTIME() AS t;
	当前日期减一分钟
	SELECT CURTIME() AS ct,DATE_SUB(CURTIME(),INTERVAL '0 0:1:0' DAY_SECOND) AS ct1;
	当前日期加一分钟
	SELECT CURTIME() AS ct,DATE_ADD(CURTIME(),INTERVAL '0 0:1:0' DAY_SECOND) AS ct1;
	
```



## 索引

在mysql中若更新条件为非索引字段，则在做update操作时将对整张表进行锁定

注意：索引字段长度不能超过767个字节，故varchar类型最多可以设置为255

索引类型：
	primary:主键索引
	unique:唯一索引
	index或key:普通索引
	fulltext:全文索引
	
添加索引:
	ALTER TABLE 表名 ADD 索引类型(primary,unique,index) [索引名](字段名(长度),字段名(长度)...);//此处‘长度’为某字段添加索引的长度，及短索引
	CREATE 索引类型(unique,index) 索引名 ON 表名(字段名,字段名...);

删除索引:
	DROP INDEX 索引名 ON 表名;
	ALTER TABLE 表名 DROP INDEX 索引名;
	
索引使用技巧：
	1.索引不会包含有null的列
		只要列中包含有null值，都将不会被包含在索引中，复合索引中只要有一列含有null值，那么这一列对于复合索引就是无效的。
	2.使用短索引
		如果有一个char(255)的列，如果在前10个或者20个字符内，多数值是唯一的，那么就不要对整个列进行索引，使用短索引。
	3.like语句操作
		一般情况下不要使用like操作，若要使用，like '%aaa%'不会使用索引，而 like 'aaa%'可以使用索引
	4.不适用 NOT IN 、<>、!=操作，但<,<=,=,>,>=,BETWEEN,IN是可以使用索引的
	5.不要在列上进行运算
	6.索引要建立在经常进行select操作的字段上
	7.索引要建立在值比较唯一的字段上
	8.对于那些定义为text，image，和bit数据类型的列不应该增加索引。
	9.在where和join中出现的列需要建立索引
	10.若where子句的查询条件里使用了函数，则索引无效
	11.在join操作中，mysql只有在主键和外键的数据类型相同时，才能使用索引，否则索引无效
	
缺点：
	索引会降低更新表的速度，因为更新表时，mysql不仅要保存数据，还要保存一下索引文件。
	建立索引会占用磁盘空间的索引文件
	
查看查询语句中索引使用情况
	EXPLAIN SELECT * FROM TABLE_NAME WHERE ...
	EXPLAIN列的解释：
		table:显示这一行的数据是关于哪张表的
		type:显示连接使用了何种类型。从最好到最差的连接类型为const，eq_reg，ref，range，indexhe和all
		possible_keys:显示可能应用在这张表中的索引，如果为空，没有可用的索引。可以为相关的域从WHERE语句中选择一个合适的语句
		key:实际使用的索引。如果为NULL，则没有使用索引。很少的情况下，MYSQL会选择优化不足的索引。这种情况下，可以在select语句中使用USE INDEX (indexname) 来强制使用一个索引或者用IGNORE INDEX (indexname) 来强制MYSQL忽略索引
		key_len:使用的索引的长度，在不损失精确性的情况下，长度越短越好
		ref:显示索引的哪一列被使用了，如果可能的话，是一个常数
		rows:MYSQL认为必须检查的用来返回请求数据的行数
		Extra:关于MQSQL如何解析查询的额外信息。	



## Limit 使用，获取指定结果集数量

```sql
SELECT * FROM tableName LIMIT [offset,]rows|rows;
```



## mysql中使用正则表达式（REGEXP）

SELECT * FROM tbl_dept WHERE id REGEXP '正则表达式';

select count(1) from t_test where test1=1 and respmsg not in (select respmsg from t_test where respmsg like '可用%' or respmsg like '通用%');

## 数据备份

select * from tableName into outfile "/opt/..."(路径) fields terminated by "|";

## 数据还原

load data infile "/opt/..." replace into table tableName fields terminated by "|";

## 创建存储过程

CREATE PROCEDURE pro_name(in num int)
BEGIN
DECLARE a INT UNSIGNED DEFAULT 1
WHILE a <= num DO
INSERT INTO tbl_dept (dept_name) VALUES ('开发部');
SET a = a + 1;
END WHILE;
END

## 调用存储过程

CALL pro_name(1);

## 删除存储过程

DROP PROCEDURE pro_name;

## 删除重复数据只保留一条

DELETE 
FROM
  t_clr_task_ctl 
WHERE 
  channel_id = '30' 
AND id NOT IN 
  (
    SELECT 
     ct.minId 
    FROM
       (
         SELECT 
           MIN(id) AS minId 
         FROM
           t_clr_task_ctl 
         WHERE 
           channel_id = '30' 
         GROUP BY CODE
        ) ct
   ) ;

DELETE 
FROM
  t_clr_task_ctl 
WHERE 
  id IN
  (SELECT t.id FROM (
      SELECT
          tc.id
      FROM
          t_clr_task_ctl tc
      WHERE
          tc.channel_id = '30'
      AND tc.code IN
          (
	       SELECT
	           tc1.code
	       FROM
	           t_clr_task_ctl tc1
	       WHERE
	           tc1.channel_id = '30'
	       GROUP BY
	           tc1.code
	       HAVING
	           COUNT(*) > 1
	   )
      AND tc.id NOT IN
	   (
	       SELECT
	           MIN(tc1.id)
	       FROM
	           t_clr_task_ctl tc1
	       WHERE
	           tc1.channel_id = '30'
	       GROUP BY
	           tc1.code
	       HAVING
	           COUNT(*) > 1
	   )
      ) t );

## 查看表结构

DESC 表名/视图名

## 显示支持的存储引擎

show engines

show variables like ''

## 去重

distinct

> < = <> != >= <=	

and or not 

in like between and

FIND_IN_SET(str,strlist)

占位符
%  ＿

转译
＼ ESCAPE

安全等于
<=>

order by desc(asc)

```
名称	描述
&	按位与
>	大于运算符
>>	右移
>=	大于或等于运算符
<	少于运算符
<>， !=	不等于运算符
<<	左移
<=	小于或等于运算符
<=>	NULL安全等于运算符
%， MOD	模运算符
*	乘法运算符
+	加法运算符
-	减号
-	更改参数的符号
/	部门运营商
:=	赋值
=	分配值（作为SET 语句的一部分 ，或作为语句的SET子句的 一部分UPDATE）
=	平等算子
^	按位异或
```

ABS()	返回绝对值
ACOS()	返回反余弦
ADDDATE()	将时间值（间隔）添加到日期值
ADDTIME()	加时间
AES_DECRYPT()	使用AES解密
AES_ENCRYPT()	使用AES加密
AND， &&	逻辑与
Area()	返回多边形或多多边形区域
AsBinary()， AsWKB()	从内部几何格式转换为WKB
ASCII()	返回最左边字符的数值
ASIN()	返回反正弦
AsText()， AsWKT()	从内部几何格式转换为WKT
ATAN()	返回反正切
ATAN2()， ATAN()	返回两个参数的反正切
AVG()	返回参数的平均值
BENCHMARK()	重复执行一个表达式
BETWEEN ... AND ...	值是否在值范围内
BIN()	返回包含数字的二进制表示形式的字符串
BINARY	将字符串转换为二进制字符串
BIT_AND()	按位返回AND
BIT_COUNT()	返回设置的位数
BIT_LENGTH()	返回参数的长度（以位为单位）
BIT_OR()	按位返回OR
BIT_XOR()	返回按位异或
Buffer()	返回距几何指定距离内的点的几何
CASE	案例运算符
CAST()	将值强制转换为特定类型
CEIL()	返回不小于参数的最小整数值
CEILING()	返回不小于参数的最小整数值
Centroid()	返回质心为点
CHAR()	返回每个传递的整数的字符
CHAR_LENGTH()	返回参数中的字符数
CHARACTER_LENGTH()	CHAR_LENGTH（）的同义词
CHARSET()	返回参数的字符集
COALESCE()	返回第一个非NULL参数
COERCIBILITY()	返回字符串参数的排序规则强制性值
COLLATION()	返回字符串参数的排序规则
COMPRESS()	以二进制字符串形式返回结果
CONCAT()	返回串联的字符串
CONCAT_WS()	返回用分隔符连接
CONNECTION_ID()	返回连接的连接ID（线程ID）
Contains()	一个几何的MBR是否包含另一个几何的MBR
CONV()	在不同的基数之间转换数字
CONVERT()	将值强制转换为特定类型
CONVERT_TZ()	从一个时区转换到另一个时区
COS()	返回余弦
COT()	返回余切
COUNT()	返回计数返回的行数
COUNT(DISTINCT)	返回多个不同值的计数
CRC32()	计算循环冗余校验值
Crosses()	一个几何图形是否交叉
CURDATE()	返回当前日期
CURRENT_DATE()， CURRENT_DATE	CURDATE（）的同义词
CURRENT_TIME()， CURRENT_TIME	CURTIME（）的同义词
CURRENT_TIMESTAMP()， CURRENT_TIMESTAMP	NOW（）的同义词
CURRENT_USER()， CURRENT_USER	经过身份验证的用户名和主机名
CURTIME()	返回当前时间
DATABASE()	返回默认（当前）数据库名称
DATE()	提取日期或日期时间表达式的日期部分
DATE_ADD()	将时间值（间隔）添加到日期值
DATE_FORMAT()	指定格式日期
DATE_SUB()	从日期中减去时间值（间隔）
DATEDIFF()	减去两个日期
DAY()	DAYOFMONTH（）的同义词
DAYNAME()	返回工作日的名称
DAYOFMONTH()	返回月份中的一天（0-31）
DAYOFWEEK()	返回参数的工作日索引
DAYOFYEAR()	返回一年中的某天（1-366）
DECODE()	解码使用ENCODE（）加密的字符串
DEFAULT()	返回表列的默认值
DEGREES()	将弧度转换为度
DES_DECRYPT()	解密字符串
DES_ENCRYPT()	加密字符串
Dimension()	几何尺寸
Disjoint()	两个几何的MBR是否不相交
DIV	整数除法
ELT()	返回索引编号的字符串
ENCODE()	编码字符串
ENCRYPT()	加密字符串
EndPoint()	LineString的终点
Envelope()	返回几何的MBR
Equals()	两个几何的MBR是否相等
EXP()	提升力量
EXPORT_SET()	返回一个字符串，这样对于值位中设置的每个位，您将获得一个打开的字符串，对于每个未设置的位，您将获得一个关闭的字符串
ExteriorRing()	返回多边形的外圈
EXTRACT()	提取部分日期
ExtractValue()	使用XPath表示法从XML字符串中提取值
FIELD()	后续参数中第一个参数的索引（位置）
FIND_IN_SET()	第二个参数中第一个参数的索引（位置）
FLOOR()	返回不大于参数的最大整数值
FORMAT()	返回格式化为指定的小数位数的数字
FOUND_ROWS()	对于带有LIMIT子句的SELECT，如果没有LIMIT子句，则将返回的行数
FROM_BASE64()	解码base64编码的字符串并返回结果
FROM_DAYS()	将天数转换为日期
FROM_UNIXTIME()	将Unix时间戳记格式化为日期
GeomCollFromText()， GeometryCollectionFromText()	从WKT返回几何集合
GeomCollFromWKB()， GeometryCollectionFromWKB()	从WKB返回几何集合
GeometryCollection()	从几何构造几何集合
GeometryN()	从几何集合返回第N个几何
GeometryType()	返回几何类型的名称
GeomFromText()， GeometryFromText()	从WKT返回几何
GeomFromWKB()， GeometryFromWKB()	从WKB返回几何
GET_FORMAT()	返回日期格式字符串
GET_LOCK()	获取命名锁
GLength()	返回LineString的长度
GREATEST()	返回最大参数
GROUP_CONCAT()	返回串联的字符串
GTID_SUBSET()	如果子集中的所有GTID也都已设置，则返回true；否则，返回false。否则为假。
GTID_SUBTRACT()	返回集合中所有不在子集中的GTID。
HEX()	十进制或字符串值的十六进制表示
HOUR()	提取时间
IF()	如果/其他构造
IFNULL()	空if / else构造
IN()	一个值是否在一组值内
INET_ATON()	返回IP地址的数值
INET_NTOA()	从数值返回IP地址
INET6_ATON()	返回IPv6地址的数值
INET6_NTOA()	从数值返回IPv6地址
INSERT()	在指定位置插入子字符串，最多可指定字符数
INSTR()	返回第一次出现的子串的索引
InteriorRingN()	返回多边形的第N个内环
Intersects()	两个几何的MBR是否相交
INTERVAL()	返回小于第一个参数的参数的索引
IS	针对布尔值测试值
IS_FREE_LOCK()	命名锁是否免费
IS_IPV4()	参数是否为IPv4地址
IS_IPV4_COMPAT()	参数是否为IPv4兼容地址
IS_IPV4_MAPPED()	参数是否为IPv4映射的地址
IS_IPV6()	参数是否为IPv6地址
IS NOT	针对布尔值测试值
IS NOT NULL	非空值测试
IS NULL	空值测试
IS_USED_LOCK()	是否使用了命名锁；如果为true，则返回连接标识符
IsClosed()	几何是否闭合且简单
IsEmpty()	几何是否为空
ISNULL()	测试参数是否为NULL
IsSimple()	几何是否简单
LAST_DAY	返回参数的月份的最后一天
LAST_INSERT_ID()	最后一个INSERT的AUTOINCREMENT列的值
LCASE()	LOWER（）的同义词
LEAST()	返回最小的参数
LEFT()	返回指定的最左边的字符数
LENGTH()	返回字符串的长度（以字节为单位）
LIKE	简单模式匹配
LineFromText()， LineStringFromText()	从WKT构造LineString
LineFromWKB()， LineStringFromWKB()	从WKB构造LineString
LineString()	从Point值构造LineString
LN()	返回参数的自然对数
LOAD_FILE()	加载命名文件
LOCALTIME()， LOCALTIME	NOW（）的同义词
LOCALTIMESTAMP， LOCALTIMESTAMP()	NOW（）的同义词
LOCATE()	返回子串第一次出现的位置
LOG()	返回第一个参数的自然对数
LOG10()	返回参数的以10为底的对数
LOG2()	返回参数的以2为底的对数
LOWER()	以小写形式返回参数
LPAD()	返回字符串参数，用指定的字符串左填充
LTRIM()	删除前导空格
MAKE_SET()	返回一组逗号分隔的字符串，这些字符串在位中具有相应的位
MAKEDATE()	从一年中的年月日创建日期
MAKETIME()	从小时，分钟，秒创建时间
MASTER_POS_WAIT()	阻塞直到副本已读取并应用所有更新到指定位置
MATCH	执行全文搜索
MAX()	返回最大值
MBRContains()	一个几何的MBR是否包含另一个几何的MBR
MBRDisjoint()	两个几何的MBR是否不相交
MBREqual()	两个几何的MBR是否相等
MBRIntersects()	两个几何的MBR是否相交
MBROverlaps()	两个几何的MBR是否重叠
MBRTouches()	两个几何的MBR是否接触
MBRWithin()	一个几何的MBR是否在另一个几何的MBR内
MD5()	计算MD5校验和
MICROSECOND()	从参数返回微秒
MID()	返回从指定位置开始的子字符串
MIN()	返回最小值
MINUTE()	返回参数的分钟
MLineFromText()， MultiLineStringFromText()	从WKT构造MultiLineString
MLineFromWKB()， MultiLineStringFromWKB()	从WKB构造MultiLineString
MOD()	退还剩余
MONTH()	返回经过日期的月份
MONTHNAME()	返回月份名称
MPointFromText()， MultiPointFromText()	从WKT构造MultiPoint
MPointFromWKB()， MultiPointFromWKB()	从WKB构造MultiPoint
MPolyFromText()， MultiPolygonFromText()	从WKT构造MultiPolygon
MPolyFromWKB()， MultiPolygonFromWKB()	从WKB构造MultiPolygon
MultiLineString()	从LineString值构造MultiLineString
MultiPoint()	从Point值构造MultiPoint
MultiPolygon()	从多边形值构造MultiPolygon
NAME_CONST()	使列具有给定名称
NOT， !	取反值
NOT BETWEEN ... AND ...	值是否不在值范围内
NOT IN()	一个值是否不在一组值内
NOT LIKE	否定简单模式匹配
NOT REGEXP	否REGEXP
NOW()	返回当前日期和时间
NULLIF()	如果expr1 = expr2，则返回NULL
NumGeometries()	返回几何集合中的几何数量
NumInteriorRings()	返回多边形内环的数量
NumPoints()	返回LineString中的点数
OCT()	返回包含数字的八进制表示形式的字符串
OCTET_LENGTH()	LENGTH（）的同义词
OLD_PASSWORD() （已弃用）	返回PASSWORD 4.1之前的实现的值
OR， ||	逻辑或
ORD()	返回参数最左边字符的字符代码
Overlaps()	两个几何的MBR是否重叠
PASSWORD()	计算并返回密码字符串
PERIOD_ADD()	在一年的月份中添加一个期间
PERIOD_DIFF()	返回期间之间的月数
PI()	返回pi的值
Point()	从坐标构造点
PointFromText()	WKT的构造点
PointFromWKB()	WKB的构造点
PointN()	从LineString返回第N个点
PolyFromText()， PolygonFromText()	从WKT构造多边形
PolyFromWKB()， PolygonFromWKB()	从WKB构造多边形
Polygon()	从LineString参数构造多边形
POSITION()	LOCATE（）的同义词
POW()	将自变量提高到指定的幂
POWER()	将自变量提高到指定的幂
PROCEDURE ANALYSE()	分析查询结果
QUARTER()	从日期参数返回季度
QUOTE()	转义要在SQL语句中使用的参数
RADIANS()	返回参数转换为弧度
RAND()	返回一个随机浮点值
RANDOM_BYTES() （引入5.6.17）	返回一个随机字节向量
REGEXP	字符串是否匹配正则表达式
RELEASE_LOCK()	释放命名锁
REPEAT()	重复字符串指定次数
REPLACE()	替换出现的指定字符串
REVERSE()	反转字符串中的字符
RIGHT()	返回指定的最右边字符
RLIKE	字符串是否匹配正则表达式
ROUND()	围绕论点
ROW_COUNT()	更新的行数
RPAD()	将字符串追加指定次数
RTRIM()	删除尾随空格
SCHEMA()	DATABASE（）的同义词
SEC_TO_TIME()	将秒转换为“ hh：mm：ss”格式
SECOND()	返回第二个（0-59）
SESSION_USER()	USER（）的同义词
SHA1()， SHA()	计算SHA-1 160位校验和
SHA2()	计算SHA-2校验和
SIGN()	返回参数的符号
SIN()	返回参数的正弦
SLEEP()	睡觉几秒钟
SOUNDEX()	返回soundex字符串
SOUNDS LIKE	比较声音
SPACE()	返回指定数量的字符串
SQL_THREAD_WAIT_AFTER_GTIDS() （已弃用）	过时的 使用WAIT_FOR_EXECUTED_GTID_SET()。
SQRT()	返回参数的平方根
SRID()	返回几何的空间参考系统ID
ST_Area()	返回多边形或多多边形区域
ST_AsBinary()， ST_AsWKB()	从内部几何格式转换为WKB
ST_AsText()， ST_AsWKT()	从内部几何格式转换为WKT
ST_Buffer()	返回距几何指定距离内的点的几何
ST_Centroid()	返回质心为点
ST_Contains()	一个几何是否包含另一个
ST_Crosses()	一个几何图形是否交叉
ST_Difference()	两个几何的返回点设置差
ST_Dimension()	几何尺寸
ST_Disjoint()	一个几何是否与另一个几何不相交
ST_Distance()	一种几何形状与另一种几何形状的距离
ST_EndPoint()	LineString的终点
ST_Envelope()	返回几何的MBR
ST_Equals()	一个几何是否等于另一个
ST_ExteriorRing()	返回多边形的外圈
ST_GeomCollFromText()，ST_GeometryCollectionFromText()，ST_GeomCollFromTxt()	从WKT返回几何集合
ST_GeomCollFromWKB()， ST_GeometryCollectionFromWKB()	从WKB返回几何集合
ST_GeometryN()	从几何集合返回第N个几何
ST_GeometryType()	返回几何类型的名称
ST_GeomFromText()， ST_GeometryFromText()	从WKT返回几何
ST_GeomFromWKB()， ST_GeometryFromWKB()	从WKB返回几何
ST_InteriorRingN()	返回多边形的第N个内环
ST_Intersection()	返回点设置两个几何的交点
ST_Intersects()	一个几何是否相交
ST_IsClosed()	几何是否闭合且简单
ST_IsEmpty()	几何是否为空
ST_IsSimple()	几何是否简单
ST_LineFromText()， ST_LineStringFromText()	从WKT构造LineString
ST_LineFromWKB()， ST_LineStringFromWKB()	从WKB构造LineString
ST_NumGeometries()	返回几何集合中的几何数量
ST_NumInteriorRing()， ST_NumInteriorRings()	返回多边形内环的数量
ST_NumPoints()	返回LineString中的点数
ST_Overlaps()	一个几何图形是否重叠
ST_PointFromText()	WKT的构造点
ST_PointFromWKB()	WKB的构造点
ST_PointN()	从LineString返回第N个点
ST_PolyFromText()， ST_PolygonFromText()	从WKT构造多边形
ST_PolyFromWKB()， ST_PolygonFromWKB()	从WKB构造多边形
ST_SRID()	返回几何的空间参考系统ID
ST_StartPoint()	LineString的起点
ST_SymDifference()	返回点设置两个几何的对称差
ST_Touches()	一种几何是否接触另一种
ST_Union()	返回点集两个几何的并集
ST_Within()	一个几何是否在另一个几何之内
ST_X()	返回点的X坐标
ST_Y()	返回点的Y坐标
StartPoint()	LineString的起点
STD()	返回人口标准差
STDDEV()	返回人口标准差
STDDEV_POP()	返回人口标准差
STDDEV_SAMP()	返回样品标准偏差
STR_TO_DATE()	将字符串转换为日期
STRCMP()	比较两个字符串
SUBDATE()	用三个参数调用时DATE_SUB（）的同义词
SUBSTR()	返回指定的子字符串
SUBSTRING()	返回指定的子字符串
SUBSTRING_INDEX()	在指定的定界符出现次数之前从字符串返回子字符串
SUBTIME()	减去时间
SUM()	返回总和
SYSDATE()	返回函数执行的时间
SYSTEM_USER()	USER（）的同义词
TAN()	返回参数的正切值
TIME()	提取传递的表达式的时间部分
TIME_FORMAT()	格式化为时间
TIME_TO_SEC()	返回参数转换为秒
TIMEDIFF()	减去时间
TIMESTAMP()	这个函数只有一个参数，它返回日期或日期时间表达式；有两个参数，参数的总和
TIMESTAMPADD()	向日期时间表达式添加间隔
TIMESTAMPDIFF()	从日期时间表达式中减去一个间隔
TO_BASE64()	返回转换为以64为底的字符串的参数
TO_DAYS()	返回日期参数转换为天
TO_SECONDS()	返回从Year 0开始转换为秒的日期或日期时间参数
Touches()	一种几何是否接触另一种
TRIM()	删除前导和尾随空格
TRUNCATE()	截断为指定的小数位数
UCASE()	UPPER（）的同义词
UNCOMPRESS()	解压字符串压缩
UNCOMPRESSED_LENGTH()	返回压缩前的字符串长度
UNHEX()	返回包含数字的十六进制表示形式的字符串
UNIX_TIMESTAMP()	返回Unix时间戳
UpdateXML()	返回替换的XML片段
UPPER()	转换为大写
USER()	客户端提供的用户名和主机名
UTC_DATE()	返回当前UTC日期
UTC_TIME()	返回当前UTC时间
UTC_TIMESTAMP()	返回当前UTC日期和时间
UUID()	返回通用唯一标识符（UUID）
UUID_SHORT()	返回一个整数通用标识符
VALIDATE_PASSWORD_STRENGTH()	确定密码强度
VALUES()	定义在INSERT期间要使用的值
VAR_POP()	返回总体标准方差
VAR_SAMP()	返回样本方差
VARIANCE()	返回总体标准方差
VERSION()	返回指示MySQL服务器版本的字符串
WAIT_UNTIL_SQL_THREAD_AFTER_GTIDS()	使用WAIT_FOR_EXECUTED_GTID_SET()。
WEEK()	返回星期数
WEEKDAY()	返回工作日索引
WEEKOFYEAR()	返回日期的日历周（1-53）
WEIGHT_STRING()	返回字符串的权重字符串
Within()	一个几何的MBR是否在另一个几何的MBR内
X()	返回点的X坐标
XOR	逻辑异或
Y()	返回点的Y坐标
YEAR()	返回年份
YEARWEEK()	返回年和周

|	按位或
~	按位反转



%Y(四位年)
%y(两位年)
%m(月01-12)
%c(月1-12)
%d(日01...)
%H(小时24)
%h(小时12)
%i(分00-59)
%s(秒00-59)

str_to_date('1964-03-2','%Y-%c-%d')

date_format

## 数据库版本

version()

## 仓库

datebase()

## 用户

user()

## 以下函数null将不参与运算

SUM()
AVG()
MIN()
MAX()
COUNT()

SELECT 查询列表
FROM 表1 [连接类型]
JOIN 表2
ON 连接条件
[WHERE 筛选条件]
[GROUP BY 分组]
[HAVING 筛选条件]
[ORDER BY 排序列表]

## 连接类型：

内连接：INNER
外连接：
    左外：LEFT [OUTER]
    右外：RIGHT [OUTER]
    全外：FULL [OUTER]
交叉连接：CROSS

## 子查询：

​    SELECT 后面：
​        只支持标量子查询(结果集只有一行一列)
​    FROM 后面：
​        表子查询(结果集一般有多行多列)
​    WHERE 或 HAVING 后面：
​        标量子查询
​        列子查询(结果集有一列多行)
​        行子查询(结果集有一行多列)
​    EXISTS
​        表子查询
​    标量子查询一般搭配单行操作符使用如：> < >= <= = <>
​    列子查询一般搭配多行操作符使用如：IN,ANY/SOME,ALL
​    子查询先于主查询

## 分页查询

```sql
SELECT 查询列表 FROM 表名
    [WHERE 分组前条件
     GROUP BY 分组字段
     HAVING 分组后条件
     ORDER BY]
    LIMIT 起始索引，条数；
公式：page显示页数，size每页条数
SELECT 查询列表
FROM 表名
LIMIT (page-1)*size,size
```

## UNION联合查询

```sql
查询语句1
    UNION
查询语句2
特点：
    1、要求多条查询语句的查询列数保持一致
    2、要求多条查询语句查询的每一列的类型和顺序最好一致
    3、union关键字默认去重，union all 可以包含重复项
```

## TRUNCATE语句

```sql
TRUNCATE TABLE 表名；
    该语句不允许添加WHERE条件
    该语句不支持回滚
```

INSERT
UPDATE
DELETE

## MySQL删除数据几种情况以及是否释放磁盘空间

1、drop table table_name 立刻释放磁盘空间 ，不管是 InnoDB和MyISAM
2、truncate table table_name 立刻释放磁盘空间 ，不管是 Innodb和MyISAM 。
truncate table其实有点类似于drop table 然后create。只不过这个create table 的过程做了优化，比如表结构文件之前已经有了等等，就不需要重新再搞一把。所以速度上应该是接近drop table的速度。
3、对于delete from table_name  删除表的全部数据
对于MyISAM 会立刻释放磁盘空间 （应该是做了特别处理，也比较合理）；
InnoDB 不会释放磁盘空间
4、对于delete from table_name where xxx带条件的删除
不管是innodb还是MyISAM都不会释放磁盘空间。
5、delete操作以后 使用optimize table table_name 会立刻释放磁盘空间。不管是InnoDB还是MyISAM 。
所以要想达到清理数据的目的，请delete以后执行optimize table 操作。
6、delete from表 以后虽然未释放磁盘空间，但是下次插入数据的时候，仍然可以使用这部分空间

CREATE
ALTER
DROP

## 创建库

​    CREATE DATABASE IF NOT EXISTS 库名；
​    ALTER DATABASE 库名 CHARACTER SET utf-8
​    DROP DATABASE IF EXISTS 库名；

## 修改字段名

​    ALTER TABLE 表名 CHANGE COLUMN 字段名 新字段名 字段类型

## 修改列类型

​    ALTER TABLE 表名 MODIFY COLUMN 字段名 新字段类型

## 添加新列

​    ALTER TABLE 表名 ADD COLUMN 字段名 字段类型

## 删除列

​    ALTER TABLE 表名 DROP COLUMN 字段名

## 删除表

​    DROP TABLE 表名；

## 复制表

​    仅复制结构
​        CREATE TABLE 表名 LIKE 被复制表名
​    复制结构和数据
​        CREATE TABLE 表名 SELECT 需要复制的字段 FROM 被复制表名；

类型选用原则：所选择的类型越简单越好，空间占用越小越好

## 整型：

​    TINYINT(1 2^(8*1)-1)
​    SMALLINT(2 2^(8*2)-1)
​    MEDIUMINT(3 2^(8*3)-1)
​    INT/INTEGER(4 2^(8*4)-1)
​    BIGINT(8 2^(8*8)-1)
​    特点：
​        1、默认有符号，设置无符号需要添加UNSIGNED关键字
​        2、若插入的数值超出整型范围，会报out of range 异常，并插入临界值
​        3、若不设置长度，会有默认长度，长度代表了显示的最大宽度，如果不够会用0在左边填充，但必须搭配zerofill使用

## 小数：

​    浮点型：FLOAT(M,D)(4) DOUBLE(M,D)(8)
​    定点数：DECIMAL(M,D)
​    特点：
​        1、M:整数位数+小数位数，D:小数位数，如果超出范围，则插入临界值
​        2、MD可省略，decimal默认是(10，0)，float和double会根据插入的数据精度来决定精度
​        3、定点型精度较高，在货币运算等要求精度较高的可以使用

## 字符串：

​    写法                  M的意思                   特点             空间消耗     效率
​    CHAR(M 0-255)        最大字符数，可省略，默认1     固定长度的字符     较消耗       高
​    VARCHAR(M 0-65535)   最大字符数，不可省略         可变长度的字符     较节约       低
​    还有ENUM,SET,BINARY,VARBINARY(二进制),TEXT,BLOB(二进制)

## 日期：

​    DATE,TIME,YEAR
​                字节    范围          时区等的影响
​    DATETIME    8      1000-9999     不受
​    TIMESTAMP   4      1970-2038     受

## 约束：主要分为六大类

​    NOT NULL
​    DEFAULT
​    PRIMARY KEY:主键，保证数据唯一性，不可为空，每个表只有一个
​    UNIQUE:唯一约束，可为空，每个表中可以有多个
​    CHECK：mysql不支持
​    FOREIGN KEY

## 约束的添加类型

​    列级约束：六大约束语法上都支持，但外键约束没有效果
​    表级约束：除了非空、默认，其它都支持；语法： CONSTRAINT 约束名 约束类型(字段名)

## 标识列：

​    AUTO_INCREMENT,必须与key搭配使用，而且一个表中至多只有一个标识列，且类型必须为数值类型

## 事务：

​    A:原子性
​    C:一致性
​    I:隔离性
​    D:持久性

步骤1：开启事务
    SET AUTOCOMMIT = 0;
    START TRANSACTION;
步骤2：
    编写事务中的sql语句(SELECT,INSERT,UPDATE,DELETE)
步骤3：结束事务
    COMMIT;提交事务
    ROLLBACK;回滚事务

SAVEPOINT 节点名; 设置保存点，只可搭配rollback; rollback to 节点名;

脏读：一个事务读取了另一个事务修改但未提交的数据
不可重复读：一个事务读取两次，前后数据值不一致
幻读：一个事务读取了另一个事务插入但未提交的数据

查看当前库的事务的隔离级别
    SELECT @@tx_isolation;
设置事务隔离级别
    SET SESSION(GLOBAL) TRANSACTION ISOLATION LEVEL read committed;
隔离级别：
    read uncommitted
    read committed:可避免脏读
    repeatable read:可避免脏读和不可重复度
    serializable(串行化):可避免脏读，不可重复读和幻读，但会阻塞其它事务对该表进行insert，update，delete操作

## 视图：

​    CREATE VIEW 视图名
​    AS 
​    查询语句

CREATE OR REPLACE VIEW 视图名
AS
查询语句

ALTER VIEW 视图名
AS
查询语句

DROP VIEW 视图名，视图名

具备以下特点不允许被更新：
    包含以下关键字：分组函数，distinct，GROUP BY,having,union,union all

## 变量：

​    系统变量：
​        全局变量：所有会话，但重启将失效
​        会话变量：当前会话
​        语法：
​            1、查看所以的系统变量：SHOW GLOBAL|[SESSION] variables;
​            2、查看满足条件的部分系统变量：SHOW GLOBAL|[SESSION] variables LIKE '';
​            3、查看指定的某个系统变量的值：SELECT @@GLOBAL|[SESSION].系统变量名;
​            4、为某个系统变量赋值：SET GLOBAL|[SESSION] 系统变量名 = 值;
​                              SET @@GLOBAL|[SESSION].系统变量名 = 值;
​    自定义变量：
​        用户变量：当前会话有效，可以在任意地方使用
​            语法：
​                1、声明并初始化
​                    SET @用户变量名=值;
​                    SET @用户变量名:=值;
​                    SELECE @用户变量名:=值;
​                2、赋值
​                    SET @用户变量名=值;
​                    SET @用户变量名:=值;
​                    SELECE @用户变量名:=值;
​                    SELECT 字段值 INTO @变量名 FROM 表名;
​                3、使用
​                    SELECT @用户变量名;
​        局部变量：仅仅在定义它的begin end 中有效，只能放在begin end中的第一句话
​            语法：
​                1、声明
​                    DECLARE 变量名 类型;
​                    DECLARE 变量名 类型 DEFAULT 值;
​                2、赋值
​                    SET 局部变量名=值;
​                    SET 局部变量名:=值;
​                    SELECE @局部变量名:=值;
​                    SELECT 字段值 INTO 局部变量名 FROM 表名;
​                3、使用
​                    SELECT 局部变量名;

## 存储过程：

​    语法：
​        创建
​            CREATE PROCEDURE 存储过程名(参数列表)
​            BEGIN
​                存储过程体(一组合法的sql语句)
​            END
​        调用
​            CALL 存储过程名(实参列表);
​        删除
​            DROP PROCEDURE 存储过程名;
​        查看
​            SHOW CREATE PROCEDURE 存储过程名;
​    注意：
​        1、参数列表包含三部分：参数模式 参数名 参数类型，参数模式：in，out，inout
​        2、存储过程体中每条sql必须以分号结尾，存储过程的结尾可以使用delimiter重新设置;delimiter 结束标记;
​    例：
​        CREATE PROCEDURE myp(in name varchar(20),in pwd varchar(20),out boname varchar(20),out newpwd varchar(20))
​        BEGIN
​            SELECT bo.name,bo.pwd INTO boname,newpwd
​            FROM bo
​            WHERE ...;
​        END;

函数
    语法：
        创建
            CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
            BEGIN
                函数体
            END
        调用
            SELECT 函数名(实参列表)
        删除
            DROP FUNCTION 函数名;
        查看
            SHOW CREATE FUNCTION 函数名;
    注意：
        1、参数名 参数类型
        2、函数体：建议将return语句放在函数体最后，若没有或不在最后也不会报错，但不建议，有且只有一个返回值

流程控制结构
    分支结构：
        1、if函数
            IF(表达式1,表达式2,表达式3):如果表达式1成立则返回表达式2的值，否则返回表达式3的值
        2、case结构
            CASE 变量|表达式|字段
            WHEN 要判断的值 THEN 返回的值1[或语句1];
            WHEN 要判断的值 THEN 返回的值2[或语句2];
            ...
            ELSE 返回的值n
            END;
                    或
        CASE
        WHEN 条件1 THEN 返回的值1[或语句1]
        WHEN 条件2 THEN 返回的值2[或语句2];
        ...
        ELSE 返回的值n
        END;
    3、if结构，只能用于BEGIN END中
        IF 条件1 THEN 语句1
        ELSEIF 条件2 THEN 语句2
        ...
        [ELSE 语句n]
        END IF;
循环结构:
    分类:WHILE,LOOP,REPEAT
    循环控制:
        ITERATE 类似于 continue
        LEAVE 类似于 break
    1、while
        [标签:]while 循环条件 do
            循环体;
        end while [标签];
    2、loop
        [标签:]loop
            循环体;
        END loop [标签:];
    3、repeat
        [标签:]repeat
            循环体;
        UNTIL 结束循环的条件
        END repeat [标签];
顺序结构



mysql查询条件中的“<>”符号不包括为空的数据，故在查询的时候需要注意。



mysql中update或delete语句的where条件中若没有索引列，则将导致锁表;

insert语句中插入的表若没有索引列，则将导致锁表;

注意：当索引为index且该列重复率高时mysql将认为该列索引无效。

mysql中添加字段、删除字段都不会锁表，但修改字段属性则会引起表锁。

mysql中若存在行锁，再获取表锁时将会等待行锁释放后才能会得到。

mysql中除了InnoDB其它存储引擎都只有表锁。

## 查询所有城市都存在的商店类型

SELECT DISTINCT store_type FROM stores s1
  WHERE NOT EXISTS (
    SELECT * FROM cities WHERE NOT EXISTS (
      SELECT * FROM cities_stores
       WHERE cities_stores.city = cities.city
       AND cities_stores.store_type = stores.store_type));

## 查询数据库各个表所占用的内存

USE information_schema;
select table_name,table_rows,data_length+index_length,concat(round((data_length+index_length)/1024/1024,2),'MB') data from tables where table_schema='employees';

## 显示表各字段的字符集等信息

SHOW FULL COLUMNS FROM table_name

## 查看数据库编码集

show variables like '%char%';

## 修改mysql编码集，配置文件/etc/my.cnf。

[mysqld]
character-set-server=utf8 
[client]
default-character-set=utf8 
[mysql]
default-character-set=utf8