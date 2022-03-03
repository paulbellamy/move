script {
  use 0x1::Token;

  fun main(account: signer) {
    Token::init(&account, b"TestNFT", b"QmZHKZDavkvNfA9gSAg7HALv8jF7BJaKjUc9U2LSuvUySB");
  }

}
