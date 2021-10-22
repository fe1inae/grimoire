(local lfs (require :lfs))

(fn list-files [d]
 (var files [])
 (each [f (lfs.dir d)]
  (if (not (or (= f ".") (= f "..") (= f "index.fnl")))
   (do
    (table.insert files (gopage f)))))
 (table.unpack files))

(page
 (title "felinae's schizo rants")
 "scattered thoughts or half asleep scrambling for words"
 (list
  (list-files "src/schizo")))
