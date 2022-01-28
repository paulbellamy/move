script {
  use Std::Debug;
  use 0x1::Math;

  fun debug_script(account: signer, n: u64) {
      Debug::print<u64>(Math::fib(n))
  }

}
