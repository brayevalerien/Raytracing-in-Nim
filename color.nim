import vec3
import interval

type Color* = Vec3

proc r*(c: Color): float = c.x
proc g*(c: Color): float = c.y
proc b*(c: Color): float = c.z

proc `r=`*(c: var Color, r: float) = c.x = r
proc `g=`*(c: var Color, g: float) = c.y = g
proc `b=`*(c: var Color, b: float) = c.z = b

proc color*(r, g, b: float): Color =
    result.r = r
    result.g = g
    result.b = b

proc `$`*(c: Color): string = $c.r & " " & $c.g & " " & $c.b

proc write_color*(file: File, pixel_color: Color) =
    const intensity = interval(0.0, 0.999)
    let ir = int(255.999 * intensity.clamp(pixel_color.r))
    let ig = int(255.999 * intensity.clamp(pixel_color.g))
    let ib = int(255.999 * intensity.clamp(pixel_color.b))
    file.writeLine($ir & " " & $ig & " " & $ib)

when isMainModule:
    var c = color(0, 0.5, 1)
    assert $c == "0.0 0.5 1.0"
    c.r = 0.1
    c.g = 0.6
    c.b = 0.8
    assert c == color(0.1, 0.6, 0.8) 

    echo "All unit tests passed successfully!"