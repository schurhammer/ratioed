# ratioed

[![Package Version](https://img.shields.io/hexpm/v/ratioed)](https://hex.pm/packages/ratioed)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/ratioed/)

A Rational Number library for the Gleam programming language.

## Quick start

The example below converts the floats 3/4 and 2/3 into rationals and multiplies them, giving a result of 1/2.

```gleam
import gleam/io
import ratioed as r

pub fn main() {
  let a = r.from_f(3.0 /. 4.0)
  let b = r.from_f(2.0 /. 3.0)
  r.mul(a, b)
  |> r.to_string
  |> io.println
  // prints 1/2
}
```

## Installation

If available on Hex this package can be added to your Gleam project:

```sh
gleam add ratioed
```

and its documentation can be found at <https://hexdocs.pm/ratioed>.
