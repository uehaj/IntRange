IntRange
========

The library provides fold/map/zip to the range of numbers without consuming memory.

IntRange.foldl/foldr/maps can be used replacement of [Int] value which represents certain range of Int values.

This is useful when iterate vast numbers without consuming memory.

For example,

```
      import IntRange (to)
      import IntRange
      Import List

      IntRange.foldl (+) 0 (0 `to` 100000000) -- Can be calculate without consuming memory.
      List.foldl (+) 0 [0..100000000] -- Require memory fo the list which length is 100000000.
```

Both of List.foldl and IntRange.foldl don't consumes call stack, but List.foldl version consumes vast amount of memory in the contrast of IntRange.fold requres relatively small constant memory.
