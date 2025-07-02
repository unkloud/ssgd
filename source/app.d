import std.stdio;
import ssgd.cli;

void main(string[] args)
{
    auto cli = new CLI();
    int result = cli.run(args);
    if (result != 0)
    {
        import core.stdc.stdlib : exit;
        exit(result);
    }
}
