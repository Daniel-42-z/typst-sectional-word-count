#import "@preview/wordometer:0.1.5": word-count

#let default-exclude = (
  <no-wc>,
  figure.where(kind: image),
  figure.where(kind: table),
  figure.where(kind: raw),
  bibliography,
  heading,
  math.equation,
)

#let with-sectional-word-count(body, exclude: ()) = {
  let my-word-count = word-count.with(exclude: default-exclude + exclude)
  let groups = ()
  let current-group = ()
  let current-heading = none

  if not "children" in body.fields() {
    return body
  }

  for child in body.children {
    if child.func() == heading and child.has("depth") and child.depth == 1 {
      if current-group.len() > 0 or current-heading != none {
        groups.push((heading: current-heading, body: current-group))
      }
      current-heading = child
      current-group = ()
    } else {
      current-group.push(child)
    }
  }
  if current-group.len() > 0 or current-heading != none {
    groups.push((heading: current-heading, body: current-group))
  }

  let result = {
    for group in groups {
      if group.heading != none {
        let hdg = group.heading
        my-word-count(total => {
          let count-label = [#text(
            weight: "regular",
            size: 11pt,
          )[(#total.words words)] <no-wc>]
          block(width: 100%)[
            #layout(size => {
              let gap = 0.5 * measure(text(size: 11pt)[M]).height
              let heading-width = calc.max(
                0pt,
                size.width - measure(count-label).width - gap,
              )
              let full-height = measure(width: size.width, hdg).height
              let overlay-height = measure(width: heading-width, hdg).height

              if full-height == overlay-height {
                block(width: heading-width)[#hdg]
                place(bottom + right, dy: -0.15em)[#count-label]
              } else {
                hdg
                align(right)[#count-label]
              }
            })
          ]
          group.body.join()
        })
      } else {
        group.body.join()
      }
    }
  }

  my-word-count(total => [
    #align(right)[Total word count: #total.words]<no-wc>
    #result
  ])
}
