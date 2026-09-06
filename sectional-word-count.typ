#import "@preview/wordometer:0.1.5": word-count

#let my-word-count = word-count.with(exclude: (
  <no-wc>,
  figure,
  bibliography,
  heading,
  math.equation,
))

#let with-sectional-word-count(body) = {
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
          block(width: 100%)[
            #hdg
            #place(top + right, dy: 0.15em)[
              #text(weight: "regular", size: 11pt)[(#total.words words)]
            ]
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
