#import "@preview/tidy:0.4.3"
#import "@preview/meander:0.4.1"
#import "../src/main.typ" as pedigrypst

#show link: content => underline(content, stroke: blue)

#let CeTZ = link("https://github.com/johannes-wolf/cetz", [CeTZ])
#let cetz-link(dest, body) = link("https://cetz-package.github.io/docs/" + dest, body)

#let docs = tidy.parse-module(read("../src/main.typ"), scope: (
  meander: meander,
  pedigrypst: pedigrypst,
  CeTZ: CeTZ,
  cetz-link: cetz-link,
))

#tidy.show-module(docs)