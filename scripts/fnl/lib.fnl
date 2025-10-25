(local M {})

(lambda M.contains? [tbl elem]
  (not= nil (table.index-of tbl elem)))

(lambda M.index-of [tbl elem]
  (each [idx value (pairs tbl)]
    (when (= value elem) (lua "return idx")))
  nil)

(lambda M.exec [cmd args]
  (var argstr "")
  (each [_ arg (ipairs args)]
    (set argstr (.. argstr " \"" (string.gsub arg "\"" "\\\"") "\"")))
  (local code (os.execute (.. cmd argstr))))

(lambda M.read-lines [filepath]
  (local file (io.open filepath :r))
  (if file
      (do
        (local lines [])
        (each [line (file:lines)] (table.insert lines line))
        (file:close)
        lines)
      []))

(lambda M.write-lines [filepath lines]
  (local file (io.open filepath :w))
  (file:write (table.concat lines "\n"))
  (file:close))

M
