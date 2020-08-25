int fib(int n)
{
    if (n < 2) return n;
    else return fib(n - 1) + fib(n - 2);
}

void main()
{
    auto result = fib(10);
    assert(result == 55);
}
