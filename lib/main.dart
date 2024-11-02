import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());

}


/// this [MyApp] class will be root of our widget tree and it is stateless widget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// The [build] method will  create a [MaterialApp] which contains visually appealing ui widgets for UI
  /// we are removing debug flag by setting [MaterialApp.debugShowCheckedModeBanner] to false
  /// we are displaying our first widget [SquareAnimation] using [MaterialApp.home] property
  /// by giving a all side padding of 32 using [Padding.padding] and [EdgeInsets.all]
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

/// This clas [SquareAnimation] is inherited from [StatefulWidget]
/// so this class has a mutable state
class SquareAnimation extends StatefulWidget{
  const SquareAnimation({super.key});


  /// The [createState] method create a mutable state which creates an instance of a state associated with subclass
  /// by overriding it.
  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}


/// The [SquareAnimationState] is inheriting from [State] class as this is a [StatefulWidget] which contains
/// a multiple widget to access those widget we are inheriting it
/// also we are inheriting it for [SingleTickerProviderStateMixin]
/// for creating [AnimationController] to control the animation of the state
class SquareAnimationState extends State<SquareAnimation> with SingleTickerProviderStateMixin {
  /// we are assigning of squares ize as 50 in [_squareSize] variable.
  static const _squareSize = 50.0;
  /// The [_moveController] will be used to control animation
  late AnimationController _moveController;
  /// The [_slideBoxAnimation] will used to move box position
  late Animation<double> _slideBoxAnimation;
  /// [_position] created to track and store position of a box
  double _position = 0.0;
  /// [_isAnimating] variable created to check and store animation status
  bool _isAnimating = false;



