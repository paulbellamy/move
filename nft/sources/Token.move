address 0x1 {
    module Token {
        use Std::Signer;
        use Std::Vector;

        struct Token has store, key {
            // Array of ids owned by a user here, because you can only store one Token per address,
            // afaict. This is a faff though, because now you have to join/split them.
            ids: vector<u64>,
            size: u64,
        }

        struct TokenInfo has store, key {
            name: vector<u8>
        }

        struct HasMinted has store, key {
            nonces: vector<u64>,
            size: u64
        }

        public fun init(creator: &signer, name: vector<u8>): address {
            // Set up the token info on the creator's account?
            move_to(creator, TokenInfo{ name });
            Signer::address_of(creator)
        }

        public fun name(creator: address): vector<u8> acquires TokenInfo {
            let info = borrow_global<TokenInfo>(creator);
            *&info.name
        }

        public fun mint(_addr: &signer, id: u64, _nonce: u64): Token {
            // thinking through how you would issue nonces and check them allowing limited number
            // of mints per address.
            //
            // let address = Signer::address_of(addr);
            // if (!exists<HasMinted>(addr)) {
            //     move_to(address, HasMinted{
            //         nonces: Vector::singleton(nonce)
            //     });
            // } else {
            //     let hasMinted = &mut borrow_global_mut<HasMinted>(address);
            //     Vector::append<u64>(&mut hasMinted.nonces, nonce);
            // };
            Token { ids: Vector::singleton(id), size: 1 }
        }

        public fun get(addr: address): Token acquires Token {
            move_from<Token>(addr)
        }

        public fun store(address: &signer, token: Token) acquires Token {
            let addr = Signer::address_of(address);
            if (exists<Token>(addr)) {
                let existing = get(addr);
                token = join(existing, token);
            };
            move_to(address, token)
        }

        public fun size(token: &Token): &u64 {
            &token.size
        }

        public fun ids(token: &Token): &vector<u64> {
            &token.ids
        }

        public fun tokenUri(_id: &u64): vector<u8> {
            let uri = Vector::empty<u8>();
            Vector::append(&mut uri, b"ipfs://QmZHKZDavkvNfA9gSAg7HALv8jF7BJaKjUc9U2LSuvUySB/");
            // Vector::append(&mut uri, id);
            Vector::append(&mut uri, b".json");
            uri
        }

        // TODO: Ensure uniqueness
        public fun join(a: Token, b: Token): Token {
            let Token { ids: aIds, size: aSize } = a;
            let Token { ids: bIds, size: bSize } = b;
            let ids = Vector::empty<u64>();
            Vector::append(&mut ids, aIds);
            Vector::append(&mut ids, bIds);
            Token { ids, size: aSize + bSize }
        }

        // TODO: Implement this properly
        public fun split(token: Token, id: u64): (Token, Token) {
            let Token { ids, size } = token;
            let a = Vector::empty<u64>();
            let b = Vector::empty<u64>();
            let i = 0;
            while (i < size) {
                let x = Vector::pop_back(&mut ids);
                if (x == id) {
                    Vector::push_back(&mut b, x);
                } else {
                    Vector::push_back(&mut a, x);
                };
                i = i + 1
            };

            (Token { ids: a, size: size - 1 }, Token { ids: b, size: 1 })
        }

        spec split {
            token: Token;
            ensures token.size > 1;
        }

        public fun burn(token: Token): vector<u64> {
            let Token { ids, size: _size } = token;
            ids
        }
    }
}
