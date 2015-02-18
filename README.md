IntRange
========

The library provides fold/map* functions for the range of Int numbers avoiding consuming extra memory.

IntRange.foldl/foldr/map/map2 can be used replacement of List Int value which represents certain range of Int values.

This is useful when iterate vast numbers avoiding consuming extra memory.

For example,

```
      import IntRange (to)
      import IntRange
      Import List

      IntRange.foldl (+) 0 (0 `to` 100000000) -- Can be calculate without consuming extra memory.
      List.foldl (+) 0 [0..100000000] -- Requires memory for the List of Int which length is 100000000.
```

Both of List.foldl and IntRange.foldl don't consumes call stack, but List.foldl version consumes memory for the list [0..100000000], in the contrast of IntRange.fold requres relatively small constant memory.

You can create range and invert range by functions `to` and `downTo` respectedly:

```
       IntRange.map (\a->a+1) (1 `to` 3) -- [2,3,4]
       IntRange.map (\a->a+1) (3 `downTo` 1) -- [4,3,2]
```
