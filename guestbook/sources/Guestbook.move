address 0x42 {
    module Guestbook {
        // Abusing the storage system to do a centralized ledger. ERC20 airdrop style
        use Std::Signer;
        use Std::Vector;

        struct Guestbook has key {
            entries: vector<Entry>,
            size: u64
        }

        struct Entry has store {
            author: address,
            message: vector<u8>
        }

        public fun init(creator: &signer) {
          move_to(creator, Guestbook { entries: Vector::empty(), size: 0 })
        }

        public fun post(creator: address, user: &signer, message: vector<u8>) acquires Guestbook {
            let author = Signer::address_of(user);
            let guestbook = borrow_global_mut<Guestbook>(creator);
            Vector::append(&mut guestbook.entries, Vector::singleton(Entry{ author, message }));
            guestbook.size = guestbook.size + 1;
        }

        public fun first(creator: address, user: address): vector<u8> acquires Guestbook {
            let guestbook = borrow_global_mut<Guestbook>(creator);
            let i = 0;
            while (i < guestbook.size) {
                let entry = Vector::borrow(&guestbook.entries, i);
                if (entry.author == user) {
                    return *&entry.message
                };
                i = i + 1;
            };
            return b""
        }

        public fun last(creator: address, user: address): vector<u8> acquires Guestbook {
            let guestbook = borrow_global_mut<Guestbook>(creator);
            let i = 0;
            let found = b"";
            while (i < guestbook.size) {
                let entry = Vector::borrow(&guestbook.entries, i);
                if (entry.author == user) {
                    found = *&entry.message;
                };
                i = i + 1;
            };
            found
        }
    }
}
