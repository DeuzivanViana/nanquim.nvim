;; extends
; Nanquim: declarations in purple (@keyword.modifier), as in VS Code (storage.type).
; Only uses words that already exist in the upstream ecma query, so it is valid for JS, JSX, TS and TSX.
(["const" "let" "var" "extends" "static" "get" "set"] @keyword.modifier
  (#set! priority 101))
