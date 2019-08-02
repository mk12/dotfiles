{:user
 {:plugins [[io.aviso/pretty "0.1.37"]
            [jonase/eastwood "0.3.5"]
            [lein-kibit "0.1.7"]]
  :dependencies [[im.chit/vinyasa.inject "0.4.7"]
                 [io.aviso/pretty "0.1.37"]
                 [philoskim/debux "0.5.6"]
                 [pjstadig/humane-test-output "0.9.0"]]
  :injections [(require 'vinyasa.inject 'debux.core)
               (vinyasa.inject/inject '[clojure.core [debux.core dbg dbgn]])
               (require 'pjstadig.humane-test-output)
               (pjstadig.humane-test-output/activate!)]
  :middleware [io.aviso.lein-pretty/inject]}}
