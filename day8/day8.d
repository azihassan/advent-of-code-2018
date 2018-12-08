import std.stdio;
import std.algorithm;

void main()
{
    auto root = node_read();
    writeln("1st part: ", root.metadata_sum());
    root.compute_value();
    writeln("2nd part: ", root.value);
}

int metadata_sum(Node root)
{
    return root.metadata.sum + root.children.map!metadata_sum.sum;
}

void compute_value(ref Node root)
{
    if(root.value_computed)
    {
        return;
    }
    if(root.children.length == 0)
    {
        root.value = root.metadata.sum;
        root.value_computed = true;
        return;
    }
    foreach(metadata; root.metadata)
    {
        if(metadata == 0 || metadata - 1 >= root.children.length)
        {
            continue;
        }
        root.children[metadata - 1].compute_value();
        root.value += root.children[metadata - 1].value;
        root.value_computed = true;
    }
}

Node node_read()
{
    Node node;
    readf!"%d %d "(node.child_length, node.metadata_length);
    node.metadata = new int[node.metadata_length];
    node.children = new Node[node.child_length];

    if(node.child_length == 0)
    {
        foreach(i; 0 .. node.metadata_length)
        {
            node.metadata[i].readf!"%d ";
        }
        return node;
    }
    foreach(i; 0 .. node.child_length)
    {
        node.children[i] = node_read();
    }
    foreach(i; 0 .. node.metadata_length)
    {
        node.metadata[i].readf!"%d ";
    }
    return node;
}

struct Node
{
    int child_length;
    int metadata_length;
    int[] metadata;
    Node[] children;
    int value;
    bool value_computed;
}
