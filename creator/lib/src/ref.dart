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

  /// Delete the creator if it has no watcher. Also delete other creators
  /// who loses all their watchers
  void dispose(Creator creator) {
    if ((_graph[creator] ?? {}).isNotEmpty) {
      return; // The creator is being watched by someone, cannot dispose it
    }

    _elements.remove(creator);
    _graph.remove(creator);
    
    for (final c in _elements.keys.toSet()) {
      if ((_graph[c] ?? {}).contains(creator)) {
        _graph[c]!.remove(creator);
        dispose(c); // Dispose c if creator is the only watcher of c
      }
    }

  }

  void recreate(Creator creator) {
    _element(creator).recreate();
  }

}