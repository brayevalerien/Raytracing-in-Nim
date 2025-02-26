import vec3
import color
import ray
import hittable
import hittable_list
import interval
import utils

type
    Camera* = object
        aspect_ratio*: float
        image_width*: int # in pixels
        samples_per_pixel*: int
        image_height: int
        center, pixel00_loc: Point3
        pixel_delta_u, pixel_delta_v: Vec3
        pixel_samples_scale: float

proc camera*(aspect_ratio: float, image_width: int, samples_per_pixel: int): Camera =
    result.aspect_ratio = aspect_ratio
    result.image_width = image_width
    result.image_height = int(float(image_width) / aspect_ratio)
    if result.image_height < 1:
        result.image_height = 1

    result.samples_per_pixel = samples_per_pixel
    result.pixel_samples_scale = 1.0 / float(result.samples_per_pixel)

    result.center = point3(0, 0, 0)

    # viewport dimensions
    const focal_length = 1.0
    const viewport_height = 2.0
    let viewport_width = viewport_height * (image_width/result.image_height)

    # vectors across the horizontal and down the vertical viewport edges
    let viewport_u = vec3(viewport_width, 0, 0)
    let viewport_v = vec3(0, -viewport_height, 0)

    # horizontal and vertical distance between pixels
    result.pixel_delta_u = viewport_u / float(image_width)
    result.pixel_delta_v = viewport_v / float(result.image_height)

    # location of the upper left pixel
    let viewport_upper_left = result.center - vec3(0, 0, focal_length) - viewport_u/2 - viewport_v/2
    result.pixel00_loc = viewport_upper_left + 0.5*(result.pixel_delta_u+result.pixel_delta_v)

proc ray_color(r: Ray, world: HittableList): Color =
    var rec: HitRecord
    if world.hit(r, interval(0, high(float)), rec):
        return 0.5 * (rec.normal + color(1, 1, 1))
    
    # miss shader (blue to white gradient)
    let unit_direction = r.direction.unit_vector
    let a = 0.5 * (unit_direction.y + 1.0)
    return (1.0-a)*color(1.0, 1.0, 1.0) + a*color(0.5, 0.7, 1.0)

proc sample_square(): Vec3 =
    # returns a uniformly sampled vector in [-.5,.5]²x{0}
    vec3(random_float()-0.5, random_float()-0.5, 0)

proc get_ray(self: Camera, i, j: int): Ray =
    # construct a camera ray originating from the origin and directed at randomly sampled point around the pixel location i, j.
    let offset = sample_square()
    let pixel_sample = self.pixel00_loc + ((float(i)+offset.x) * self.pixel_delta_u) + ((float(j)+offset.y) * self.pixel_delta_v)
    let ray_origin = self.center
    let ray_direction = pixel_sample - ray_origin
    return ray(ray_origin, ray_direction)

proc render*(self: Camera, world: HittableList, file: File) =
    # PPM header
    file.writeLine("P3\n" & $self.image_width & " " & $self.image_height & "\n255")

    # start rendering the image
    for j in 0..<self.image_height:
        stdout.write("\rScanlines remaining: " & $(self.image_height - j))
        for i in 0..<self.image_width:
            var pixel_color = color(0, 0, 0)
            for _ in 1..self.samples_per_pixel:
                let r = self.get_ray(i, j)
                pixel_color = pixel_color + r.ray_color(world)
            file.write_color(pixel_color * self.pixel_samples_scale)