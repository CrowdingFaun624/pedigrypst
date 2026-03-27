#import "@preview/tidy:0.4.3"
#import "@preview/meander:0.4.1"
#import "../src/main.typ" as pedigrypst: pedigree
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/larrow:1.0.1": label-arrow

#show link: content => underline(content, stroke: blue)

#let CeTZ = link("https://github.com/johannes-wolf/cetz", [CeTZ])
#let cetz-link(dest, body) = link("https://cetz-package.github.io/docs/" + dest, body)
#let hbar = line(end: (100%, 0%))

#align(center, text([= Pedigrypst], size: 24pt))

#align(center, [
  A #link("https://typst.app", [Typst]) package for pedigrees, built on top of #cetz-link("", [CeTZ])

  #link("https://github.com/CrowdingFaun624/Pedigrypst", `github.com/CrowdingFaun624/Pedigrypst`)

  #strong[Version 0.1.0]
])
\ \

#pagebreak()
== Pedigree
#align(center, pedigree(length: 4cm, generation-labels: false, {
  import pedigrypst: *
  individual(1, 1, "male", label: none)
  individual(1, 2, "female", label: none)
  individual(2, 1, "unknown", fill: "unknown", label: none)
  individual(2, 2, "female", label: none)
  individual(2, 3, "female", label: none)
  individual(2, 4, "male", label: none)
  twins("i2-2", "i2-3", monozygotic: true)
  union("i1-1", "i1-2")
  union("i2-3", "i2-4")
  children("u1", "i2-1", "t1")
  children("u2", infertile: true)
}, draw: () => {
  import draw: *
  let arrow(c1, c2, control) = {
    bezier(c1, c2, control)
    let (x2, y2) = c2
    let (xc, yc) = control
    let angle = calc.atan2(x2 - xc, y2 - yc)
    mark((x2 + 0.02 * calc.cos(angle), y2 + 0.02 * calc.sin(angle)), angle, symbol: "stealth", fill: black)
  }

  content((1, 0.25), [Union Line], anchor: "south")
  arrow((1, 0.23), (1.05, 1/64), (1.125, 0.125))

  content((-0.15, 0), [Individual], anchor: "north")
  arrow((0, 0.015), (0.22, 0.1), (0.125, 0.125))

  content((1.25, -0.375), [Line of Descent], anchor: "north-west")
  arrow((1.24, -0.375), (1, -0.25), (1.125, -0.25))

  content((0.5, -0.4), [Sibling Line], anchor: "east")
  arrow((0.51, -0.4), (0.7, -0.48), (0.6, -0.4))

  content((-0.125, -0.575), [Child Line], anchor: "south-east")
  arrow((-0.125, -0.59), (-0.02, -0.7), (-0.0625, -0.675))

  content((1.85, -0.625), [Twin Line], anchor: "west")
  arrow((1.83, -0.625), (1.7, -0.75), (1.75, -0.6))

  content((1.5, -1.3), [Monozygocity Line], anchor: "north")
  arrow((1.5, -1.3), (1.5, -0.75), (1.55, -1))

  content((2.3, -1.53), [No Children Line], anchor: "east")
  arrow((2.2, -1.48), (2.4, -1.47), (2.3, -1.25))

  content((2.7, -1.55), [Infertility Line], anchor: "south-west")
  arrow((2.8, -1.54), (2.55, -1.6), (2.73, -1.74))
}))

There are five different types of objects in a pedigree in Pedigrypst.

=== Individual

An *individual* is a single square, circle, or other shape that corresponds to a single organism.

#meander.reflow({
  import meander: *

  placed(top + right, pedigree(length: 2cm, generation-labels: false, {
    import pedigrypst: *
    individual(1, 1, "female", fill: "left", label: [Duplicate])
    duplicate(1, "i1-1")
  }), boundary: contour.margin(0.5cm))
  container()
  content[
    === Duplicate

    A *duplicate* is a type of individual that mimics another individual. They act like individuals in all other ways.

    === Union

    A *union* is a relationship between two individuals. They do not necessarily have any children.
  ]
})

=== Twin

A *twin* is an object that contains multiple individuals. If this object is the child of a children object, then they will be drawn like twins.

=== Children

A *children* is an object that references a union or an individual as its parents and multiple (or zero) individuals or twin objects as its children.

#hbar
== Shapes

There are four shapes/sexes that an individual can have, which is specified using the third parameter of #raw("individual", lang: "typc").

#table(stroke: none, columns: (25%,) * 4, ..{
  import pedigrypst: individual
  let h(sex) = align(center, raw("\"" + sex + "\"", lang: "typc"))
  let a(sex) = align(center, pedigree(length: 2cm, generation-labels: false, individual(1, 1, sex, label: none)))
  let fills = ("male", "female", "unknown", "miscarriage")
  (table.header(..fills.map(h)), ..fills.map(a))
})
The #raw("\"miscarriage\"", lang: "typc") shape is offset slightly higher than the other shapes.

#pagebreak()
== Fills
There are eight preset fills available, which are specified using the #raw("fill", lang: "typc") parameter of #raw("individual", lang: "typc")

