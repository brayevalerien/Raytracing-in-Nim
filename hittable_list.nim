import hittable
import ray
import interval

type
    HittableList* = ref object of Hittable
        objects*: seq[Hittable]

proc hittableList*(): HittableList =
    HittableList(objects: @[])

proc hittableList*(obj: Hittable): HittableList =
    HittableList(objects: @[obj])

proc clear*(hl: var HittableList) =
    hl.objects.setLen(0)

proc add*(hl: var HittableList, obj: Hittable) =
    hl.objects.add(obj)

proc hit*(hl: HittableList, r: Ray, ray_t: Interval, rec: var HitRecord): bool =
    var tmp_rec: HitRecord
    var hit_anything = false
    var closest_so_far = ray_t.max
    for obj in hl.objects:
        if obj.hit(r, interval(ray_t.min, closest_so_far), tmp_rec):
            hit_anything = true
            closest_so_far = tmp_rec.t
            rec = tmp_rec
    return hit_anything

when isMainModule:
    import sphere, vec3

    var hl = hittableList()
    assert hl.objects.len == 0
    let s = sphere(point3(0, 0, -1), 0.5)
    hl.add(s)
    assert hl.objects.len == 1

    hl.clear()
    assert hl.objects.len == 0

    let s1 = sphere(point3(0, 0, -1), 0.5)
    let s2 = sphere(point3(0, 1, -2), 0.5)
    hl.add(s1)
    hl.add(s2)
    assert hl.objects.len == 2

    let r = ray(point3(0, 0, 0), vec3(0, 0, -1))
    var rec: HitRecord
    # r should hit s1 at (0, 0, -.5), directly from above
    assert hl.hit(r, interval(0.001, high(float)), rec)
    assert rec.p == point3(0, 0, -0.5)
    assert rec.front_face

    echo "All unit tests passed successfully!"