import gleam/int
import gleam/float
import gleam/order.{type Order}

/// Default epsilon for converting floating point numbers
const epsilon = 4.440892098500626e-16

/// Ratio represents a rational number, i.e. one that can be represented as a fraction of two integers
pub opaque type Ratio {
  Ratio(n: Int, d: Int)
}

/// Create a ratio from an integer
pub fn from_i(n: Int) -> Ratio {
  Ratio(n, 1)
}

/// Create a rational given an integer numerator and denominator
pub fn from_i2(numerator n: Int, denominator d: Int) -> Ratio {
  case n, d {
    _, 0 | 0, _ -> Ratio(0, 1)
    _, _ if d < 0 -> simplify(-n, -d)
    _, _ -> simplify(n, d)
  }
}

/// Create a rational from a float with maximum error of 2^-51
pub fn from_f(f: Float) -> Ratio {
  approx_ratio(epsilon, f)
}

/// Create a rational from a float with a given maximum error
pub fn from_f_epsilon(f: Float, e: Float) -> Ratio {
  approx_ratio(e, f)
}

/// Convert a rational to an integer, truncating (round towards 0)
pub fn to_i(a: Ratio) -> Int {
  a.n / a.d
}

/// Convert a rational to a floating point number
pub fn to_f(ratio: Ratio) -> Float {
  int.to_float(ratio.n) /. int.to_float(ratio.d)
}

// Convert a rational to string
pub fn to_string(ratio: Ratio) -> String {
  int.to_string(ratio.n) <> "/" <> int.to_string(ratio.d)
}

/// Compare two rationals
pub fn compare(a: Ratio, b: Ratio) -> Order {
  int.compare(a.n * b.d, a.d * b.n)
}

/// Add two rationals
pub fn add(a: Ratio, b: Ratio) -> Ratio {
  from_i2(a.n * b.d + a.d * b.n, a.d * b.d)
}

/// Subtract one rational from another
pub fn sub(a: Ratio, b: Ratio) -> Ratio {
  from_i2(a.n * b.d - a.d * b.n, a.d * b.d)
}

/// Multiply two rationals
pub fn mul(a: Ratio, b: Ratio) -> Ratio {
  from_i2(a.n * b.n, a.d * b.d)
}

/// Divide one rational by another, division by 0 will return 0.
pub fn div(a: Ratio, b: Ratio) -> Ratio {
  from_i2(a.n * b.d, a.d * b.n)
}

fn simplify(n: Int, d: Int) -> Ratio {
  let gcd = gcd(n, d)
  Ratio(n / gcd, d / gcd)
}

fn abs(x: Int) -> Int {
  case x < 0 {
    True -> -x
    False -> x
  }
}

fn gcd(x: Int, y: Int) -> Int {
  do_gcd(abs(x), abs(y))
}

fn do_gcd(x: Int, y: Int) -> Int {
  case x == 0 {
    True -> y
    False -> {
      let assert Ok(z) = int.modulo(y, x)
      do_gcd(z, x)
    }
  }
}

fn approx_ratio(tol: Float, x: Float) -> Ratio {
  let a = float.floor(x)
  let r = x -. a
  continued_fraction(tol, 1, 0, 0, 1, x, 1.0, r, a, tol, 0.0, tol)
}

fn continued_fraction(tol, p, q, pp, qq, x, y, r, a, nt, t, tt) -> Ratio {
  case r >. nt {
    True -> {
      let np = float.truncate(a) * p + pp
      let nq = float.truncate(a) * q + qq
      let pp = p
      let p = np
      let qq = q
      let q = nq
      let x = y
      let y = r
      let r = fmod(x, y)
      let a = float.floor(x /. y)
      let tt = t
      let t = nt
      let nt = a *. t +. tt
      continued_fraction(tol, p, q, pp, qq, x, y, r, a, nt, t, tt)
    }
    False -> {
      let i = float.truncate(float.ceiling({ x -. tt } /. { y +. t }))
      from_i2(i * p + pp, i * q + qq)
    }
  }
}

@external(erlang, "math", "fmod")
@external(javascript, "./ratioed.ffi.mjs", "fmod")
fn fmod(_a: Float, _b: Float) -> Float {
  0.0
}
