module Test where
import IntRange (..)
import List
{-
tests = [ (zipWith (,) [1..10] (100 `to` 110)) == (List.zipWith (,) [1..10] [100..110])
        , (zip [1..10] (100 `to` 110)) == (List.zip [1..10] [100..110])
        , (foldl (+) 0 (1 `to` 10)) == (List.foldl (+) 0 [1..10])
        ]-}

main = flow down 
       [ plainText . show <| foldl (+) 0 (0 `to` 10000) == 50005000
       , plainText . show <| foldr (+) 0 (0 `to` 10000) == foldl (+) 0 (0 `to` 10000)
       , plainText . show <| foldr (-) 0 (0 `to` 3) == -2
       , plainText . show <| foldl (-) 0 (0 `to` 3) == 2
       , plainText . show <| (map (\a->a+1) (1 `to` 3)) == [2,3,4]
       , plainText . show <| (zip [1..5] (101 `to` 105)) == [(1,101),(2,102),(3,103),(4,104),(5,105)]
       , plainText . show <| (zip [1..5] (101 `to` 105)) == (zipWith ((,)) [1..5] (101 `to` 105))
       , plainText . show <| (zipWith (+) [1,2,3] (1 `to` 3)) == [2,4,6]
       , plainText . show <| (zipWith (+) [1,2,3] (1 `to` 4)) == [2,4,6]
       , plainText . show <| (zipWith (+) [1,2,3,4] (1 `to` 3)) == [2,4,6]
       , plainText . show <| (zipWith (+) [1,2,3,4] (1 `to` 4)) == [2,4,6,8]
       , plainText . show <| (zipWith (\a b->a++show b) ["a","b","c"] (1 `to` 3)) == ["a1","b2","c3"]
       , plainText . show <| (toList (IntRange 1 3)) == [1,2,3]
       ]
