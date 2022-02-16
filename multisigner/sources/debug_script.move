script {
  use Std::Debug;
  use Std::Signer;

  fun debug_script(first: signer, second: signer) {
      Debug::print(&Signer::address_of(&first));
      Debug::print(&Signer::address_of(&second))
  }

}
