Elm.Native.IntRange = {};

Elm.Native.IntRange.make = function(elm) {
    
    elm.Native = elm.Native || {};
    elm.Native.IntRange = elm.Native.IntRange || {};
    if (elm.Native.IntRange.values) return elm.Native.IntRange.values;

    var Utils = Elm.Native.Utils.make(elm);
    var List = Elm.Native.List.make(elm);

    function foldl(f, ini, range) {
        var result = ini;
        var inverse = range._2;
        if (!inverse) {
            for (var i=range._0; i<=range._1; i++) {
                result = A2(f, i, result);
            }
        }
        else {
            for (var i=range._0; i>=range._1; i--) {
                result = A2(f, i, result);
            }
        }
        return result;
    }
    function foldr(f, ini, range) {
        var result = ini;
        var inverse = range._2;
        if (!inverse) {
            for (var i=range._1; i>=range._0; i--) {
                result = A2(f, i, result);
            }
        }
        else {
            for (var i=range._1; i<=range._0; i++) {
                result = A2(f, i, result);
            }
        }
        return result;
    }
    function map(f, range) {
        var arr = [];
        var inverse = range._2;
        if (!inverse) {
            for (var i=range._0; i<=range._1; i++) {
                arr.push(f(i));
            }
        }
        else {
            for (var i=range._0; i>=range._1; i--) {
                arr.push(f(i));
            }
        }
        return List.fromArray(arr);
    }
    function map2(f, list, range) {
        var arr = [];
        var inverse = range._2;
        if (!inverse) {
            for (var i=range._0; i<=range._1; i++) {
                if (list == Utils.Nil) {
                    break;
                }
                var elem = list._0;
                arr.push(A2(f, elem, i));
                list = list._1;
            }
        }
        else {
            for (var i=range._0; i>=range._1; i--) {
                if (list == Utils.Nil) {
                    break;
                }
                var elem = list._0;
                arr.push(A2(f, elem, i));
                list = list._1;
            }
        }
        return List.fromArray(arr);
    }

    return elm.Native.IntRange.values = {
        foldl : F3(foldl),
        foldr : F3(foldr),
        map : F2(map),
        map2 : F3(map2)
    };
};
