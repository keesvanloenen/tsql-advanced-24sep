namespace DemoLokaal3.Model;

public class BestellingResultaat
{
    public DateOnly Datum { get; set; }
    public long Aantal { get; set; }
    public long RunningTotal { get; set; }
    public long RankAantal { get; set; }
}
