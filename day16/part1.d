import std.stdio;
import std.format;
import std.string;

void main()
{
    int[4] before;
    int[4] instruction;
    int[4] after;
    auto callbacks = [
        &addr, &addi,
        &mulr, &muli,
        &banr, &bani,
        &borr, &bori,
        &setr, &seti,
        &gtir, &gtri, &gtrr,
        &eqir, &eqri, &eqrr
    ];
    int sample_count;

    foreach(line; stdin.byLine)
    {
        if(line.strip.length == 0)
        {
            continue;
        }
        else if(line.startsWith("Before"))
        {
            line.formattedRead!`Before: [%d, %d, %d, %d]`(before[0], before[1], before[2], before[3]);
        }
        else if(line.startsWith("After"))
        {
            line.formattedRead!`After: [%d, %d, %d, %d]`(after[0], after[1], after[2], after[3]);
            int count;
            foreach(callback; callbacks)
            {
                if(callback(before, instruction[1], instruction[2], instruction[3]) == after)
                {
                    if(++count >= 3)
                    {
                        break;
                    }
                }
            }
            if(count >= 3)
            {
                sample_count++;
            }
        }
        else
        {
            line.formattedRead!`%d %d %d %d`(instruction[0], instruction[1], instruction[2], instruction[3]);
        }
    }
    sample_count.writeln();
}

int[4] addr(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] + registers[b];
    return registers;
}

int[4] addi(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] + b;
    return registers;
}

int[4] mulr(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] * registers[b];
    return registers;
}

int[4] muli(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] * b;
    return registers;
}

int[4] banr(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] & registers[b];
    return registers;
}

int[4] bani(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] & b;
    return registers;
}

int[4] borr(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] | registers[b];
    return registers;
}

int[4] bori(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] | b;
    return registers;
}

int[4] setr(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a];
    return registers;
}

int[4] seti(int[4] registers, int a, int b, int c)
{
    registers[c] = a;
    return registers;
}

int[4] gtir(int[4] registers, int a, int b, int c)
{
    registers[c] = a > registers[b] ? 1 : 0;
    return registers;
}

int[4] gtri(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] > b ? 1 : 0;
    return registers;
}

int[4] gtrr(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] > registers[b] ? 1 : 0;
    return registers;
}

int[4] eqir(int[4] registers, int a, int b, int c)
{
    registers[c] = a == registers[b] ? 1 : 0;
    return registers;
}

int[4] eqri(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] == b ? 1 : 0;
    return registers;
}

int[4] eqrr(int[4] registers, int a, int b, int c)
{
    registers[c] = registers[a] == registers[b] ? 1 : 0;
    return registers;
}
