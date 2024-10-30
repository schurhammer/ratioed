import gleam/order.{Eq, Gt, Lt}
import gleeunit
import gleeunit/should
import ratioed.{
  add, compare, div, from_f, from_f_epsilon, from_i, from_i2, mul, sub, to_f,
  to_i,
}

const pi = 3.14159265358979323846

pub fn main() {
  gleeunit.main()
}

pub fn compare_test() {
  // Basic case: Comparing two equal rational numbers
  compare(from_i2(3, 5), from_i2(3, 5))
  |> should.equal(Eq)

  // Case with a smaller rational number compared to a larger one
  compare(from_i2(1, 3), from_i2(1, 2))
  |> should.equal(Lt)

  // Case with a larger rational number compared to a smaller one
  compare(from_i2(4, 7), from_i2(2, 5))
  |> should.equal(Gt)

  // Case with negative rational numbers
  compare(from_i2(-2, 3), from_i2(-1, 2))
  |> should.equal(Lt)

  // Edge case: Comparing rational numbers with zero numerator
  compare(from_i2(0, 5), from_i2(0, 2))
  |> should.equal(Eq)
}

pub fn add_test() {
  // Basic addition
  add(from_i2(1, 2), from_i2(1, 3))
  |> should.equal(from_i2(5, 6))

  // Addition with negative numbers
  add(from_i2(-1, 2), from_i2(1, 3))
  |> should.equal(from_i2(-1, 6))

  // Addition with larger numerators and denominators
  add(from_i2(5, 7), from_i2(3, 13))
  |> should.equal(from_i2(86, 91))

  // Edge case: Adding zero
  add(from_i2(0, 1), from_i2(2, 3))
  |> should.equal(from_i2(2, 3))
}

pub fn sub_test() {
  // Basic subtraction
  sub(from_i2(3, 4), from_i2(1, 4))
  |> should.equal(from_i2(1, 2))

  // Subtraction with negative numbers
  sub(from_i2(-1, 2), from_i2(1, 3))
  |> should.equal(from_i2(-5, 6))

  // Subtraction with larger numerators and denominators
  sub(from_i2(5, 7), from_i2(3, 13))
  |> should.equal(from_i2(44, 91))

  // Edge case: Subtracting zero
  sub(from_i2(2, 3), from_i2(0, 1))
  |> should.equal(from_i2(2, 3))
}

pub fn mul_test() {
  // Basic multiplication
  mul(from_i2(1, 2), from_i2(1, 3))
  |> should.equal(from_i2(1, 6))

  // Multiplication with negative numbers
  mul(from_i2(-1, 2), from_i2(1, 3))
  |> should.equal(from_i2(-1, 6))

  // Multiplication with larger numerators and denominators
  mul(from_i2(5, 7), from_i2(3, 14))
  |> should.equal(from_i2(15, 98))

  // Edge case: Multiplying by zero
  mul(from_i2(0, 1), from_i2(2, 3))
  |> should.equal(from_i2(0, 1))
}

pub fn div_test() {
  // Basic division
  div(from_i2(3, 4), from_i2(1, 2))
  |> should.equal(from_i2(3, 2))

  // Division with negative numbers
  div(from_i2(-1, 2), from_i2(1, 3))
  |> should.equal(from_i2(-3, 2))

  // Division with larger numerators and denominators
  div(from_i2(5, 7), from_i2(3, 14))
  |> should.equal(from_i2(70, 21))

  // Edge case: Dividing by one
  div(from_i2(2, 3), from_i2(1, 1))
  |> should.equal(from_i2(2, 3))

  // Edge case: Division by zero (should handle this case gracefully in your library)
  div(from_i2(2, 3), from_i2(0, 1))
  |> should.equal(from_i2(0, 1))
}

pub fn from_i_test() {
  // Basic case: Creating a rational number from integers
  from_i(4)
  |> should.equal(from_i2(4, 1))
  // Edge case: Creating a rational number 0
  from_i(0)
  |> should.equal(from_i2(0, 1))
}

pub fn from_i2_test() {
  // Basic case: Creating a rational number from integers
  from_i2(3, 5)
  |> should.equal(from_i2(3, 5))

  // Case with a negative numerator and denominator
  from_i2(-2, -4)
  |> should.equal(from_i2(1, 2))

  // Case with a negative numerator
  from_i2(-3, 7)
  |> should.equal(from_i2(-3, 7))

  // Case with a negative denominator
  from_i2(5, -2)
  |> should.equal(from_i2(-5, 2))

  // Edge case: Creating a rational number with a denominator of zero (should handle this case gracefully)
  from_i2(2, 0)
  |> should.equal(from_i2(0, 1))
}

pub fn to_f_test() {
  // Basic case: Converting a positive rational number to a float
  to_f(from_i2(3, 5))
  |> should.equal(0.6)

  // Case with a negative rational number
  to_f(from_i2(-1, 2))
  |> should.equal(-0.5)

  // Case with a larger numerator and denominator
  to_f(from_i2(5, 7))
  |> should.equal(5.0 /. 7.0)

  // Edge case: Converting a rational number with zero as the numerator
  to_f(from_i2(0, 3))
  |> should.equal(0.0)
}

pub fn to_i_test() {
  // Basic case: Converting a positive rational number to an integer
  to_i(from_i2(3, 5))
  |> should.equal(0)

  // Case with a negative rational number
  to_i(from_i2(-1, 2))
  |> should.equal(0)

  // Case with a larger numerator and denominator
  to_i(from_i2(5, 7))
  |> should.equal(0)

  // Case greater than 0
  to_i(from_i2(7, 3))
  |> should.equal(2)

  // Case less than 0
  to_i(from_i2(-7, 3))
  |> should.equal(-2)

  // Edge case: Converting a rational number with zero numerator
  to_i(from_i2(0, 5))
  |> should.equal(0)
}

pub fn from_f_test() {
  // exactly one third
  from_f(1.0 /. 3.0)
  |> should.equal(from_i2(1, 3))
  from_f(7.0 /. 3.0)
  |> should.equal(from_i2(7, 3))
  from_f(0.5)
  |> should.equal(from_i2(1, 2))
  from_f(0.333)
  |> should.equal(from_i2(333, 1000))

  // negative
  from_f(-1.0 /. 3.0)
  |> should.equal(from_i2(-1, 3))
  from_f(-7.0 /. 3.0)
  |> should.equal(from_i2(-7, 3))
  from_f(-0.5)
  |> should.equal(from_i2(-1, 2))

  // zero
  from_f(0.0)
  |> should.equal(from_i2(0, 1))

  // pi
  from_f(pi)
  |> should.equal(from_i2(165_707_065, 52_746_197))
}

pub fn from_f_epsilon_test() {
  // various precisions of pi
  from_f_epsilon(pi, 1.0)
  |> should.equal(from_i2(3, 1))
  from_f_epsilon(pi, 0.1)
  |> should.equal(from_i2(16, 5))
  from_f_epsilon(pi, 0.01)
  |> should.equal(from_i2(22, 7))
  from_f_epsilon(pi, 0.001)
  |> should.equal(from_i2(201, 64))
  from_f_epsilon(pi, 0.0001)
  |> should.equal(from_i2(333, 106))
  from_f_epsilon(pi, 0.00001)
  |> should.equal(from_i2(355, 113))
  from_f_epsilon(pi, 0.000001)
  |> should.equal(from_i2(355, 113))
}
