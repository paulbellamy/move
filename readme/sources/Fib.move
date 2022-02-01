address 0x1 {
    module Math {
        public fun sum(a: u64, b: u64): u64 {
            a + b
        }

        public fun fib(n: u64): u64 {
            if (n <= 1) {
                n
            } else {
                fib(n-1) + fib(n-2)
            }
        }
    }
}
