USE adventureworks;
GO

DROP TABLE IF EXISTS dbo.SourceDemo;
DROP TABLE IF EXISTS dbo.TargetDemo;

CREATE TABLE dbo.SourceDemo
(
	id		int,
	title	nvarchar(100),
	city	nvarchar(50),
	remarks nvarchar(4000)
);

CREATE TABLE TargetDemo
(
	id		int,
	title	nvarchar(100),
	city	nvarchar(50)
);
GO

INSERT INTO TargetDemo
VALUES
(1, 'a', 'Urk'),
(2, 'b', 'Urk'),
(3, 'c', 'Ede');
GO

INSERT INTO SourceDemo
VALUES
(1, 'a', 'Urk', 'blabla'),
(2, 'b', 'Urk', 'blabla'),
(3, 'c', 'Ede', 'blabla'),
(4, 'd', 'Ede', 'blabla'),
(5, 'e', 'Ede', 'blabla');
GO




-- DROP TABLE IF EXISTS dbo.SourceDemo;
-- DROP TABLE IF EXISTS dbo.TargetDemo;
