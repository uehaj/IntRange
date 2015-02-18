module IntRange(IntRange(..)
               , to
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

type IntRange = IntRange Int Int

{-| Reduce a range from the left: `(foldl (::) [] (1 `to` 3) == [3,2,1])` -}
foldl : (Int -> b -> b) -> b -> IntRange -> b
foldl func acc (IntRange start end) = T.trampoline <| foldl' func acc start end

foldl' : (Int -> b -> b) -> b -> Int -> Int -> T.Trampoline b
foldl' func acc start end =
    if | start > end -> T.Done acc
       | otherwise -> T.Continue(\() -> foldl' func (func start acc) (start+1) end)

{-| Reduce a range from the right: `(foldr (+) 0 (1 `to` 3) == 6)` -}
foldr : (Int -> b -> b) -> b -> IntRange -> b
foldr func acc (IntRange start end) = T.trampoline <| foldr' func acc start end

foldr' : (Int -> b -> b) -> b -> Int -> Int -> T.Trampoline b
foldr' func acc start end =
    if | start > end -> T.Done acc
       | otherwise -> T.Continue(\() -> foldr' func (func end acc) start (end-1))

{-| Apply a function to every Int numbers in a list: `(map (\it->it*2) (1 `to` 3) == [2,4,6])` -}
map : (Int -> a) -> IntRange -> List a
map func range = foldr (\it acc -> ((func it)::acc)) [] range

{-| Combine a list and an IntRange, combining them with the given function.
If one list is longer, the extra elements are dropped.

      map2 (+) [1,2,3] (1 `to` 4) == [2,4,6]
-}
map2 : (a -> Int -> c) -> List a -> IntRange -> List c
map2 func list (IntRange start end) =
    let rangeLen = end-start+1
        listLen = length list
    in reverse <| T.trampoline
               <| if | rangeLen > listLen -> map2' func list start (start+listLen-1) []
                     | rangeLen < listLen -> map2' func (take rangeLen list) start end []
                     | otherwise          -> map2' func list start end []

map2' : (a -> Int -> c) -> List a -> Int -> Int -> List c -> T.Trampoline (List c)
map2' func list start end result =
    if | start > end -> T.Done result
       | otherwise -> T.Continue(\() -> map2' func (tail list) (start+1) end ((func (head list) start)::result))

{-| Create range from two Ints. The range starts with first one and
    ends with second one. Both of values are included in the range.
    In the other word (InRange start end) include both end points.
-}
to : Int -> Int -> IntRange
to a b = IntRange a b

{-| Convert IntRange to List of Int([Int]).
-}
toList : IntRange -> List Int
toList range = map (\x -> x) range
-- for Elm 0.13:
-- toList range = map identity range
