import std.stdio : writeln, readln;
import std.range : back, popBack, empty;
import std.algorithm : min, filter;
import std.array : array;
import std.string : strip;
import std.uni : toLower, isLower, toUpper, isUpper;
import std.conv : to;

void main()
{
    auto polymer = readln.strip;
    polymer.to!(dchar[]).condense().writeln();

    bool[dchar] letters;
    foreach(l; polymer)
    {
        letters[l.toLower] = true;
    }

    ulong min_length = ulong.max;
    foreach(letter, ignore; letters)
    {
        auto result = polymer.filter!(l => l.toLower != letter).array.condense();
        min_length = min(min_length, result);
    }
    writeln(min_length);
}

ulong condense(dchar[] polymer)
{
    auto i = 1;
    dchar[] stack = [polymer[0]];

    outer:
    while(true)
    {
        auto current = polymer[i];
        while(
            !stack.empty &&
            (
                (stack.back.isLower && stack.back.toUpper == polymer[i]) ||
                (stack.back.isUpper && stack.back.toLower == polymer[i])
            )
        )
        {
            stack.popBack;
            if(++i == polymer.length)
            {
                break outer;
            }
        }
        stack ~= polymer[i];
        if(++i == polymer.length)
        {
            break;
        }
    }
    return stack.length;
}
