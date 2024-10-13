class Nullable<T> {
  final T _value;

  Nullable(this._value);

  T get value {
    return _value;
  }
}

extension Cast on Object {
  Nullable<T> castTo<T>() {
    return Nullable<T>(this as T);
  }
}
