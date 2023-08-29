use dep::std;

global ADD: Field = 0;
global SUBTRACT: Field = 1;
global MULTIPLY: Field = 2;
global DIVIDE: Field = 3;

fn main(values: pub [Field; 4], 
        result: pub Field, 
        operators: [Field; 3],
        solution_hash: Field) {
    let hash = std::hash::pedersen([
        values[0],
        operators[0],
        values[1],
        operators[1],
        values[2],
        operators[2],
        values[3],
        result])[0];
    std::println(f"hash {hash}");
    assert(solution_hash == hash);
}

#[test]
fn test_main() {

    let result = 225;
    let values = [4, 28, 6, 33];
    let operators = [ADD, MULTIPLY, ADD];
    let solution_hash = 0x29e01d0a8d3bde33f6b26375201289e622b6db3f028bc8a8ebc5206e67061eca;
    
    main(values, result, operators, solution_hash);
}
