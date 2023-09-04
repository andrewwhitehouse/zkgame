# Noirdle: An Implementation of Nerdle in Noir

## Instructions

Guess the NOIRDLE in 6 tries. After each guess, the color of the tiles will change to show how close your guess was to the solution.

Rules

 * Each guess is a calculation.

 * You can use 0 1 2 3 4 5 6 7 8 9 + - * / or =.

 * It must contain one “=”.

 * It must only have a number to the right of the “=”, not another calculation.

 * Standard order of operations applies, so calculate * and / before + and - eg. 3+2*5=13 not 25!

__Note: There is currently a [bug](https://github.com/noir-lang/noir/issues/2538) in Noir that prevents this project from working compiling. Once there is a fix this project will be updated.__

## Setup

* Install the lastest version of Noir

```bash
curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
```

```bash
noirup -n
```

* Run the test

```bash
nargo test --show-ouput
```

## Reference

- [Noir Docs](https://noir-lang.org/)
