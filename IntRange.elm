module IntRange(IntRange
               , to
               , foldl
               , foldr
               , map
               , zip
               , toList
               ) where
{-| The library make fold or map to the range of numbers without consuming memory.

IntRange.foldl/foldr/maps can be used instead of List of Int value
which represent certain range of Int values.

This is useful when you have to iterate many numbers without consuming
memory if the target is List.

For example,

          import IntRange (to)
          import IntRange
          Import List

          IntRange.foldl (+) 0 (0 `to` 100000000)
          List.foldl (+) 0 [0..100000000]

Both of List.foldl and IntRange.fodl don't consumes stack, but
List.foldl version consumes vast amount of memory in the contrast of
IntRange.fold requre a few memory (it takes only time).

# Create IntRange
@docs to

# Iteration
@docs foldl, foldr, map, zip

# Convert
@docs toList

-}
    
import Trampoline as T

data IntRange = IntRange Int Int

{-| Reduce a range from the left: `(foldl (::) [] (1 `to` 3) == [3,2,1])` -}
foldl : (Int -> b -> b) -> b -> IntRange -> b
foldl func acc range = T.trampoline <| foldl' func acc range

foldl' : (Int -> b -> b) -> b -> IntRange -> T.Trampoline b
foldl' func acc (IntRange start end) =
    if | start > end -> T.Done acc
       | otherwise -> T.Continue(\() -> foldl' func (func start acc) (IntRange (start+1) end))

{-| Reduce a range from the right: `(foldr (+) 0 (1 `to` 3) == 6)` -}
foldr : (Int -> b -> b) -> b -> IntRange -> b
foldr func acc range = T.trampoline <| foldr' func acc range

foldr' : (Int -> b -> b) -> b -> IntRange -> T.Trampoline b
foldr' func acc (IntRange start end) =
    if | start > end -> T.Done acc
       | otherwise -> T.Continue(\() -> foldr' func (func end acc) (IntRange start (end-1)))

{-| Apply a function to every Int numbers in a list: `(map (\it->it*2) (1 `to` 3) == [2,4,6])` -}
map : (Int -> a) -> IntRange -> [a]
map func range = foldr (\it acc -> (func it)::acc) [] range

{-| Combine one list with IntRange, combining them into tuples pairwise.
If one list or IntRange is longer, the extra elements are dropped.

      zip [1,2,3] [6,7] == [(1,6),(2,7)]
      zip == zipWith (,)
-}
zip : [b] -> IntRange -> [(Int,b)]
zip list ((IntRange start end) as range) =
    let rangeLen = end-start+1
        listLen = length list
    in fst <| if | rangeLen > listLen -> zip' list (IntRange start (start+listLen-1))
                 | rangeLen < listLen -> zip' (take rangeLen list) range
                 | otherwise -> zip' list range

zip' : [b] -> IntRange -> ([(Int,b)], [b])
zip' list range = foldr (\it (result, (hd::tl)) -> ((it,hd)::result, tl)) ([], list) range

{-| Create range from two Ints. The range starts with first one and
    end with second one. both of values are included in the range.
    In the other word (InRange start end) include both of start and end.
-}
to : Int -> Int -> IntRange
to a b = IntRange a b

{-| Convert IntRange to List of Int([Int]).
-}
toList : IntRange -> [Int]
toList range = map identity range
