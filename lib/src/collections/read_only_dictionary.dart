part of queries.collections;

abstract class IReadOnlyDictionary<TKey, TValue>  implements IReadOnlyCollection<KeyValuePair<TKey, TValue>>, IQueryable<KeyValuePair<TKey, TValue>> {
  IEqualityComparer<TKey> get comparer;

  TValue operator [](TKey key);

  IQueryable<TKey> get keys;

  IQueryable<TValue> get values;

  bool containsKey(TKey key);

  Map<TKey, TValue> toMap();
}

class ReadOnlyDictionary<TKey, TValue> extends _ReadOnlyDictionary<TKey, TValue> with Queryable<KeyValuePair<TKey, TValue>> {
  ReadOnlyDictionary(IDictionary<TKey, TValue> dictionary) {
    if(dictionary == null) {
      throw new ArgumentError("dictionary: $dictionary");
    }

    _dictionary = dictionary;
  }

  ReadOnlyDictionaryKeyCollection<TKey, TValue> get keys {
    return new ReadOnlyDictionaryKeyCollection<TKey, TValue>(this);
  }

  ReadOnlyDictionaryValueCollection<TKey, TValue> get values {
    return new ReadOnlyDictionaryValueCollection<TKey, TValue>(this);
  }
}

class ReadOnlyDictionaryKeyCollection<TKey, TValue> extends Object with Queryable<TKey> implements ICollection<TKey> {
  IDictionary<TKey, TValue> _dictionary;

  ICollection<TKey> _items;

  ReadOnlyDictionaryKeyCollection(IDictionary<TKey, TValue> dictionary) {
    if(dictionary == null) {
      throw new ArgumentError("dictionary: $dictionary");
    }

    _dictionary = dictionary;
    _items = dictionary.keys;
  }

  bool get isReadOnly {
    return true;
  }

  Iterator<TKey> get iterator {
    return _items.iterator;
  }

  int get length {
    return _items.length;
  }

  void add(TKey item) {
    throw new UnsupportedError("add()");
  }

  void clear() {
    throw new UnsupportedError("clear()");
  }

  bool containsValue(TKey value) {
    var iterator = this.iterator;
    while(iterator.moveNext()) {
      if(value == iterator.current) {
        return true;
      }
    }

    return false;
  }

  // TODO: copyTo()
  void copyTo(List<TKey> list, int index) {
    throw new UnimplementedError("copyTo()");
  }

  bool remove(TKey item) {
    throw new UnsupportedError("remove()");
  }

  String toString() {
    return _items.toString();
  }
}

class ReadOnlyDictionaryValueCollection<TKey, TValue> extends Object with Queryable<TValue> implements ICollection<TValue> {
  IDictionary<TKey, TValue> _dictionary;

  ICollection<TValue> _items;

  ReadOnlyDictionaryValueCollection(IDictionary<TKey, TValue> dictionary) {
    if(dictionary == null) {
      throw new ArgumentError("dictionary: $dictionary");
    }

    _dictionary = dictionary;
    _items = dictionary.values;
  }

  bool get isReadOnly {
    return true;
  }

  Iterator<TValue> get iterator {
    return _items.iterator;
  }

  int get length {
    return _items.length;
  }

  void add(TValue item) {
    throw new UnsupportedError("add()");
  }

  void clear() {
    throw new UnsupportedError("clear()");
  }

  bool containsValue(TValue value) {
    var iterator = this.iterator;
    while(iterator.moveNext()) {
      if(value == iterator.current) {
        return true;
      }
    }

    return false;
  }

  // TODO: copyTo()
  void copyTo(List<TValue> list, int index) {
    throw new UnimplementedError("copyTo()");
  }

  bool remove(TValue item) {
    throw new UnsupportedError("remove()");
  }

  String toString() {
    return _items.toString();
  }
}

abstract class _ReadOnlyDictionary<TKey, TValue> implements ICollection<KeyValuePair<TKey, TValue>>, IDictionary<TKey, TValue>, IReadOnlyCollection<KeyValuePair<TKey, TValue>>, IReadOnlyDictionary<TKey, TValue> {
  IDictionary<TKey, TValue> _dictionary;

  IEqualityComparer<TKey> get comparer {
    return _dictionary.comparer;
  }

  bool get isReadOnly {
    return true;
  }

  Iterator<KeyValuePair<TKey, TValue>> get iterator {
    return _getIterator();
  }

  int get length {
    return _dictionary.length;
  }

  TValue operator [](TKey key) {
    return _dictionary[key];
  }

  void operator []=(TKey key, TValue value) {
    throw new UnsupportedError("operator []=");
  }

  void add(KeyValuePair<TKey, TValue> element) {
    throw new UnsupportedError("add()");
  }

  void clear() {
    throw new UnsupportedError("clear()");
  }

  bool containsKey(TKey key) {
    return _dictionary.containsKey(key);
  }

  bool containsValue(KeyValuePair<TKey, TValue> item) {
    return _dictionary.containsValue(item);
  }

  // TODO: copyTo()
  void copyTo(List<KeyValuePair<TKey, TValue>> list, int index) {
    throw new UnimplementedError("copyTo()");
  }

  bool remove(KeyValuePair<TKey, TValue> element) {
    throw new UnsupportedError("remove()");
  }

  bool removeKey(TKey key) {
    throw new UnsupportedError("removeKey()");
  }

  Map<TKey, TValue> toMap() {
    var map = new LinkedHashMap(equals : _dictionary.comparer.equals, hashCode : _dictionary.comparer.getHashCode);
    for(var kvp in this) {
      map[kvp.key] = kvp.value;
    }

    return map;
  }

  Iterator<KeyValuePair<TKey, TValue>> _getIterator() {
    Iterator<TKey> keysIterator;
    var iterator = new _Iterator<KeyValuePair<TKey, TValue>>();
    iterator.action = () {
      while(true) {
        switch(iterator.state) {
          case 1:
            if(keysIterator.moveNext()) {
              var key = keysIterator.current;
              iterator.result = new KeyValuePair(key, _dictionary[key]);
              return true;
            }

            keysIterator = null;
            iterator.state = -1;
            return false;
          case 0:
            keysIterator = _dictionary.keys.iterator;
            iterator.state = 1;
            break;
          default:
            return false;
        }
      }
    };

    return iterator;
  }

  String toString() {
    return _dictionary.toString();
  }
}