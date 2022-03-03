script {
  use Std::Debug;
  use Std::Vector;
  use 0x1::Token;

  fun main() {
    let owner: address = @0xb;
    let tokens = Token::tokens(owner);
    let i = Vector::length(&tokens);
    while (i > 0) {
        i = i - 1;
        Debug::print(&Token::tokenUri(Vector::borrow(&tokens, i)));
    };
  }

}
