module IntRange(IntRange
               , to
               , foldl
               , foldr
               , map
               , zip
               , zipWith
               , toList
               ) where
{-| The library provides fold/map/zip to the range of numbers without consuming memory.

IntRange.foldl/foldr/maps can be used replacement of [Int] value
which represents certain range of Int values.

This is useful when iterate vast numbers without consuming memory.

For example,

          import IntRange (to)
          import IntRange
          Import List

          IntRange.foldl (+) 0 (0 `to` 100000000) -- Can be calculate without consuming memory.
          List.foldl (+) 0 [0..100000000] -- Require memory fo the list which length is 100000000.

Both of List.foldl and IntRange.foldl don't consumes call stack, but
List.foldl version consumes vast amount of memory in the contrast of
IntRange.fold requres relatively small constant memory.

# Create IntRange
@docs to

# Iteration
@docs foldl, foldr, map, zip, zipWith

# Convert
@docs toList

-}
    
import Trampoline as T

data IntRange = IntRange Int Int

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
map : (Int -> a) -> IntRange -> [a]
map func range = foldr (\it acc -> (func it)::acc) [] range

{-| Combine a list and an IntRange, combining them into tuples pairwise.
If one list or IntRange is longer, the extra elements are dropped.

      zip [1,2,3] (6 `to` 7) == [(1,6),(2,7)]
      zip == zipWith (,)
-}
zip : [a] -> IntRange -> [(a,Int)]
zip list range = zipWith (,) list range

{-| Combine a list and an IntRange, combining them with the given function.
If one list is longer, the extra elements are dropped.

  zipWith (+) [1,2,3] (1 `to` 4) == [2,4,6]
-}
zipWith : (a -> Int -> c) -> [a] -> IntRange -> [c]
zipWith func list (IntRange start end) =
    let rangeLen = end-start+1
        listLen = length list
    in reverse <| if | rangeLen > listLen -> zipWith' func list start (start+listLen-1) []
                     | rangeLen < listLen -> zipWith' func (take rangeLen list) start end []
                     | otherwise -> zipWith' func list start end []

zipWith' : (a -> Int -> c) -> [a] -> Int -> Int -> [c] -> [c]
zipWith' func list start end result =
    if | start > end -> result
       | otherwise -> zipWith' func (tail list) (start+1) end ((func (head list) start)::result)

{-| Create range from two Ints. The range starts with first one and
    end with second one. both of values are included in the range.
    In the other word (InRange start end) include both of start and end.
-}
to : Int -> Int -> IntRange
to a b = IntRange a b

{-| Convert IntRange to List of Int([Int]).
-}
toList : IntRange -> [Int]
toList range = map (\x -> x) range
-- for Elm 0.13:
-- toList range = map identity range

