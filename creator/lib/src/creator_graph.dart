import 'package:creator/creator.dart';
import 'package:flutter/widgets.dart';

class CreatorGraph extends InheritedWidget {

  CreatorGraph({
    super.key, 
    required super.child
  }) : ref = Ref();

  final Ref ref;

  static CreatorGraph of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CreatorGraph>()!;
  }
  
  @override
  bool updateShouldNotify(CreatorGraph oldWidget) {
    return ref != oldWidget.ref;
  }

}

extension ContextRef on BuildContext {
  Ref get ref => CreatorGraph.of(this).ref;
}