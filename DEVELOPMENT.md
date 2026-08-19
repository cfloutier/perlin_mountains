# perlin_mountains — Development

Implementation notes, algorithm details, and build procedure for `perlin_mountains`. For usage/parameters, see [README.md](README.md).

---

## Development Setup

Only needed to open/edit/run the sketch from source — not needed to just run a release build (see [README.md](README.md#getting-a-release)).

1. **Install Processing**: download from https://processing.org/download and install (Java Mode, the default one).
2. **Install ControlP5**: in the Processing IDE, go to `Sketch > Import Library... > Manage Libraries...`, search for **ControlP5**, and click Install. This puts it straight into your sketchbook's `libraries/` folder — no manual download/unzip needed. (Library home page, for reference: http://www.sojamo.de/libraries/controlP5)
3. Open `perlin_mountains.pde` in Processing and press Run.

---

## Principle

A set of horizontal lines is distributed across the canvas. Each line's vertical displacement is computed by stacking one or more **noise layers**, each contributing its own frequency, amplitude, and blending mode. Lines are drawn front-to-back with an optional **hidden-line removal** system: if a line would pass behind a previous one, it is clipped or suppressed, creating a convincing depth effect.

The result is a fully parametric generative drawing exportable SVG.

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

---

## Building a Release

`export_app.ps1` (project root) builds a standalone, installer-free application and packages it as a release zip.

```powershell
.\export_app.ps1
```

This will:
1. Export the sketch as a standalone application via `processing-java --export` (embeds a JRE and all libraries, including ControlP5 — end users install nothing).
2. Copy `Settings/` into the export (the Processing export step does **not** include it, and the sketch crashes on startup without a `Settings/default.json` to load — this project's `Settings/mountains/`, `Settings/hairs/`, and `Settings/smoke_waves/` subfolders are copied too).
3. Zip the result into `releases/perlin_mountains_<variant>_<date>.zip`, ready to hand out.

Useful options:
```powershell
.\export_app.ps1 -ProcessingPath "D:\tools\processing-4.3\processing-java.exe"  # different Processing install
.\export_app.ps1 -Zip $false                                                    # skip the release zip
```

**Note:** the build always targets the OS you run the script on — `-Variant` does not cross-compile for another platform (verified empirically: requesting `linux-amd64` from Windows still produced a Windows build). To produce a macOS or Linux build, run this script on a machine running that OS.
