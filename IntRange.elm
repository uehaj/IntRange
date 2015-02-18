module IntRange(IntRange(..)
               , to
               , downTo               
               , foldl
               , foldr
               , map
               , map2
               , toList
               ) where
{-| The library provides fold*/map* to the range of numbers without consuming memory.

IntRange.fold*/map* can be used as a replacement of List.fold*/map* on a list of consecutive Int values.

Using those method reduces memory when iterate on a list which have vast numbers of element and don't use the list after iterate.

For example,

          import IntRange (to)
          import IntRange
          Import List

          IntRange.foldl (+) 0 (0 `to` 100000000) -- Can be calculated without consuming less memory.
          List.foldl (+) 0 [0..100000000] -- Require memory for the list which length is 100000000.

Both of List.foldl and IntRange.foldl don't consume call stack, but List.foldl allocate memory for the list whose length is 100000000. In contrast, IntRange.fold requires relatively less memory. It can be used like counter variable of loop.

# Create IntRange
@docs to

# Iteration
@docs foldl, foldr, map, map2

# Convert
@docs toList

-}
import List (..)
import Trampoline as T
import Native.IntRange

type IntRange = IntRange Int Int Bool
{-
type IntRange = UpToRange Int Int -- lower to upper
              | DownToRange Int Int -- upper to lower
-}

{-| Reduce a range from the left: `(foldl (::) [] (1 `to` 3) == [3,2,1])` -}
foldl : (Int -> b -> b) -> b -> IntRange -> b
foldl = Native.IntRange.foldl

{-| Reduce a range from the right: `(foldr (+) 0 (1 `to` 3) == 6)` -}
foldr : (Int -> b -> b) -> b -> IntRange -> b
foldr = Native.IntRange.foldr

{-| Apply a function to every Int numbers in a list: `(map (\it->it*2) (1 `to` 3) == [2,4,6])` -}
map : (Int -> a) -> IntRange -> List a
map = Native.IntRange.map

{-| Combine a list and an IntRange, combining them with the given function.
If one list is longer, the extra elements are dropped.

      map2 (+) [1,2,3] (1 `to` 4) == [2,4,6]
-}
map2 : (a -> Int -> c) -> List a -> IntRange -> List c
map2 = Native.IntRange.map2

{-| Create range from two Ints. The range starts with the first argument and
    ends with the second one. Both of values are included in the range.
    In the other word (InRange start end) include both of end points.
-}
to : Int -> Int -> IntRange
to a b = IntRange a b False

{-| Create range from two Ints. The range starts with the second argument and
    ends with the first one. Both of values are included in the range.
    In the other word (InRange end start) include both of end points.
-}
downTo : Int -> Int -> IntRange
downTo a b = IntRange a b True

{-| Convert IntRange to List of Int([Int]).
-}
toList : IntRange -> List Int
toList range = map identity range
