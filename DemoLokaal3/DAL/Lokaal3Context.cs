using DemoLokaal3.Model;
using Microsoft.EntityFrameworkCore;

namespace DemoLokaal3.DAL;

public class Lokaal3Context : DbContext
{
    public DbSet<Bestelling> Bestellingen => Set<Bestelling>();

    public DbSet<BestellingResultaat> Resultaten => Set<BestellingResultaat>();


    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(
        @"Server=127.0.0.1,1433;Database=Lokaal3;User=sa;Password=
Wat1g03dg3h31m!;TrustServerCertificate=True");

    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Bestelling>()
        .ToTable("bestellingen");

        modelBuilder.Entity<Bestelling>()
        .HasKey(x => x.Datum);

        modelBuilder.Entity<Bestelling>()
        .Property(x => x.Datum)
        .HasColumnName("datum");

        modelBuilder.Entity<Bestelling>()
        .Property(x => x.Aantal)
        .HasColumnName("aantal");

        modelBuilder.Entity<BestellingResultaat>()
        .HasNoKey();

        modelBuilder.Entity<BestellingResultaat>()
        .Property(x => x.Datum)
        .HasColumnName("datum");

        modelBuilder.Entity<BestellingResultaat>()
        .Property(x => x.Aantal)
        .HasColumnName("aantal");

        modelBuilder.Entity<BestellingResultaat>()
        .Property(x => x.RunningTotal)
        .HasColumnName("running_total");

        modelBuilder.Entity<BestellingResultaat>()
        .Property(x => x.RankAantal)
        .HasColumnName("rank_aantal");
    }
}
