(local lfs (require :lfs))

(fn list-files [d]
 (var files [])
 (each [f (lfs.dir d)]
  (if (not (or (= f ".") (= f "..") (= f "index.fnl")))
   (do
    (table.insert files (gopage f)))))
 (table.unpack files))

(page
 (title "felinae's diary")
 "mainly for me to go back and read, not much deep personal feelings mostly circular computer rants"
 (list
  (list-files "src/diary")))
