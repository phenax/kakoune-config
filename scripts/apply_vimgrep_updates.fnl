#!/usr/bin/env -S fennel --lua luajit

(local M {})

(fn M.main []
  (local write-count (M.apply-vimgrep-changes))
  (print (.. "Applied " write-count " changes")))

(fn M.apply-vimgrep-changes []
  (var count 0)
  (each [line (io.lines)]
    (local (filepath linenr _ text) (M.parse-vimgrep line))
    (when filepath
      (local applied? (M.update-line filepath linenr text))
      (when applied?
        (set count (+ count 1)))))
  count)

(fn M.parse-vimgrep [line]
  (local (filepath linenr col text) (string.match line "(.*):(%d+):(%d+):(.*)"))
  (values filepath (tonumber linenr) col text))

(fn M.update-line [filepath linenr text]
  (local lines (M.read-lines filepath))
  (var written? false)
  (when (and (> (length lines) linenr) (not= (. lines linenr) text))
    (set (. lines linenr) text)
    (local file (io.open filepath :w))
    (file:write (table.concat lines "\n"))
    (file:close)
    (set written? true))
  written?)

(fn M.read-lines [filepath]
  (local file (io.open filepath :r))
  (local lines [])
  (each [line (file:lines)] (table.insert lines line))
  (file:close)
  lines)

(M.main)
