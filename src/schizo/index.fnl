(local lfs (require :lfs))

(fn list-files [d]
  (var files [])
  (each [f (lfs.dir d)]
    (if (not (or (= f ".") (= f "..") (= f :index.fnl) (= f :template.fnl)))
        (do
          (table.insert files (gopage f)))))
  (table.sort files (fn [a b]
                      (> a b)))
  (table.unpack files))

(page (title "felinae's schizo rants") "messy tech diary of varying quality"
      (list (list-files :src/schizo)))

