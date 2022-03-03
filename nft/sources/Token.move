address 0x1 {
    module Token {
        use Std::Signer;
        use Std::Vector;

        const ENOT_MODULE: u64 = 0;

        struct Token has store {
            id: u64,
        }

        struct Collection has key {
            // Array of tokens owned by a user here, because you can only store one Token per
            // address. This is a faff though, because now you have to join/split them.
            tokens: vector<Token>
        }

        struct TokenInfo has key {
            name: vector<u8>,
            ipfsPrefix: vector<u8>,
            prevId: u64

        }

        public fun init(self: &signer, name: vector<u8>, ipfsPrefix: vector<u8>) {
            let self_addr = Signer::address_of(self);
            assert!(self_addr == @0x1, ENOT_MODULE);
            move_to(self, TokenInfo{
                name,
                ipfsPrefix,
                prevId: 0
            });
        }

        public fun name(): vector<u8> acquires TokenInfo {
            let info = borrow_global<TokenInfo>(@0x1);
            *&info.name
        }

        public fun mint(user: &signer) acquires Collection, TokenInfo {
            let id = &mut borrow_global_mut<TokenInfo>(@0x1).prevId;
            *id = *id + 1;

            let token = Token { id: *id };
            store(
              user,
              Collection { tokens: Vector::singleton(token) }
            );
        }

        public fun get(user: signer): Collection acquires Collection {
            move_from<Collection>(Signer::address_of(&user))
        }

        public fun store(user: &signer, b: Collection) acquires Collection {
            if (!exists<Collection>(Signer::address_of(user))) {
                move_to(user, Collection{tokens: Vector::empty() })
            };
            let a = move_from<Collection>(Signer::address_of(user));
            let c = join(a, b);
            move_to(user, c);
        }

        public fun size(collection: &Collection): u64 {
            Vector::length(&collection.tokens)
        }

        // Sucks we can only return ids here, not a rich Token type
        public fun tokens(user: address): vector<u64> acquires Collection {
            let c = &borrow_global<Collection>(user).tokens;
            let tokens = Vector::empty<u64>();
            let i = Vector::length(c);
            while (i > 0) {
                i = i - 1;
                Vector::push_back(&mut tokens, Vector::borrow<Token>(c, i).id);
            };
            tokens
        }

        public fun tokenUri(id: &u64): vector<u8> acquires TokenInfo {
            let uri = Vector::empty<u8>();
            Vector::append(&mut uri, b"ipfs://");
            Vector::append(&mut uri, *&borrow_global<TokenInfo>(@0x1).ipfsPrefix);
            Vector::append(&mut uri, b"/");
            Vector::append(&mut uri, itoa(id));
            Vector::append(&mut uri, b".json");
            uri
        }

        // Language doesn't provide this... :(
        fun itoa(num: &u64): vector<u8> {
            if (*num == 0) {
                return b"0"
            };

            let str = Vector::empty<u8>();
            while (*num != 0) {
                let rem = *num % 10;
                // 48 is char 0
                let c : u8 = (rem as u8) + 48;
                Vector::push_back(&mut str, c);
                num = &(*num / 10);
            };

            Vector::reverse(&mut str);
            str
        }

        public fun join(a: Collection, b: Collection): Collection {
            let Collection { tokens: aIds } = a;
            let Collection { tokens: bIds } = b;
            let tokens = Vector::empty<Token>();
            Vector::append(&mut tokens, aIds);
            Vector::append(&mut tokens, bIds);
            Collection { tokens }
        }

        public fun split(collection: Collection, id: u64): (Collection, Collection) {
            let Collection { tokens } = collection;
            let a = Vector::empty<Token>();
            let b = Vector::empty<Token>();
            let i = Vector::length(&tokens);
            while (i > 0) {
                i = i - 1;
                let x = Vector::pop_back(&mut tokens);
                if (x.id == id) {
                    Vector::push_back(&mut b, x);
                } else {
                    Vector::push_back(&mut a, x);
                };
            };
            Vector::destroy_empty(tokens);

            (Collection { tokens: a }, Collection { tokens: b })
        }

        public fun burn(token: Token): u64 {
            let Token { id } = token;
            id
        }
    }
}
