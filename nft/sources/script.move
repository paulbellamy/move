script {
  use Std::Debug;
  use Std::Vector;
  use 0x1::Token;

  fun main(account: signer) {
    let _creator = Token::init(&account, b"TestNFT");
    let token = Token::mint(&account, 1, 0);
    let ids = Token::ids(&token);
    Debug::print(ids);
    let i : u64 = 0;
    let tokenSize = *Token::size(&token);
    while (i < tokenSize) {
        let id = Vector::borrow(ids, i);
        let uri = Token::tokenUri(id);
        Debug::print(&uri);
        i = i + 1;
    };
    Token::store(&account, token);
  }

}
