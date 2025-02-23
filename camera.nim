import vec3
import color
import ray
import hittable
import hittable_list
import interval

type
    Camera* = object
        aspect_ratio*: float
        image_width*: int # in pixels
        image_height: int
        center, pixel00_loc: Point3
        pixel_delta_u, pixel_delta_v: Vec3

proc camera*(aspect_ratio: float, image_width: int): Camera =
    result.aspect_ratio = aspect_ratio
    result.image_width = image_width
    result.image_height = int(float(image_width) / aspect_ratio)
    if result.image_height < 1:
        result.image_height = 1

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

proc render*(self: Camera, world: HittableList, file: File) =
    # PPM header
    file.writeLine("P3\n" & $self.image_width & " " & $self.image_height & "\n255")

    # start rendering the image
    for j in 0..<self.image_height:
        stdout.write("\rScanlines remaining: " & $(self.image_height - j))
        for i in 0..<self.image_width:
            let pixel_center = self.pixel00_loc + i.float*self.pixel_delta_u + j.float*self.pixel_delta_v
            let ray_direction = pixel_center - self.center
            let r = ray(self.center, ray_direction)

            let pixel_color = r.ray_color(world)
            file.write_color(pixel_color)