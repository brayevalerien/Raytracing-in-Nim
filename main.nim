import std/strformat
import vec3
import color

const imageWidth = 256
const imageHeight = 256

const filename = "output.ppm"
var file = open(filename, fmWrite)

file.writeLine(&"P3\n{imageWidth} {imageHeight}\n255")

for j in 0..<imageHeight:
    stdout.write(&"\rScanlines remaining: {imageHeight - j} ")
    for i in 0..<imageWidth:
        let color = color(float(i) / float(imageWidth - 1), float(j) / float(imageHeight - 1), 0.0)

        file.write_color(color)


file.close()
echo "\nDone. Image saved to ", filename
