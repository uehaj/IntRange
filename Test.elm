module Test where
import IntRange (IntRange(..),to,toList,foldl,foldr,map,map2)
import Text (leftAligned,italic,asText)
import Graphics.Element (flow,down)

main = flow down 
       [ asText << toString <| foldl (+) 0 (0 `to` 10000) == 50005000
       , asText << toString <| foldr (+) 0 (0 `to` 10000) == foldl (+) 0 (0 `to` 10000)
       , asText << toString <| foldr (-) 0 (0 `to` 3) == -2
       , asText << toString <| foldl (-) 0 (0 `to` 3) == 2
       , asText << toString <| (map (\a->a+1) (1 `to` 3)) == [2,3,4]
       , asText << toString <| (map2 (,) [1..5] (101 `to` 105)) == [(1,101),(2,102),(3,103),(4,104),(5,105)]
       , asText << toString <| (map2 (,) [1..5] (101 `to` 105)) == (map2 (,) [1..5] (101 `to` 105))
       , asText << toString <| (map2 (+) [1,2,3] (1 `to` 3)) == [2,4,6]
       , asText << toString <| (map2 (+) [1,2,3] (1 `to` 4)) == [2,4,6]
       , asText << toString <| (map2 (+) [1,2,3,4] (1 `to` 3)) == [2,4,6]
       , asText << toString <| (map2 (+) [1,2,3,4] (1 `to` 4)) == [2,4,6,8]
       , asText << toString <| (map2 (\a b->a++toString b) ["a","b","c"] (1 `to` 3)) == ["a1","b2","c3"]
       , asText << toString <| (toList (IntRange 1 3)) == [1,2,3]
       ]
