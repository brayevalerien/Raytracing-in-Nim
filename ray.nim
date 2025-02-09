import vec3

type
    Ray* = object
        origin*: Point3
        direction*: Vec3

proc ray*(origin: Point3, direction: Vec3): Ray =
    result.origin = origin
    result.direction = direction

proc at*(r: Ray, t: float): Point3 =
    r.origin + t * r.direction

proc `$`*(r: Ray): string =
    return "(" & $r.origin & ", " & $r.direction & ")"

when isMainModule:
  let origin = point3(1.0, 2.0, 3.0)
  let direction = vec3(4.0, 5.0, 6.0)
  let r = ray(origin, direction)
  assert r.origin == origin
  assert r.direction == direction

  let actualPoint = r.at(2)
  assert actualPoint == point3(9.0, 12.0, 15.0)

  echo "All unit tests passed successfully!"