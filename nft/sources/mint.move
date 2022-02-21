script {
  use 0x1::Token;

  fun main(owner: signer) {
    let creator = @0xa;
    Token::mint(creator, &owner);
  }

}
