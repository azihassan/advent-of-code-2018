import std.stdio;
import std.range;
import std.conv;
import std.algorithm;
import std.array;

void main()
{
    auto input = stdin.byLine.map!(to!int).array;
    writeln("Part 1: ", input.sum);

    int[int] frequencies;
    int frequency;
    foreach(n; input.cycle)
    {
        frequency += n;
        if(frequency in frequencies)
        {
            writeln("Part 2: ", frequency);
            return;
        }
        frequencies[frequency] = 0;
    }
}
