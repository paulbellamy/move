script {
  use 0x1::Token;

  fun main(owner: signer) {
    Token::mint(&owner);
  }

}
