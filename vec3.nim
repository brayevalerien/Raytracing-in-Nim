import std/math
import utils

type
    Vec3* = object
        x*: float
        y*: float
        z*: float

proc vec3*(x, y, z: float): Vec3 =
    result.x = x
    result.y = y
    result.z = z

proc `-`*(v: Vec3): Vec3 = vec3(-v.x, -v.y, -v.z)

proc `+=`*(u: var Vec3, v: Vec3) =
    u.x += v.x
    u.y += v.y
    u.z += v.z
proc `-=`*(u: var Vec3, v: Vec3) = u += -v
proc `*=`*(v: var Vec3, t: float) =
    v.x *= t
    v.y *= t
    v.z *= t
proc `/=`*(v: var Vec3, t: float) = v *= 1/t

proc length_squared*(v: Vec3): float = v.x*v.x + v.y*v.y + v.z*v.z
proc length*(v: Vec3): float = v.lengthSquared.sqrt

type Point3* = Vec3
proc point3*(x, y, z: float): Point3 = vec3(x, y, z)

proc `$`*(v: Vec3): string =
    "(" & $v.x & ", " & $v.y & ", " & $v.z & ")"

proc `+`*(u, v: Vec3): Vec3 = vec3(u.x+v.x, u.y+v.y, u.z+v.z)
proc `-`*(u, v: Vec3): Vec3 = vec3(u.x-v.x, u.y-v.y, u.z-v.z)

# v * u does element-wise multiplication
proc `*`*(u, v: Vec3): Vec3 = vec3(u.x*v.x, u.y*v.y, u.z*v.z)

proc `*`*(v: Vec3, t: float): Vec3 = vec3(v.x*t, v.y*t, v.z*t)
proc `*`*(t: float, v: Vec3): Vec3 = v * t

proc `/`*(v: Vec3, t: float): Vec3 = v * (1/t)

proc dot*(u, v: Vec3): float = u.x*v.x + u.y*v.y + u.z*v.z
proc cross*(u, v: Vec3): Vec3 {.inline.} =
    result.x = u.y * v.z - u.z * v.y
    result.y = u.z * v.x - u.x * v.z
    result.z = u.x * v.y - u.y * v.x
proc unit_vector*(v: Vec3): Vec3 = v / v.length()

proc random_vec3*(): Vec3 {.inline.} = vec3(random_float(), random_float(), random_float())

proc random_vec3*(min, max: float): Vec3  {.inline.} =
    vec3(random_float(min, max), random_float(min, max), random_float(min, max))

proc random_unit*(): Vec3 {.inline.} =
    var
        p: Vec3
        lensq: float
    while true:
        p = random_vec3(-1, 1)
        lensq = p.length_squared
        if MinFloatNormal < lensq and lensq <= 1:
            return p / sqrt(lensq)

proc random_on_hemisphere*(normal: Vec3): Vec3 {.inline.} =
    var on_unit_sphere = random_unit()
    if 0 < dot(on_unit_sphere, normal):
        return on_unit_sphere
    return -on_unit_sphere

when isMainModule:
    const v = vec3(0, 1, 2)
    assert v.x == 0
    assert v.y == 1
    assert v.z == 2
    assert $v == "(0.0, 1.0, 2.0)"
    assert -v == vec3(-0, -1, -2)
    assert v.lengthSquared == 5.0    
    assert v.length == sqrt(5.0)    

    const u = vec3(0.5, 1.5, 2.5)
    var w = v
    w += u
    assert w == vec3(0.5, 2.5, 4.5)
    w -= u
    assert w == v
    w *= 2
    assert w == vec3(0, 2, 4)
    w /= 2
    assert w == vec3(0, 1, 2)

    assert v+u == vec3(0.5, 2.5, 4.5)
    assert u-v == vec3(0.5, 0.5, 0.5)
    assert v*vec3(1, 3, 5) == vec3(0, 3, 10)
    assert 1.5*v == vec3(0, 1.5, 3)
    assert v*1.5 == vec3(0, 1.5, 3)
    assert v/2 == vec3(0, 0.5, 1)

    assert v.dot(u) == 6.5
    assert u.dot(v) == v.dot(u)
    assert u.cross(v) == -v.cross(u)

    assert v.unit_vector.length.almostEqual(1)

    echo "All unit tests passed successfully!"
