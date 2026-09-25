using DemoLokaal3.DAL;
using Microsoft.EntityFrameworkCore;

namespace DemoLokaal3;

internal class Program
{
    static void Main(string[] args)
    {
        MaakDatabase();
        MaakStoredProcedure();
        ToonResultaten();
    }

    private static void ToonResultaten()
    {
        Console.WriteLine("De resultaten:");
        Console.WriteLine();

        using var context = new Lokaal3Context();

        var resultaten = context.Resultaten
            .FromSqlRaw("EXEC dbo.GetBestellingenMetWindowFunctions")
            .ToList();

        Console.WriteLine($"{"Datum", 11} {"Aantal", 6} {"RunningTotal", 13} {"Rank", 5}");

        foreach (var r in resultaten)
        {
            Console.WriteLine($"{r.Datum, 11} {r.Aantal, 6} {r.RunningTotal, 13} {r.RankAantal, 5}");
        }


    }

    private static void MaakStoredProcedure()
    {
        var createStoredProcedureSql =
          """
          CREATE OR ALTER PROCEDURE dbo.GetBestellingenMetWindowFunctions
          AS
          BEGIN
            SELECT
              datum
              , aantal
              , SUM(aantal) OVER (ORDER BY datum ASC) AS running_total
              , RANK() OVER (ORDER BY aantal DESC) AS rank_aantal
            FROM bestellingen
            ORDER BY datum;
          END;
          """;

        using var context = new Lokaal3Context();

        context.Database.ExecuteSqlRaw(createStoredProcedureSql);
    }

    private static void MaakDatabase()
    {
        Console.WriteLine("Maak database ...");

        using var context = new Lokaal3Context();

        context.Database.EnsureDeleted();
        context.Database.EnsureCreated();

        context.Bestellingen.AddRange(
            new Model.Bestelling
            {
                Datum = DateOnly.FromDateTime(DateTime.Today).AddDays(-6),
                Aantal = 70,
            },
            new Model.Bestelling
            {
                Datum = DateOnly.FromDateTime(DateTime.Today).AddDays(-5),
                Aantal = 100,
            },
            new Model.Bestelling
            {
                Datum = DateOnly.FromDateTime(DateTime.Today).AddDays(-4),
                Aantal = 80,
            },
            new Model.Bestelling
            {
                Datum = DateOnly.FromDateTime(DateTime.Today).AddDays(-3),
                Aantal = 80,
            },
            new Model.Bestelling
            {
                Datum = DateOnly.FromDateTime(DateTime.Today).AddDays(-2),
                Aantal = 50,
            },
            new Model.Bestelling
            {
                Datum = DateOnly.FromDateTime(DateTime.Today).AddDays(-1),
                Aantal = 300,
            }
        );

        context.SaveChanges();
    }
}
