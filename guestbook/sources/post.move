script {
  use Std::Debug;
  use Std::Signer;
  use 0x42::Guestbook;

  fun main(account: signer) {
    let creator : address = @0xa;
    Guestbook::post(creator, &account, b"Hello world!");
    Debug::print(&Guestbook::last(creator, Signer::address_of(&account)))
  }

}
