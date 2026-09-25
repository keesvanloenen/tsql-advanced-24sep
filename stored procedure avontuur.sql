DECLARE @categorie AS nvarchar(50) = '%ountain%';
--SET @categorie = '%ountain%';

DECLARE @aantal AS int;
DECLARE @grootste AS int;

SELECT 
	@aantal = COUNT(*)
	, @grootste = MAX(LEN(Name)) 
FROM SalesLT.ProductCategory;

PRINT CONCAT_WS(' ', @aantal, @grootste)

SELECT 
	pc.Name											AS categorie_naam
	, pc.ModifiedDate								AS categorie_bewerkt_op
	, p.Name										AS product_naam
	, p.ListPrice									AS product_prijs
	, COALESCE(p.Color, 'Kleur onbekend')			AS product_kleur
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name LIKE @categorie
--WHERE pc.Name LIKE '_[^a-z]%'

GO

CREATE OR ALTER PROCEDURE SalesLT.ProductenVoorCategorie
	@categorie AS nvarchar(50) = 'Mountain',
	@aantal AS int OUT
AS
BEGIN
	SET NOCOUNT ON;

	IF (LEN(@categorie) < 2)
	BEGIN
		; THROW 50001, 'Minimaal 2 tekens graag', 1;

	END;

	SELECT 
		@aantal = COUNT(*)
	FROM SalesLT.Product AS p
	INNER JOIN SalesLT.ProductCategory AS pc
	ON p.ProductCategoryID = pc.ProductCategoryID
	WHERE pc.Name LIKE CONCAT('%', @categorie, '%');

	SELECT 
		pc.Name											AS categorie_naam
		, pc.ModifiedDate								AS categorie_bewerkt_op
		, p.Name										AS product_naam
		, p.ListPrice									AS product_prijs
		, COALESCE(p.Color, 'Kleur onbekend')			AS product_kleur
	FROM SalesLT.Product AS p
	INNER JOIN SalesLT.ProductCategory AS pc
	ON p.ProductCategoryID = pc.ProductCategoryID
	WHERE pc.Name LIKE CONCAT('%', @categorie, '%');
END;

GO

-- --------------------------------------------------------------

-- 🥸 Consument, aanroeper, caller

DECLARE @mijnAantal AS int = 0;

BEGIN TRY

EXEC SalesLT.ProductenVoorCategorie 'so', @mijnAantal OUT
--EXEC SalesLT.ProductenVoorCategorie @categorie = 'so', @aantal = @mijnAantal OUT
--EXEC SalesLT.ProductenVoorCategorie
EXEC SalesLT.ProductenVoorCategorie 'o', @mijnAantal OUT;		-- 💥

PRINT CONCAT('Hier komt ie, mijn aantal is nu: ', @mijnAantal);

END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	PRINT ERROR_NUMBER();
END CATCH

