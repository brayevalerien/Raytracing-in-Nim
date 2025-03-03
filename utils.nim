# this file corresponds to the rtweekend.h file in the original implementation.
# A lot of the content of the original file is not included because it's not needed in Nim.

import std/random

randomize(0)

proc random_float*(): float =
    # Returns a random sample from U([0, 1[).
    result = rand(1.0)
    while result == 1.0:
        result = rand(1.0)

proc random_float*(min, max: float): float =
    # Returns a random sample from U([min, max[).
    return min + (max - min) * rand(1.0)
    while result == max:
        return min + (max - min) * rand(1.0)

when isMainModule:
    var average: float
    const sample_count = 1000

    for _ in 1..sample_count:
        average += random_float()
    
    echo "Drawn " & $sample_count & " random samples from U([0, 1[), average was: " & $(average/sample_count)
