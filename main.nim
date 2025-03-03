import std/[strformat, math]
import vec3
import color
import ray
import sphere
import hittable
import hittable_list
import interval
import camera


var world = hittableList()
world.add(sphere(point3(0, 0, -1), 0.5))
world.add(sphere(point3(0, -100.5, -1), 100))

# camera settings
var cam = camera(16/9, 400, 500, 50)

const filename = "output.ppm"
var file = open(filename, fmWrite)

cam.render(world, file)

file.close()
echo "\nDone. Image saved to ", filename
