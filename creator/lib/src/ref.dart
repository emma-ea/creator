part of 'creator.dart';

/// Ref holds a set of creator and its states
class Ref {
  Ref();
  
  /// A set of creators being managed by ref
  /// Elements which hold state
  final Map<Creator, Element> _elements = {};

  /// A Creator can map to other creators. That how the dependency graph is made
  /// A -> [B, C] If A changes, B and C need to change too
  final Map<Creator, Set<Creator>> _graph = {};

  /// Get or create an element for creator
  Element _element<T>(Creator creator) => 
    _elements.putIfAbsent(creator, () => creator.createElement(this));


  /// Add an edge creator -> watcher to the graph, 
  /// then returns the creator's state
  T watch<T>(Creator<T> creator, Creator? watcher) {
    if (watcher != null) {
      (_graph[creator] ??= {}).add(watcher);
    }
    return _element<T>(creator).state;
  }


  /// Set state of the creator
  void set<T>(Creator<T> creator, T state) {
    final element = _element<T>(creator);
    if (state != element.state) {
      element.state = state;
      _onStateChange(creator);
    }
  }

  /// Set state of creator using an update fuunction. See [set]
  void update<T>(Creator<T> creator, T Function(T) update) {
    set<T>(creator, update(_element(creator).state));
  }

  /// Propagate state changes through watching dependencies
  void _onStateChange(Creator creator) {
    for (final c in _graph[creator] ?? {}) {
      _element(c).recreate();
    }
  }

}