  /// The [initState] method initialize the app state
  ///
  /// In this method we are initializing the late variable [_moveController] with
  /// [AnimationController] class and setting its time to 1 sec as (1000 ms) using [AnimationController.duration.milliseconds] property
  /// and assigning it to [SquareAnimation] context using [AnimationController.vsync] property
  ///
  /// We are using [WidgetsBinding.instance] class and calling [WidgetsBinding.instance.addPostFrameCallback] method
  /// which will update state using [setState] and box [_position] to centre
  /// using formula [MediaQuery.size.width] / 2 - 25
  /// this will centre the [_position] of box immediately after the end of [initState]
  @override
  void initState() {


    _moveController = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _position = MediaQuery.of(context).size.width / 2 - 25; // Centering
      });
    });

    super.initState();
  }

  /// this will override the dispose method and disposes the [_moveController]
  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }


  /// this function [_startBoxMovement] will handle box movement from left to right or vice-versa
  ///
  /// if isRight flag is true then it call [_moveRight] else [_moveLeft]
  void _startBoxMovement(bool isRight) {

      if(isRight){
        _moveRight();
      }else{
        _moveLeft();
      }
  }


  /// this [_moveRight] method will handle all movement and track animation status variables
  /// like [_position], [_isAnimating] in right side
  /// the [_position] of the box will begin from center to the end of the screen
  /// after that from right to the left of screen
  /// and this will happen firstly by setting set by [setState] method
  /// and initializing the [_slideBoxAnimation] with [Tween] class.
  /// and with the help of [Tween.begin]=[_position] and [Tween.end] = 0 properties.
  /// we are getting end of the screen using [MediaQuery.size.width] and subtracting it by 116
  /// to keep box inside screen and within the [Padding.EdgeInsets.all] of 32
  ///
  /// Here the [Tween.addListener] method will be updating [_position] value using class property [_slideBoxAnimation.value]
  /// [Tween.addStatusListener] method will be updating [_isAnimating] status (true or false)
  /// Here in [Tween.animate] method we will be setting animation as [CurvedAnimation]
  /// with its type [CurvedAnimation.curve] as [Curves.decelerate]
  ///
  /// we are assigning our [_moveController] to this [CurvedAnimation.parent]
  /// we are assigning O using [_moveController.forward] method property [_moveController.forward.from]
  /// to keep box moving towards the end from starting position
  void _moveRight() {


    setState(() {
      _isAnimating = true;

      _slideBoxAnimation = Tween<double>(
        begin: _position,
        end: MediaQuery.of(context).size.width - 116,
      )
      .animate(CurvedAnimation(parent: _moveController, curve: Curves.decelerate))
      ..addListener(() {
          setState(() {
            _position = _slideBoxAnimation.value;
          });
        })
      ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _isAnimating = false;
            });
          }
        });
      _moveController.forward(from: 0);
    });
  }


  /// this [_moveLeft] method will handle all movement and track animation status variables
  /// like [_position], [_isAnimating] in left side
  /// the [_position] of the box will begin from center
  /// to the left of the screen or from right to the left of the screen
  /// and this will happen firstly by setting set by [setState] method
  /// and initializing the [_slideBoxAnimation] with [Tween] class.
  /// and with the help of [Tween.begin] = [_position] and [Tween.end] = 0 properties.
  ///
  /// Here the [Tween.addListener] method will be updating [_position] value using class property [_slideBoxAnimation.value]
  /// [Tween.addStatusListener] method will be updating [_isAnimating] status (true or false)
  /// Here in [Tween.animate] method we will be setting animation as [CurvedAnimation]
  /// with its type [CurvedAnimation.curve] as [Curves.decelerate]
  ///
  /// we are assigning our [_moveController] to this [CurvedAnimation.parent]
  /// we are assigning O using [_moveController.forward] method property [_moveController.forward.from]
  /// to keep box moving towards the end from starting position
  void _moveLeft() {

    setState(() {
      _isAnimating = true;
      _slideBoxAnimation= Tween<double>(
        begin: _position,
        end: 0.0,
      ).animate(CurvedAnimation(parent: _moveController, curve: Curves.decelerate))
        ..addListener(() {
          setState(() {
            _position = _slideBoxAnimation.value;
          });
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _isAnimating = false;
            });
          }
        });
      _moveController.forward(from: 0);
    });
  }



  /// This [build] method is create a parent widget [Column]
  /// which contains [SizedBox],[SizedBox] for setting padding height and [Row] as children.
  /// First [SizedBox] is having its child as a [Stack] and it children as a [Container] which is our red square box
  /// and was wrap by [Positioned] widget
  /// Second [SizedBox] is used for leaving space between box and buttons
  /// [Row] has two [ElevatedButton] as children for right and left movement
  ///
  /// we are setting [SizedBox.width] as double.infinity and [SizedBox.height] as [_squareSize]
  /// to restrict [Stack] widget render box overflow
  /// we are wrapping our [Container] inside [Stack] with [Positioned] widget
  /// to update its position with the change of state
  /// using [Positioned.left] property
  /// we are assigning our sizes our box using [Container.width],
  /// [Container.width] and color using [Container.BoxDecoration] properties.
  ///
  /// Here [ElevatedButton] class property
  /// [ElevatedButton.onPressed] is calling [_startBoxMovement] function with argument as isRight
  /// (which will be true for right button and false for left button)
  /// These [ElevatedButton] further has child as [Text] widget which helps identify which button is left or right
  /// we are disabling this [ElevatedButton] by setting its [ElevatedButton.onPressed] property to null
  /// if the condition satisfies for both right and left
  /// for Right the condition is if [_isAnimating] is false and [_position] is less than
  /// end size (including padding and box size) of screen then button is enabled else disabled
  /// for Left the condition is if [_isAnimating] is false and [_position] is greater than zero
  /// then button is enable else disabled
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: _squareSize,
          child: Stack(
            children: [
              Positioned(
                left: _position ,
                child: Container(
                  width: _squareSize,
                  height: _squareSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(),
                  ),
                ),
              ),
            ]
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed:(!_isAnimating &&
                  _position < MediaQuery.of(context).size.width - 116)
                  ? () {
                _startBoxMovement(true);
              }: null,
              child: const Text('Right'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: (!_isAnimating && _position > 0) ? () {
                _startBoxMovement(false);
              } : null,
              child:const Text('Left'),
            ),
          ],
        ),
      ],
    );
  }
}



