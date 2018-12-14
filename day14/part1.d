import std.stdio;
import std.conv;

void main()
{
    int[] recipies = [3, 7, 1, 0];
    ulong elf_1 = 0;
    ulong elf_2 = 1;
    auto input = 846601;

    while(recipies.length < input + 11)
    {
        auto sum = to!string(recipies[elf_1] + recipies[elf_2]);
        foreach(s; sum)
        {
            recipies ~= s - '0';
        }
        elf_1 = (elf_1 + recipies[elf_1] + 1) % recipies.length;
        elf_2 = (elf_2 + recipies[elf_2] + 1) % recipies.length;
    }
    writeln(recipies[input .. input + 10]);
}
