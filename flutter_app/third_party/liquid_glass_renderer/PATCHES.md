# Local patches to liquid_glass_renderer 0.2.0-dev.4

Vendored from https://pub.dev/packages/liquid_glass_renderer (MIT, see LICENSE).

1. `lib/assets/shaders/liquid_glass_final_render.frag` — removed the
   `IMPELLER_TARGET_OPENGLES` Y-flip on `screenUV` (backdrop sampling).
   On Flutter 3.47 with Impeller OpenGLES (e.g. OnePlus 7T, where Vulkan falls
   back to GLES) the backdrop texture is already upright, so the flip made the
   glass refract the vertically mirrored part of the screen. The geometry
   texture flip is unchanged.

Drop this vendored copy and go back to the pub.dev release once upstream
handles this.
