
Tree structure

When pushing a route (a value of type <T> is given):
  the old way: stack = `stack.pushed(T());`

[Go] to a destination of type <T>
  When declaring a destination, provide a callback that returns a value if no value is known.
  Find a path to the Destination<T> in the tree.
  Set the stack to this path.
  What to do if there are two destinations of the same type in different locations?

Nested navigation...
  ```dart
  ShellDestination(
    shellBuilder: (context, child, value, controller) {}
    chilrden: []
  );
  ```

