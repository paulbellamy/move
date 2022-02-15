script {
  use 0x42::Guestbook;

  fun main(account: signer) {
    Guestbook::init(&account);
  }
}
