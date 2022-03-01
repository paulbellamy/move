address 0x1 {
    module Token {
        use Std::Signer;
        use Std::Vector;

        struct Token has store {
            id: u64,
        }

        struct Collection has key {
            // Array of tokens owned by a user here, because you can only store one Token per
            // address. This is a faff though, because now you have to join/split them.
            tokens: vector<Token>,
            size: u64,
        }

        struct TokenInfo has key {
            name: vector<u8>,
            lastId: u64

        }

        public fun init(creator: &signer, name: vector<u8>) {
            move_to(creator, TokenInfo{ name, lastId: 0 });
        }

        public fun name(creator: address): vector<u8> acquires TokenInfo {
            let info = borrow_global<TokenInfo>(creator);
            *&info.name
        }

        public fun mint(creator: address, user: &signer ) acquires Collection, TokenInfo {
            let id = &mut borrow_global_mut<TokenInfo>(creator).lastId;
            *id = *id + 1;

            let token = Token { id: *id };
            store(
              user,
              Collection { tokens: Vector::singleton(token), size: 1 }
            );
        }

        public fun get(user: signer): Collection acquires Collection {
            move_from<Collection>(Signer::address_of(&user))
        }

        public fun store(user: &signer, b: Collection) acquires Collection {
            if (!exists<Collection>(Signer::address_of(user))) {
                move_to(user, Collection{tokens: Vector::empty(), size: 0})
            };
            let a = move_from<Collection>(Signer::address_of(user));
            let c = join(a, b);
            move_to(user, c);
        }

        public fun size(collection: &Collection): &u64 {
            &collection.size
        }

        public fun tokens(collection: &Collection): &vector<Token> {
            &collection.tokens
        }

        public fun tokenUri(id: &u64): vector<u8> {
            let uri = Vector::empty<u8>();
            Vector::append(&mut uri, b"ipfs://QmZHKZDavkvNfA9gSAg7HALv8jF7BJaKjUc9U2LSuvUySB/");
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
            let size = 0;
            while (*num != 0) {
                let rem = *num % 10;
                // 48 is char 0
                let c : u8 = (rem as u8) + 48;
                Vector::push_back(&mut str, c);
                num = &(*num / 10);
                size = size + 1
            };

            Vector::reverse(&mut str);
            str
        }

        // TODO: Ensure uniqueness
        public fun join(a: Collection, b: Collection): Collection {
            let Collection { tokens: aIds, size: aSize } = a;
            let Collection { tokens: bIds, size: bSize } = b;
            let tokens = Vector::empty<Token>();
            Vector::append(&mut tokens, aIds);
            Vector::append(&mut tokens, bIds);
            Collection { tokens, size: aSize + bSize }
        }

        // // TODO: Implement this properly
        // public fun split(collection: Collection, id: u64): (Collection, Collection) {
        //     let Collection { tokens, size } = collection;
        //     let a = Vector::empty<Token>();
        //     let b = Vector::empty<Token>();
        //     let i = 0;
        //     while (i < size) {
        //         let x = Vector::pop_back(&mut tokens);
        //         if (x.id == id) {
        //             Vector::push_back(&mut b, x);
        //         } else {
        //             Vector::push_back(&mut a, x);
        //         };
        //         i = i + 1
        //     };

        //     (Collection { tokens: a, size: size - 1 }, Collection { tokens: b, size: 1 })
        // }

        // spec split {
        //     token: Token;
        //     ensures token.size > 1;
        // }

        public fun burn(token: Token): u64 {
            let Token { id } = token;
            id
        }
    }
}
