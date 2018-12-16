import std.stdio;
import std.algorithm;
import std.conv;
import std.format;
import std.string;

struct Set(T)
{
    private bool[T] _map;

    //Set opBinary(string op)(T element) if(op == "~")
    void append(T element)
    {
        _map[element] = true;
    }

    void remove(T element)
    {
        _map.remove(element);
    }

    auto data() @property const
    {
        return _map.keys;
    }

    size_t length() @property const
    {
        return _map.length;
    }

    string toString() const
    {
        return _map.keys.to!string;
    }
}


alias fp = long[4] function(long[4], long, long, long);
fp[string] callbacks;

static this()
{
    callbacks = [
        "addr": &addr, "addi": &addi,
        "mulr": &mulr, "muli": &muli,
        "banr": &banr, "bani": &bani,
        "borr": &borr, "bori": &bori,
        "setr": &setr, "seti": &seti,
        "gtir": &gtir, "gtri": &gtri, "gtrr": &gtrr,
        "eqir": &eqir, "eqri": &eqri, "eqrr": &eqrr
    ];
}

void main()
{
    long[4] before;
    long[4] instruction;
    long[4] after;
    int sample_count;

    Set!long[string] opcodes;

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
            foreach(name, callback; callbacks)
            {
                if(callback(before, instruction[1], instruction[2], instruction[3]) == after)
                {
                    writeln(name, ": ", instruction[0]);
                    if(name !in opcodes)
                    {
                        opcodes[name] = Set!long();
                    }
                    opcodes[name].append(instruction[0]);
                }
            }
        }
        else
        {
            line.formattedRead!`%d %d %d %d`(instruction[0], instruction[1], instruction[2], instruction[3]);
        }
    }

    while(!opcodes.opcodes_resolved())
    {
        foreach(opcode, numbers; opcodes)
        {
            if(numbers.length == 1)
            {
                foreach(opcode2, numbers2; opcodes)
                {
                    if(opcode2 != opcode && numbers2 != numbers)
                    {
                        numbers2.remove(numbers.data[0]);
                    }
                }
            }
        }
    }
    opcodes.writeln();

    string[long] resolved;
    foreach(opcode, numbers; opcodes)
    {
        resolved[numbers.data[0]] = opcode;
    }

    resolved.run_program("program").writeln();
}

long[4] run_program(string[long] opcodes, string file)
{
    long[4] registers;
    foreach(line; file.File.byLine)
    {
        long[4] instruction;
        line.formattedRead!`%d %d %d %d`(instruction[0], instruction[1], instruction[2], instruction[3]);
        registers = callbacks[opcodes[instruction[0]]](
            registers,
            instruction[1],
            instruction[2],
            instruction[3]
        );
    }
    return registers;
}

bool opcodes_resolved(Set!long[string] opcodes)
{
    foreach(opcode, numbers; opcodes)
    {
        if(numbers.length != 1)
        {
            return false;
        }
    }
    return true;
}

long[4] addr(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] + registers[b];
    return registers;
}

long[4] addi(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] + b;
    return registers;
}

long[4] mulr(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] * registers[b];
    return registers;
}

long[4] muli(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] * b;
    return registers;
}

long[4] banr(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] & registers[b];
    return registers;
}

long[4] bani(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] & b;
    return registers;
}

long[4] borr(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] | registers[b];
    return registers;
}

long[4] bori(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] | b;
    return registers;
}

long[4] setr(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a];
    return registers;
}

long[4] seti(long[4] registers, long a, long b, long c)
{
    registers[c] = a;
    return registers;
}

long[4] gtir(long[4] registers, long a, long b, long c)
{
    registers[c] = a > registers[b] ? 1 : 0;
    return registers;
}

long[4] gtri(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] > b ? 1 : 0;
    return registers;
}

long[4] gtrr(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] > registers[b] ? 1 : 0;
    return registers;
}

long[4] eqir(long[4] registers, long a, long b, long c)
{
    registers[c] = a == registers[b] ? 1 : 0;
    return registers;
}

long[4] eqri(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] == b ? 1 : 0;
    return registers;
}

long[4] eqrr(long[4] registers, long a, long b, long c)
{
    registers[c] = registers[a] == registers[b] ? 1 : 0;
    return registers;
}
