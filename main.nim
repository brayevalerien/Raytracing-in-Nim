import std/[strformat, math]
import vec3
import color
import ray
import sphere
import hittable
import hittable_list
import interval

proc ray_color(r: Ray, world: HittableList): Color =
    var rec: HitRecord
    if world.hit(r, interval(0, high(float)), rec):
        return 0.5 * (rec.normal + color(1, 1, 1))
    
    # miss shader (blue to white gradient)
    let unit_direction = r.direction.unit_vector
    let a = 0.5 * (unit_direction.y + 1.0)
    return (1.0-a)*color(1.0, 1.0, 1.0) + a*color(0.5, 0.7, 1.0)


# render resolution settings
const aspect_ratio = 16.0 / 9.0
const image_width = 400
const real_image_height = (image_width / aspect_ratio).int
const image_height = if real_image_height < 1: 1 else: real_image_height

# world settings
var world = hittableList()
world.add(sphere(point3(0, 0, -1), 0.5))
world.add(sphere(point3(0, -100.5, -1), 100))

# camera settings
const focal_length = 1.0
const viewport_height = 2.0
const viewport_width = viewport_height * (image_width / image_height)
const camera_center = point3(0, 0, 0)
const viewport_u = vec3(viewport_width, 0, 0)
const viewport_v = vec3(0, -viewport_height, 0)

# compute pixel values
const pixel_delta_u = viewport_u / image_width
const pixel_delta_v = viewport_v / image_height
const viewport_upper_left = camera_center - vec3(0, 0, focal_length) - viewport_u/2 - viewport_v/2
const first_pixel_center = viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v)

# write file header
const filename = "output.ppm"
var file = open(filename, fmWrite)
file.writeLine(&"P3\n{image_width} {image_height}\n255")

# start rendering the image
for j in 0..<image_height:
    stdout.write(&"\rScanlines remaining: {image_height - j} ")
    for i in 0..<image_width:
        let pixel_center = first_pixel_center + i.float*pixel_delta_u + j.float*pixel_delta_v
        let ray_direction = pixel_center - camera_center

        let r = ray(camera_center, ray_direction)
        let pixel_color = r.ray_color(world)
        file.write_color(pixel_color)

file.close()
echo "\nDone. Image saved to ", filename
