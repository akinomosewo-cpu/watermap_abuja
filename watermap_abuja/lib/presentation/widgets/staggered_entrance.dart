import 'package:flutter/material.dart';

/// Wraps [child] with a short fade + upward slide entrance that starts after
/// a delay proportional to [index]. Used to give lists of tiles (district
/// list, tanker list, etc.) a light staggered-entrance feel without pulling
/// in an animation package.
class StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration baseDelay;
  final Duration stepDelay;
  final Duration duration;

  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = const Duration(milliseconds: 60),
    this.stepDelay = const Duration(milliseconds: 45),
    this.duration = const Duration(milliseconds: 320),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    // Cap the stagger so long lists don't keep animating for seconds.
    final cappedIndex = widget.index.clamp(0, 12);
    final delay = widget.baseDelay + widget.stepDelay * cappedIndex;
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
