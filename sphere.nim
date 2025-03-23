import std/math
import vec3
import ray
import hittable
import interval

type
    Sphere* = ref object of Hittable
        center*: Vec3
        radius*: float

proc sphere*(center: Vec3, radius: float): Sphere =
    new(result)
    result.center = center
    result.radius = max(0.0, radius)

method hit*(s: Sphere, r: Ray, ray_t: Interval, rec: var HitRecord): bool =
    let oc = s.center - r.origin
    let a = r.direction.length_squared()
    let h = dot(r.direction, oc)
    let c = oc.length_squared() - s.radius * s.radius
    let discriminant = h * h - a * c

    if discriminant < 0.0:
        return false

    let sqrtd = sqrt(discriminant)

    # Find the nearest root that lies within the acceptable range
    var root = (h - sqrtd) / a
    if not ray_t.surrounds(root):
        root = (h + sqrtd) / a
        if not ray_t.surrounds(root):
            return false

    rec.t = root
    rec.p = r.at(rec.t)
    rec.normal = (rec.p - s.center) / s.radius

    rec.t = root
    rec.p = r.at(rec.t)
    let outward_normal = (rec.p - s.center) / s.radius
    rec.set_face_normal(r, outward_normal)

    return true

method `$`*(s: Sphere): string =
    return "Sphere(" & $s.center & ", " & $s.radius & ")"

when isMainModule:
    let center = vec3(0.0, 0.0, -1.0)
    let radius = 0.5
    let s = sphere(center, radius)
    var rec: HitRecord
    let r = ray(vec3(0.0, 0.0, 0.0), vec3(0.0, 0.0, -1.0))

    assert s.hit(r, 0.0, 1.0, rec)
    assert rec.t == 0.5
    assert rec.p == point3(0, 0, -0.5)
    assert rec.normal == vec3(0, 0, 1)

    echo "All unit tests passed successfully!"
