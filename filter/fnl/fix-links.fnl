(local utils (require :pandoc.utils))

(fn stringify [s]
  (or (and (= (type s) :string) s) (utils.stringify s)))


;; fix normal links links
(fn Link [e]
  (set e.target 
       (match FORMAT
              "html"  (e.target:gsub "%.md" ".html")
              "plain" (e.target:gsub "%.md" ".txt")
              "man"   (e.target:gsub "%.md" ".roff")
              _        e.target))
  e)

;; fix the back/up url thingy
(fn Meta [m]
  (when m.backurl
    (let [str (stringify m.backurl)]
      (set m.backurl
           (match FORMAT
                  "html"  (str:gsub "%.md" ".html")
                  "plain" (str:gsub "%.md" ".txt")
                  "man"   (str:gsub "%.md" ".roff")
                  _        str))))
  m)

[{: Link
  : Meta}]
