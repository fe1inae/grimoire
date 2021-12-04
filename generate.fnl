#!/usr/bin/env fennel

;; DSL TABLE
;; ---------

(local dsl {:html _G})

;; UTILS
;; -----
(local lfs (require :lfs))
(local fennel (require :fennel))

(fn is-dir [d]
  (let [attr (lfs.attributes d)]
    (= attr.mode :directory)))

(fn recurse-directory [d]
  (var files [])
  (each [f (lfs.dir d)]
    (if (not (or (= f ".") (= f "..")))
        (let [f (.. d "/" f)]
          (if (is-dir f)
              (each [_ i (pairs (recurse-directory f))]
                (table.insert files i))
              (table.insert files f)))))
  files)

(fn create-dir [d]
  (var path ".")
  (each [i (d:gmatch "([^/]+)")]
    (set path (.. path "/" i))
    (lfs.mkdir path)))

;; DSL FUNCS
;; ---------

(fn dsl.html.page [...]
  (table.concat [...] ""))

(fn dsl.html.paragraph [...]
  (string.format "<p>%s</p>" (table.concat [...] " ")))

(fn dsl.html.nl []
  :<br><br>)

(fn dsl.html.title [str]
  (string.format "<h1>%s</h1><hr>"
                 str))

(fn dsl.html.link [str]
  (string.format "[<a href=\"%s\">link</a>] %s" str str))

(fn dsl.html.gopage [str]
  (let [str (str:gsub "%.fnl$" :.html)]
    (string.format "[<a href=\"%s\">page</a>] %s" str str)))

(fn dsl.html.file [str]
  (string.format "[<a href=\"%s\">file</a>] %s" str str))

(fn dsl.html.list [...]
  (var str :<ul>)
  (each [_ i (pairs [...])]
    (set str (.. str (string.format "<li>%s</li>" i))))
  (set str (.. str :</ul>))
  str)

(fn dsl.html.numlist [...]
  (var str :<ol>)
  (each [_ i (pairs [...])]
    (set str (.. str (string.format "<li>%s</li>" i))))
  (set str (.. str :</ol>))
  str)

(fn dsl.html.bold [...]
  (string.format "<b>%s</b>" ...))

;; RUN FILES
;; ---------
(each [_ i (pairs (recurse-directory :src))]
  (if (i:match "%.fnl$")
      (do
        ;; TODO: each for gopher text etc
        (local contents (fennel.dofile i [:env dsl.html]))
        (local template (io.open :template/template.html :r))
        (local page (string.gsub (template:read :a) "{CONTENTS}" contents))
        (local out (string.gsub (i:gsub :^src :out/html) "%.fnl$" :.html))
        (create-dir (out:gsub "[^/]+$" ""))
        (let [outfile (io.open out :w)]
          (outfile:write page)))))