#table(stroke: none, columns: (12.5%,) * 8, ..{
  import pedigrypst: individual
  let h(fill) = align(center, raw("\"" + fill + "\"", lang: "typc"))
  let a(fill) = align(center, pedigree(length: 2cm, generation-labels: false, individual(1, 1, "male", fill: fill, label: none)))
  let fills = ("filled", "empty", "unknown", "dot", "left", "right", "up", "down")
  (table.header(..fills.map(h)), ..fills.map(a))
})

#meander.reflow({
  import meander: *
  import pedigrypst: individual

  placed(top + right, pedigree(length: 2cm, generation-labels: false, individual(1, 1, "male", fill: "I-III-IV", label: raw("\"I-III-IV\"", lang: "typc"))))

  container()
  content[
    Additionally, #link("https://en.wikipedia.org/wiki/Quadrant_(plane_geometry)", [quadrant]) notation may be used to specify the fill of each quadrant of a shape. This takes the form of a sequence of Roman numerals separated by hyphens. For example, the string #raw("\"I-III-IV\"", lang: "typc") encodes the fill of the individual shown to the right.
  ]
})

#hbar
== References

Objects in the pedigree can reference other objects using *references*.

=== Individual References

#meander.reflow({
  import meander: *

  let ind-label(generation, ind-number, size: 10.5pt) = text(raw("\"i" + str(generation) + "-" + str(ind-number) + "\"", lang: "typc"), size)
  placed(top + right, pedigree(length: 2.5cm, generation-height: 0.75, {
    import pedigrypst: *
    individual(1, 1, "male", in-label: ind-label(1, 1))
    individual(1, 2, "female", in-label: ind-label(1, 2))
    individual(1, 3, "female", in-label: ind-label(1, 3))
    individual(1, 4, "male", in-label: ind-label(1, 4))
    individual(2, 1, "female", in-label: ind-label(2, 1))
    individual(2, 17, "male", in-label: [#ind-label(2, 17, size: 9pt) <end17>])
    individual(3, 1, "male", in-label: ind-label(3, 1))
    union("i1-1", "i1-2")
    union("i1-3", "i1-4")
    union("i2-1", "i2-17")
    children("u1", "i2-1")
    children("u2", "i2-17")
    children("u3", "i3-1")
  }))

  container()
  content[
    Individual references are strings that start with a lowercase #raw("\"i\"", lang: "typc"). Next is the one-indexed generation number of the individual. Then, there is a hyphen. Finally, there is the individual number, which is the number of the individual within its own generation.\ \

    #label-arrow(<start17>, <end17>, from-offset: (6cm, 25pt), to-offset: (-4pt, -8pt), bend: -70)
    The individual number may be any number, as long as an individual has it. Notably, individual numbers may be skipped. Because individual II-17 is created using #raw("individual(2, 17, \"male\")", lang: "typc"), it can be referenced<start17> using #raw("\"i2-17\"", lang: "typc").
  ]
})

=== Other References

Other objects can be referenced using their one-indexed ID. The ID of an object is how many objects of the same type, including itself, came before it.

#tidy.show-example.show-example(```typ
<<<#pedigree({
<<<  individual(1, 1, "male") // i1-1
<<<  individual(1, 2, "female") // i1-2
<<<  individual(2, 1, "male") // i2-1
<<<  individual(2, 2, "female") // i2-2
<<<  individual(2, 3, "female") // i2-3
<<<  individual(2, 4, "male") // i2-4
<<<  duplicate(3, "i1-1") // d1
<<<  twins("i2-2", "i2-3") // t1
<<<  union("i1-1", "i1-2") // u1
<<<  union("i2-3", "i2-4") // u2
<<<  children("u1", "i2-1", "t1") // c1
<<<  children("u2", "d1") // c2
<<<})

>>>// me when I lie
>>>#let l(c) = raw("\"" + c + "\"", lang: "typc")
>>>#import pedigrypst: *
>>>#pedigree(length: 2cm, generation-height: 1.2, {
>>>  individual(1, 1, "male")
>>>  individual(1, 2, "female")
>>>  individual(2, 1, "male")
>>>  individual(2, 2, "female")
>>>  individual(2, 3, "female")
>>>  individual(2, 4, "male")
>>>  duplicate(3, "i1-1", bezier: -1.3, label: l("d1"))
>>>  twins("i2-2", "i2-3", label: l("t1"))
>>>  union("i1-1", "i1-2", label: l("u1"))
>>>  union("i2-3", "i2-4", label: l("u2"))
>>>  children("u1", "i2-1", "t1", label: l("c1"))
>>>  children("u2", "d1", label: l("c2"))
>>>})
```, scope: (pedigrypst: pedigrypst))

Duplicate are referenced with #raw("\"l\"", lang: "typc"), twins are referenced with #raw("\"t\"", lang: "typc"), unions are referenced with #raw("\"u\"", lang: "typc"), and childrens are referenced with #raw("\"c\"", lang: "typc").

#pagebreak()
== Functions
#let docs = tidy.parse-module(read("../src/main.typ"), scope: (
  meander: meander,
  pedigrypst: pedigrypst,
  CeTZ: CeTZ,
  cetz-link: cetz-link,
))

#tidy.show-module(docs)