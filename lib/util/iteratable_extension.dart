extension IteratableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for(E value in this) {
      if(test(value)) {
        return value;
      }
    }

    return null;
  }
}
