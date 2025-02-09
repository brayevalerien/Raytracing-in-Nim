import std/strformat
import vec3
import color
import ray

proc hit_sphere(r: Ray, center: Point3, radius: float): bool =
    let oc = center - r.origin
    let a = dot(r.direction, r.direction)
    let b = - 2 * r.direction.dot(oc)
    let c = dot(oc, oc) - radius*radius
    let discriminant = b*b - 4*a*c
    return 0 <= discriminant


proc ray_color(r: Ray): Color =
    if r.hit_sphere(point3(0, 0, -1), 0.5):
        return color(1, 0, 0)
    
    let unit_direction = r.direction.unit_vector
    let a = 0.5 * (unit_direction.y + 1.0)
    return (1.0-a)*color(1.0, 1.0, 1.0) + a*color(0.5, 0.7, 1.0)


# render resolution settings
const aspect_ratio = 16.0 / 9.0
const image_width = 400
const real_image_height = (image_width / aspect_ratio).int
const image_height = if real_image_height < 1: 1 else: real_image_height

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
        let pixel_color = r.ray_color
        file.write_color(pixel_color)

file.close()
echo "\nDone. Image saved to ", filename
