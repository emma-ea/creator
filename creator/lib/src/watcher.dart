import 'package:creator/creator.dart';
import 'package:flutter/widgets.dart';

class Watcher extends StatefulWidget {
  const Watcher(this.builder, {super.key});

  final Widget Function(BuildContext context, Ref ref, Creator self)? builder;

  @override
  State<Watcher> createState() => _WatcherState();
}

class _WatcherState extends State<Watcher> {

  late Creator<Widget> builder;
  late Ref ref;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref = CreatorGraph.of(context).ref;
    builder = Creator((ref, self) {
      setState(() {});
      return widget.builder!(context, ref, self);
    });
  }

  @override
  void dispose() {
    ref.dispose(builder);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.recreate(builder);
    return ref.watch(builder, null);
  }
}