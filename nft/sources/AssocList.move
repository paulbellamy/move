address 0x1 {
    module AssocList {
        use Std::Signer;
        use Std::Vector;
        use Std::Option;

        struct Dict<K, V> has key, store {
            items: vector<Tuple<K, V>>
        }

        struct Tuple<K, V> has store, copy, drop {
            k: K,
            v: V
        }

        public fun empty<K, V>() : Dict<K, V> {
            Dict { items: Vector::empty() }
        }

        public fun singleton<K, V>(k : K, v : V) : Dict<K, V> {
            Dict { items: Vector::singleton(Tuple { k, v }) }
        }

        public fun insert<K: copy, V>(d : &mut Dict<K, V>, k : &K, v : V) {
            if (member(d, k)) {
                remove(d, k);
            };
            Vector::push_back(&mut (d.items), Tuple { k: *k, v })
        }

        public fun update<K, V>(d : &mut Dict<K, V>, k : &K, v : V) {
        }

        public fun remove<K, V>(d : &mut Dict<K, V>, k : &K) : V {
            let i = 0;
            let len = size(d);
            while (i < len) {
                let tuple = Vector::borrow(&d.items, i);
                if (&tuple.k == k) {
                    let Tuple { k, v } = tuple;
                    return Vector::remove(&mut d.items, i);
                };
            };
            abort 42
        }

        public fun is_empty<K, V>(d : &Dict<K, V>) : bool {
            Vector::is_empty(&d.items)
        }

        public fun member<K, V>(d : &Dict<K, V>, k : &K) : bool {
            let i = 0;
            let len = size(d);
            while (i < len) {
                let tuple = Vector::borrow(&d.items, i);
                if (&tuple.k == k) {
                    return true
                };
            };
            false
        }

        public fun borrow<K, V>(d : &Dict<K, V>, k : &K) : &V {
            let i = 0;
            let len = size(d);
            while (i < len) {
                let tuple = Vector::borrow(&d.items, i);
                if (&tuple.k == k) {
                    return &tuple.v
                };
            };
            abort 42
        }

        // public fun borrow_mut<K, V>(d : &Dict<K, V>, k : K) : Option<&V> {
        // }


        public fun size<K, V>(d : &Dict<K, V>) : u64 {
            Vector::length(&d.items)
        }

        // public fun eq<K, V>(d : &Dict<K, V>) : u64 {
        // }
    }
}
