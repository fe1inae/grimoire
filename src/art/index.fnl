(local lfs (require :lfs))

(fn list-files [d]
  (var files [])
  (each [f (lfs.dir d)]
    (if (not (or (= f ".") (= f "..") (= f :index.fnl)))
        (do
          (table.insert files (gopage f)))))
  (table.unpack files))

(page (title "felinae's art")
      "sometimes i like doing art things, though not very often i find them worth uploading."
      (list (list-files :src/art)))

