
part 'ref.dart';

/// Creator holds a state of type T and needs a reference to the dependency graph
class Creator<T> {

  const Creator(this.create);

  /// Creates a Creator
  final T Function(Ref ref, Creator<T> self) create;

  /// Delegates creator state to Element. This is to prevent mutating Creator state directly
  Element<T> createElement(Ref ref) => Element<T>(ref, this);

}

/// Element holds the state for creator
class Element<T> {
  
  Element(this.ref, this.creator) : state = creator.create(ref, creator);

  final Ref ref;
  
  final Creator<T> creator;
  
  T state;
  
  void recreate() {
    final newState = creator.create(ref, creator);
    if (newState != state) {
      state = newState;
      ref._onStateChange(creator);
    }
  }

  @override
  bool operator ==(covariant Element other) {
    return other.state == state;
  }
  
  @override
  int get hashCode => state.hashCode;

}
