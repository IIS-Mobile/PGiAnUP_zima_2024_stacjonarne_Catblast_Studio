shader_type canvas_item;

uniform float radius_top_left = 20.0; // Promień zaokrąglenia dla górnego-lewego rogu
uniform vec4 color : source_color;    // Kolor tła (ustawiany w Inspectorze)
uniform vec2 rect_size;               // Rozmiar ColorRect, trzeba ustawić ręcznie

void fragment() {
    // Normalizujemy współrzędne UV względem rozmiaru prostokąta
    vec2 uv = FRAGCOORD.xy / rect_size;

    // Obliczamy proporcję promienia względem wielkości ColorRect
    float border = radius_top_left / min(rect_size.x, rect_size.y);

    // Zaokrąglamy tylko górny-lewy róg
    float tl = smoothstep(0.0, border, length(uv - vec2(border, border)));

    // Ustawiamy kolor z uwzględnieniem przezroczystości dla zaokrąglonego rogu
    float alpha = 1.0 - tl;
    COLOR = vec4(color.rgb, color.a * alpha);
}
