# perlin_mountains

Processing sketch that generates **layered Perlin noise landscapes** — plotter-ready line drawings of mountains, waves, smoke, hair, and more.

---

## Examples

*(add images here)*

---

## Principle

A set of horizontal lines is distributed across the canvas. Each line's vertical displacement is computed by stacking one or more **noise layers**, each contributing its own frequency, amplitude, and blending mode. Lines are drawn front-to-back with an optional **hidden-line removal** system: if a line would pass behind a previous one, it is clipped or suppressed, creating a convincing depth effect.

The result is a fully parametric generative drawing exportable as PDF, or SVG.

---

## Main Parameters

| Parameter | Role |
|-----------|------|
| `NbLines` | Number of horizontal lines |
| `XSteps` | Number of points sampled per line (horizontal resolution) |
| `Height` | Vertical spread of the lines relative to canvas width |
| `intersection` | Enable hidden-line removal (front lines occlude back lines) |
| `max_override` | Max consecutive suppressed points before a segment is cut |
| `seed` | Random seed (randomise button available) |
| `NoiseLod` | Number of Perlin octaves (harmonics) for the global noise |
| `NoiseFalloff` | Amplitude falloff between octaves (0–1) |
| `moveSpeed_X/Y` | Mouse drag sensitivity for panning noise layers |

---

## Layers

Up to N independent noise layers can be stacked. Each layer has its own parameters:

| Parameter | Role |
|-----------|------|
| `on` | Enable/disable this layer |
| `line_mode` | Noise function: `0` global Perlin, `1` local Perlin (own seed), `2` sinus, `3` gaussian |
| `layer_mode` | Blend mode: `0` max (override), `1` add, `2` multiply |
| `xPeriod` / `yPeriod` | Horizontal / vertical frequency of the noise |
| `xPeriod_Mul` / `yPeriod_Mul` | Exponent multiplier for period (×10^n) |
| `Height_Noise` | Amplitude of this layer's displacement |
| `Height_Mul` | Exponent multiplier for amplitude (×10^n, can be negative to invert) |
| `Base_Height` | Vertical offset applied to this layer |
| `pos_x` / `pos_y` | Noise origin — pan with mouse drag |
| `NoiseLod` / `NoiseFalloff` | Per-layer octave settings (for local noise mode) |

### Layer blend modes

- **Max** (`layer_mode=0`): keeps the highest displacement between this layer and the accumulated result — useful for mountain peaks.
- **Add** (`layer_mode=1`): sums this layer on top of the previous result — useful for adding fine detail.
- **Multiply** (`layer_mode=2`): modulates the existing displacement — useful for masking or envelope shaping.

---

## Hidden-Line Removal

When `intersection` is enabled, lines are processed front-to-back. At each X column, if the current line's Y position would be **behind** (below) the previous line, the point is either clamped to the previous line or suppressed. The `max_override` parameter controls how many consecutive suppressed points are tolerated before the segment is broken — higher values allow more "peaking through" behind ridges.

---

## Architecture

| File | Role |
|------|------|
| `perlin_mountains.pde` | Setup, draw loop, export |
| `Data.pde` | `PerlinMountainsData` + `DataGUI` — aggregates main, style, layers |
| `DataMain.pde` | `DataMain` + `MainGUI` — global generation parameters |
| `DataLayers.pde` | `DataLayer` + `DataLayers` + GUI — per-layer noise parameters and blend |
| `PerlinMountainGenerator.pde` | `PerlinLine` + `PerlinMountainGenerator` — line computation and hidden-line removal |
| `DrawingGenerator.pde` | Base generator class |

---

## Usage Tips

- Start with **2 layers**: one for large-scale shape (low frequency, high amplitude) and one for fine texture (high frequency, low amplitude).
- `layer_mode=0` (max) on the first layer creates clean mountain silhouettes; `layer_mode=1` (add) on subsequent layers adds surface detail.
- **Negative `Height_Mul`** inverts the displacement — useful to flip valleys into peaks.
- `intersection=true` + `max_override=3–8` gives the classic Joy Division / mountain ridge look.
- Mouse drag pans the noise in real time — find a pleasing composition, then save.
- **Smoke/hair presets**: use many lines (`NbLines` > 300), small `Height`, and a high-frequency layer with `layer_mode=1`.

---

## Changelog

### 2026-05-10
- **README**: initial documentation.
- **Fix**: corrections following xLib and Processing update (`xLib_Image.draw()` signature change).

### 2026-05-04
- File tab moved to first position.

### 2026-04-17 — xLib 2.2.11
- SVG and PDF export now use page-adapted dimensions.

### 2026-04-13 — xLib 2.2.9
- Simplified Polyline hierarchy (`SegmentedPolyline` removed).
- Clipping unified into `clipLineToCenteredRect()` across all 3 projects.

### 2026-04-13 — xLib 2.2.7
- `PerlinLine` introduced to clarify type hierarchy.
- Lazy-update mechanism via `data.any_change()`.

### 2026-04-13 — xLib 2.2.6
- Generic `Polyline` abstraction extracted into `xLib_Polyline`.

### 2026-03-27
- Updated to latest xLib; settings sorted by type.

### 2026-01-06
- **Gaussian mode** added (`line_mode=3`): gaussian bell curve displacement.
- **Joy Division** preset added.

### 2026-01-05
- **Recenter** button added.
- `layer_mode` introduced (max / add / multiply blend modes).
- `Base_Height` renamed from `Added_Height`.

### 2026-01-04
- **Local noise** mode added (`line_mode=1`): each layer has its own independent Perlin seed.
- `xPeriod` renamed from `xNoise`.

### 2025-06-16
- Mouse **drag** to pan noise layers in real time.
- Key moves renamed and stabilised.

### 2025-05-15
- Major cleanup; xLib updated.

### 2024-07-16
- Updated from `my_processing` shared library.

### 2021-02-14
- First commit (ported from older project).

