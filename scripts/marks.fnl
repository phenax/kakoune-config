#!/usr/bin/env -S fennel --lua luajit

(lambda fnl-require [path]
  (local fnl (require :fennel))
  (local scriptpath (string.gsub (. arg 0) "[^/]*$" ""))
  (fnl.dofile (.. scriptpath "/" path)))

(local {: index-of : exec : read-lines : write-lines}
       (fnl-require :fnl/lib.fnl))

(local xdg_data_home
       (do
         (local path (os.getenv :XDG_DATA_HOME))
         (or path (.. (os.getenv :HOME) :/.local/share))))

(local marks_path (.. xdg_data_home :/kak/marks))

(local command {})
(local M {})

(lambda command.add [[new-mark ?posstr]]
  (local pos (and ?posstr (tonumber ?posstr)))
  (local markpaths (M.get-marks))
  (local existing-idx (index-of markpaths new-mark))
  (when (not= nil existing-idx)
    (table.remove markpaths existing-idx))
  (if (or (= pos nil) (= pos 0))
      (table.insert markpaths new-mark)
      (table.insert markpaths pos new-mark))
  (M.set-marks markpaths))

(lambda command.get [[posstr]]
  (local pos (and posstr (tonumber posstr)))
  (local markpaths (M.get-marks))
  (local existing-idx (. markpaths pos))
  (when (not= nil existing-idx) (print existing-idx)))

(lambda command.delete [[mark]]
  (local markpaths (M.get-marks))
  (local existing-idx (index-of markpaths mark))
  (when (not= nil existing-idx)
    (table.remove markpaths existing-idx))
  (M.set-marks markpaths))

(fn command.clear [] (M.set-marks []))

(fn command.show []
  (print (table.concat (M.get-marks) "\n")))

(fn command.show-path []
  (print (.. marks_path "/" (M.path-key))))

;; -----

(fn M.path-key []
  (string.gsub (os.getenv :PWD) "[^A-Za-z0-9._-]" "-"))

(fn M.get-marks [?key]
  (local path (.. marks_path "/" (or ?key (M.path-key))))
  (read-lines path))

(lambda M.set-marks [marks ?key]
  (exec :mkdir [:-p marks_path]) ; Create marks path dir if not exists
  (local path (.. marks_path "/" (or ?key (M.path-key))))
  (write-lines path marks))

(fn M.main []
  (local [cmd & cmdargs] arg)
  (if (and cmd (. command cmd))
      ((. command cmd) cmdargs)
      (error (.. "invalid command: " (or cmd "")))))

(M.main)
