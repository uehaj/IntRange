module Test where
import IntRange (to,downTo,toList,foldl,foldr,map,map2)
import List as L
import Text (asText)
import Graphics.Element (flow,down)

main = flow down 
       [ asText << toString <| foldl (+) 0 (0 `to` 10000) == L.foldl (+) 0 [0 .. 10000] -- 50005000
       , asText << toString <| foldl (+) 0 (10000 `downTo` 0) == L.foldl (+) 0 (L.reverse [0 .. 10000]) -- 50005000
       , asText << toString <| foldr (+) 0 (0 `to` 10000) == L.foldr (+) 0 [0 .. 10000] -- 50005000
       , asText << toString <| foldr (+) 0 (10000 `downTo` 0) == L.foldr (+) 0 (L.reverse [0 .. 10000]) -- 50005000
       , asText << toString <| foldr (-) 0 (0 `to` 3) == L.foldr (-) 0 [0 .. 3] -- -2
       , asText << toString <| foldr (-) 0 (3 `downTo` 0) == L.foldr (-) 0 (L.reverse [0 .. 3])
       , asText << toString <| foldl (-) 0 (0 `to` 3) == L.foldl (-) 0 [0 .. 3] -- 2
       , asText << toString <| foldl (-) 0 (3 `downTo` 0) == L.foldl (-) 0 (L.reverse [0 .. 3])
       , asText << toString <| map (\a->a+1) (1 `to` 3) == (L.map (\a->a+1) [1 .. 3]) -- [2,3,4]
       , asText << toString <| map (\a->a+1) (3 `downTo` 1) == (L.map (\a->a+1) [3,2,1]) -- [4,3,2]
       , asText << toString <| map (\a->a+1) (0 `to` 0) == [1]
       , asText << toString <| map (\a->a+1) (0 `to` -1) == []
       , asText << toString <| map (\a->a+1) (-1 `to` 1) == [0, 1, 2]
       , asText << toString <| map2 (,) [1..5] (101 `to` 105) == L.map2 (,) [1..5] [101 .. 105] --[(1,101),(2,102),(3,103),(4,104),(5,105)]
       , asText << toString <| map2 (,) [1..5] (105 `downTo` 101) == L.map2 (,) [1..5] (L.reverse [101 .. 105]) --[(1,105),(2,104),(3,103),(4,102),(5,101)]
       , asText << toString <| map2 (+) [1,2,3] (1 `to` 3) == (L.map2 (+) [1,2,3] [1 .. 3]) -- [2,4,6]
       , asText << toString <| map2 (+) [1,2,3] (1 `to` 4) == (L.map2 (+) [1,2,3] [1 .. 4]) -- [2,4,6]
       , asText << toString <| map2 (+) [1,2,3,4] (1 `to` 3) == (L.map2 (+) [1,2,3,4] [1 .. 3]) -- [2,4,6]
       , asText << toString <| map2 (+) [1,2,3,4] (1 `to` 4) == (L.map2 (+) [1,2,3,4] [1 .. 4]) -- [2,4,6,8]
       , asText << toString <| map2 (\a b->a++toString b) ["a","b","c"] (1 `to` 3) ==
                               L.map2 (\a b->a++toString b) ["a","b","c"] [1 .. 3] --["a1","b2","c3"]
       , asText << toString <| map2 (+) [] (0 `to` -1) == L.map2 (+) [] [] -- []
       , asText << toString <| map2 (+) [] (0 `to` 0) == L.map2 (+) [] [0] -- []
       , asText << toString <| toList (1 `to` 10) == [1 .. 10]
       , asText << toString <| toList (1 `to` 3) == [1,2,3]
       , asText << toString <| toList (1 `downTo` 3) == []
       , asText << toString <| toList (3 `downTo` 1) == [3,2,1]
       , asText << toString <| toList (3 `to` 1) == []
       ]
