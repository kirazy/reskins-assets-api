# Contributing

This document describes how icon artwork in the Artisanal Reskin asset mods is named. The rules
apply to icons and technology icons that the Assets API builds with `IconBuilderFactory`. Entity sprites
are not covered.

## File names

- File names are lowercase, with words separated by hyphens, such as `boiler-fire-mask.png`. File
  names contain no underscores or spaces.
- Every icon file is a PNG file with the extension `.png`.

## Layered icons

A layered icon has several layers, and each layer is taken from its own file. The file of a layer is
named as follows.

```
{folder}/{name}/{stem}[-{value}...][-{part}]-{role}.png
```

| Segment  | Set by                                                          | Contents                                                                                          |
| -------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `folder` | The `folder` of the factory, or `folder` on the builder         | The path of the folder of the factory, such as `__reskins-assets-base__/graphics/icons`.          |
| `name`   | `layers` or `tinted` on the factory                             | The name of the icon. The subfolder is always named for the icon.                                 |
| `stem`   | `stem` on the builder                                           | The first segment of the file name. The name of the icon is used when no stem is set.             |
| `value`  | `keyed` on the builder                                          | The value of a parameter, converted with `tostring`. One segment is added for each key, in order. |
| `part`   | `tinted` and `tinted_part` on the builder, or the `part` option | A group of layers within the icon, such as `fire`.                                                |
| `role`   | The method that adds the layer                                  | The role of the layer. The role is always the last segment.                                       |

A key adds its value only to the files of the layers given to `keyed`. When no layers are given,
the key adds its value to the file of every layer. Keys are added in the order in which they are
declared. The layers given to `keyed` are selected as follows.

| Entry                              | Selects                                        |
| ---------------------------------- | ---------------------------------------------- |
| `"mask"`                           | The layer with the role `mask` and no part.    |
| `{ part = "fire" }`                | Every layer of the part `fire`.                |
| `{ part = "fire", role = "mask" }` | The layer with the role `mask` in part `fire`. |

Every entry must select at least one layer of the icon.

### Roles

| Role         | Added by                              | Use                                                                                        |
| ------------ | ------------------------------------- | ------------------------------------------------------------------------------------------ |
| `base`       | `base`, `tinted`                      | The base layer. The layer is tinted by `base_tint` when one is given.                      |
| `mask`       | `mask`, `tinted`, `tinted_part`       | The mask layer. The layer is tinted by `tint`, or by the parameter named in `tinted_part`. |
| `highlights` | `highlights`, `tinted`, `tinted_part` | The highlights layer. The game renders the layer additively.                               |
| Other names  | `layer`, `tinted_layer`               | Any other layer, such as `traces`, `gear`, or `lights`.                                    |

### Examples

The files of each icon are in the subfolder named for the icon.

| Declaration                                                                                   | Files                                                                                                               |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `tinted("accumulator")`                                                                       | `accumulator-base.png`, `accumulator-mask.png`, `accumulator-highlights.png`                                        |
| `tinted("boiler"):tinted_part("fire", "fire_tint")`                                           | The files of `tinted("boiler")`, and `boiler-fire-mask.png` and `boiler-fire-highlights.png`                        |
| `tinted("roboport"):keyed("tier", V.one_of({ 1, 2, 3, 4 }), { "base" })`                      | `roboport-1-base.png` to `roboport-4-base.png`, `roboport-mask.png`, `roboport-highlights.png`                      |
| `tinted("nuclear-reactor"):keyed("fuel", ..., { "base" }):keyed("material", ..., { "base" })` | `nuclear-reactor-{fuel}-{material}-base.png`, such as `nuclear-reactor-uranium-gold-copper-base.png`                |
| `tinted("assembling-machine"):keyed("machine_tier", ..., { "gear" }):layer("gear")`           | The files of `tinted("assembling-machine")`, and `assembling-machine-1-gear.png` to `assembling-machine-6-gear.png` |

## Flat icons

A flat icon has one layer, taken from a single file. The file is named as follows.

```
{folder}/{stem}[-{value}...].png
```

A flat icon has no subfolder and no role. Every key adds its value to the file name.

## Technology icons

Technology icons follow the same rules. The folder of a factory for technology icons is the
`graphics/technology` folder of the asset mod, such as `__reskins-assets-base__/graphics/technology`.

## Reading a file name

Hyphens separate the segments of a file name, and also separate the words within a segment. The
segments of a file name cannot be determined from the name alone. The declaration of the icon in the
Assets API determines them.

For example, `heat-exchanger-base-base.png` is the icon `heat-exchanger` with the value `base` of the
`pipe_material` key, and the role `base`. A key value of `base` names the variant from the base mod
of Factorio.

## Keys and separate icons

Whether a variation is a key of one icon or a separate icon is decided for each icon. A separate
icon is used when the artwork is intended to differ, such as `accumulator-fast` and
`accumulator-slow`, or when a separate icon is simpler to use.
