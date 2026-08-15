# Wordy

Parse and evaluate simple math word problems, returning the answer as an integer.

---

## Instructions

### Iteration 0 — Numbers
Problems with no operations simply evaluate to the number given.

> **Input:** `"What is 5?"`  
> **Output:** `5`

### Iteration 1 — Addition
Add two numbers together. Your parser should also handle large numbers and negative numbers gracefully.

> **Input:** `"What is 5 plus 13?"`  
> **Output:** `18`

### Iteration 2 — Subtraction, Multiplication, and Division
Expand the parser to perform the other three core operations.

> **Input:** `"What is 7 minus 5?"`  
> **Output:** `2`
>
> **Input:** `"What is 6 multiplied by 4?"`  
> **Output:** `24`
>
> **Input:** `"What is 25 divided by 5?"`  
> **Output:** `5`

### Iteration 3 — Multiple Operations
Handle a set of operations in sequence. Since these are verbal word problems, evaluate the expression strictly from **left-to-right**, ignoring standard mathematical order of operations.

> **Input:** `"What is 5 plus 13 plus 6?"`  
> **Output:** `24`
>
> **Input:** `"What is 3 plus 2 multiplied by 3?"`  
> **Output:** `15` *(i.e., not 9)*

### Iteration 4 — Errors
The parser should proactively identify and reject invalid inputs:

* **Unsupported operations:** (e.g., `"What is 52 cubed?"`)
* **Non-math questions:** (e.g., `"Who is the President of the United States?"`)
* **Invalid syntax:** (e.g., `"What is 1 plus plus 2?"`)

---

## Source

Inspired by one of the generated questions in the [Extreme Startup](https://github.com/rchatley/extreme_startup) game.
