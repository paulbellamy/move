script {
  use 0x1::Token;

  fun main(account: signer) {
    Token::init(&account, b"TestNFT");
  }

}
