#let pedigree(stuff, ..args) = {
  import "processing.typ": *
  import "resolve.typ": *
  import "draw.typ": draw-pedigree
  if stuff == none {
    stuff = (:)
  }

  let length = args.at("length", default: 1cm)
  let length-scale = length / 1cm // for scaling other things, like font size
  let convergence-time = args.at("convergence-time", default: 100)

  let data = (:)
  let data = process-individuals(data, stuff)
  let data = process-duplicates(data, stuff)
  let data = process-twins(data, stuff)
  let data = process-unions(data, stuff)
  let data = process-childrens(data, stuff)

  let (offsets, childrens-x-bounds) = resolve-overlaps(data, convergence-time)

  let draw-data = (
    offsets: offsets,
    childrens-x-bounds: childrens-x-bounds,
    default-generation-height: args.at("generation-height", default: 1),
    length: length,
    length-scale: length-scale,
    generation-labels: args.at("generation-labels", default: true),
    default-stroke-style: args.at("stroke-style", default: (:)),
    default-empty-style: args.at("empty-style", default: auto),
    default-fill-style: args.at("fill-style", default: auto),
    default-dead-style: args.at("dead-style", default: (:)),
    default-adopted-style: args.at("adopted-style", default: (:)),
    default-propositus-style: args.at("propositus-style", default: (:)),
    default-duplicate-curve-style: args.at("duplicate-curve-style", default: (:)),
    default-twin-style: args.at("twin-style", default: (:)),
    default-monozygotic-style: args.at("monozygotic-style", default: (:)),
    default-union-style: args.at("union-style", default: (:)),
    default-divorced-style: args.at("divorced-style", default: (:)),
    default-no-children-style: args.at("no-children-style", default: (:)),
    default-line-of-descent-style: args.at("line-of-descent-style", default: (:)),
    default-sibling-line-style: args.at("sibling-line-style", default: (:)),
    default-child-line-style: args.at("child-line-style", default: (:)),
  )
  return draw-pedigree(data, draw-data)
}

#let individual(generation, ind-number, sex, ..args) = {
  return ((
    type: "individual",
    generation: generation,
    ind-number: ind-number,
    sex: sex,
    fill: args.at(0, default: args.at("fill", default: "empty")),
    dead: args.at("dead", default: false),
    adopted: args.at("adopted", default: false),
    propositus: args.at("propositus", default: false),
    label: args.at("label", default: auto),
    in-label: args.at("in-label", default: none),
    stroke-style: args.at("stroke-style", default: (:)),
    empty-style: args.at("empty-style", default: auto),
    fill-style: args.at("fill-style", default: auto),
    dead-style: args.at("dead-style", default: (:)),
    adopted-style: args.at("adopted-style", default: (:)),
    propositus-style: args.at("propositus-style", default: (:)),
  ),)
}

#let duplicate(generation, individual, ..args) = {
  return ((
    type: "duplicate",
    generation: generation,
    individual: individual,
    bezier: args.at(0, default: args.at("bezier", default: 0.5)),
    curve-style: args.at("curve-style", default: (:)),
    lightness: args.at("lightness", default: 50%),
  ),)
}

#let twins(..args) = {
  let monozygotic = args.at("monozygotic", default: false)
  if type(monozygotic) != array {
    monozygotic = (monozygotic,)
  }

  return ((
    type: "twin",
    individuals: args.pos(),
    monozygotic: monozygotic,
    style: args.at("style", default: (:)),
    monozygotic-style: args.at("monozygotic-style", default: (:)),
  ),)
}

#let union(individual-1, individual-2, ..args) = {
  return ((
    type: "union",
    individual-1-id: individual-1,
    individual-2-id: individual-2,
    consanguineous: args.at("consanguineous", default: false),
    divorced: args.at("divorced", default: false),
    style: args.at("style", default: (:)),
    divorced-style: args.at("divorced-style", default: (:)),
  ),)
}

#let children(parents, ..args) = {
  let child-line-style = args.at("child-line-style", default: (:))
  if type(child-line-style) != array {
    child-line-style = (child-line-style,) * args.pos().len()
  }

  return ((
    type: "children",
    parents-id: parents, // union id or individual id
    children: args.pos(),
    infertile: args.at("infertile", default: false),
    no-children-style: args.at("no-children-style", default: (:)),
    line-of-descent-style: args.at("line-of-descent-style", default: (:)),
    sibling-line-style: args.at("sibling-line-style", default: (:)),
    child-line-style: child-line-style,
  ),)
}
