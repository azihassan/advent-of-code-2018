import std.stdio;
import std.conv;
import std.algorithm;

void main()
{
    int[] recipies = [3, 7, 1, 0];
    ulong elf_1 = 0;
    ulong elf_2 = 1;
    auto input = [8, 4, 6, 6, 0, 1];

    while(true)
    {
        auto sum = to!string(recipies[elf_1] + recipies[elf_2]);
        foreach(s; sum)
        {
            recipies ~= s - '0';
            if(recipies.length >= input.length && recipies.endsWith(input))
            {
                writeln(recipies.length - input.length);
                return;
            }
        }
        elf_1 = (elf_1 + recipies[elf_1] + 1) % recipies.length;
        elf_2 = (elf_2 + recipies[elf_2] + 1) % recipies.length;
    }
}
