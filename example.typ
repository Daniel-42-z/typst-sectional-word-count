#import "sectional-word-count.typ": with-sectional-word-count

#title[Title]

= Section 0

Words not counted before the show rule applies

#show: with-sectional-word-count.with(exclude: (emph,))

= Section 1

Word word word #emph[not counted]

= Section 2

Word word word word word
