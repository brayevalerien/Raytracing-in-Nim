import vec3
import ray
import interval

type
  HitRecord* = object
    p*: Point3
    normal*: Vec3
    t*: float
    front_face*: bool

  Hittable* = ref object of RootObj

method hit*(self: Hittable; r: Ray; ray_t: Interval; rec: var HitRecord): bool {.base.} = false

method set_face_normal*(rec: var HitRecord, r: Ray, outward_normal: Vec3) {.base.} =
    # Sets the hit record normal vector.
    # NOTE: the parameter `outward_normal` is assumed to have unit length.
    rec.front_face = r.direction.dot(outward_normal) < 0
    rec.normal = if rec.front_face: outward_normal else: -outward_normal

method `$`*(h: Hittable): string {.base.} = "Unspecified Hittable object"