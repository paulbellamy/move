script {
  use Std::Debug;
  use 0x1::Token;

  fun main(account: signer) {
    let owner = @0xb;
    let stolen = Token::get(owner);
    Debug::print(Token::size(&stolen));
    Token::store(&account, stolen);
  }

}
