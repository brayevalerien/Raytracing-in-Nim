import std/strformat

const imageWidth = 256
const imageHeight = 256

const filename = "output.ppm"
var file = open(filename, fmWrite)

file.writeLine(&"P3\n{imageWidth} {imageHeight}\n255")

for j in 0..<imageHeight:
    stdout.write(&"\rScanlines remaining: {imageHeight - j} ")
    for i in 0..<imageWidth:
        let r = float(i) / float(imageWidth - 1)
        let g = float(j) / float(imageHeight - 1)
        let b = 0.0

        let ir = int(255.999 * r)
        let ig = int(255.999 * g)
        let ib = int(255.999 * b)

        file.writeLine(&"{ir} {ig} {ib}")


file.close()
echo "\nDone. Image saved to ", filename
