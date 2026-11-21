"""Blender CLI: render a rigged CC0 character (KayKit glTF) into raw pixel-art frames (A09 spike).

Technique (after Elliot Bentine "Pixelizing 3D objects" and Blender Studio "3D pixel art"):
- orthographic camera, rendered directly at the target pixel size, 1 EEVEE sample, filter 0,
  so there is no anti-aliasing to clean up;
- unlit node shading computed in the material: palette texture (closest) x a 3-band light ramp
  from a fixed key direction, plus a stepped warm rim from behind;
- a second pass writes camera-space normal (RG) and depth (B) for inner-line detection.
Post-processing (palette, outline, inner lines, sheets) is art-src/pixel_post.py.

Usage:
  blender --background --factory-startup --python art-src/render_sprites.py -- <job.json>
"""
import json
import math
import sys
from pathlib import Path

import bpy
from mathutils import Vector

ACCESSORY_PREFIXES = ("1H_", "2H_", "Badge_", "Rectangle_", "Round_", "Spike_", "Barbarian_Round",
                      "Mug", "Knife", "Throwable", "Spellbook", "Knight_Helmet", "Knight_Cape",
                      "Barbarian_Hat", "Barbarian_Cape", "Mage_Hat", "Mage_Cape", "Rogue_Cape",
                      "Rogue_Hood", "Skeleton_Warrior_Helmet", "Skeleton_Blade", "Skeleton_Shield",
                      "Skeleton_Axe", "Skeleton_Warrior_Cloak", "Skeleton_Minion_Cloak")


def clean():
    bpy.ops.wm.read_factory_settings(use_empty=True)


def import_glb(path):
    before = set(bpy.data.objects)
    bpy.ops.import_scene.gltf(filepath=str(path))
    return [o for o in bpy.data.objects if o not in before]


def toon_material(tex_path, cfg):
    m = bpy.data.materials.new("toon")
    m.use_nodes = True
    nt = m.node_tree
    nt.nodes.clear()
    n = nt.nodes.new
    out = n("ShaderNodeOutputMaterial")
    emit = n("ShaderNodeEmission")
    img = n("ShaderNodeTexImage")
    img.image = bpy.data.images.load(str(tex_path))
    img.interpolation = "Closest"
    geo = n("ShaderNodeNewGeometry")
    key = n("ShaderNodeVectorMath")
    key.operation = "DOT_PRODUCT"
    key.inputs[1].default_value = Vector(cfg["key_dir"]).normalized()
    ramp = n("ShaderNodeValToRGB")
    ramp.color_ramp.interpolation = "CONSTANT"
    els = ramp.color_ramp.elements
    bands = cfg.get("bands", [[0.0, 0.42], [0.08, 0.66], [0.5, 0.88], [0.8, 1.0]])
    els[0].position, els[0].color = bands[0][0], (bands[0][1],) * 3 + (1,)
    els[1].position, els[1].color = bands[1][0], (bands[1][1],) * 3 + (1,)
    for pos, val in bands[2:]:
        e = els.new(pos)
        e.color = (val,) * 3 + (1,)
    lit = n("ShaderNodeMix")
    lit.data_type = "RGBA"
    lit.blend_type = "MULTIPLY"
    lit.inputs[0].default_value = 1.0
    tint = n("ShaderNodeMix")
    tint.data_type = "RGBA"
    tint.blend_type = "MULTIPLY"
    tint.inputs[0].default_value = 1.0
    tint.inputs[7].default_value = tuple(cfg.get("key_color", [1.0, 0.96, 0.92])) + (1,)
    # Rim: fresnel step AND facing the rim light.
    lw = n("ShaderNodeLayerWeight")
    lw.inputs[0].default_value = 0.5
    rstep = n("ShaderNodeMath")
    rstep.operation = "GREATER_THAN"
    rstep.inputs[1].default_value = cfg.get("rim_threshold", 0.62)
    rdot = n("ShaderNodeVectorMath")
    rdot.operation = "DOT_PRODUCT"
    rdot.inputs[1].default_value = Vector(cfg["rim_dir"]).normalized()
    rface = n("ShaderNodeMath")
    rface.operation = "GREATER_THAN"
    rface.inputs[1].default_value = 0.05
    rmul = n("ShaderNodeMath")
    rmul.operation = "MULTIPLY"
    rmix = n("ShaderNodeMix")
    rmix.data_type = "RGBA"
    rmix.blend_type = "SCREEN"
    rmix.inputs[7].default_value = tuple(cfg.get("rim_color", [1.0, 0.78, 0.5])) + (1,)
    l = nt.links.new
    l(geo.outputs["Normal"], key.inputs[0])
    l(key.outputs["Value"], ramp.inputs["Fac"])
    l(img.outputs["Color"], lit.inputs[6])
    l(ramp.outputs["Color"], lit.inputs[7])
    l(lit.outputs[2], tint.inputs[6])
    l(lw.outputs["Facing"], rstep.inputs[0])
    l(geo.outputs["Normal"], rdot.inputs[0])
    l(rdot.outputs["Value"], rface.inputs[0])
    l(rstep.outputs[0], rmul.inputs[0])
    l(rface.outputs[0], rmul.inputs[1])
    l(rmul.outputs[0], rmix.inputs[0])
    l(tint.outputs[2], rmix.inputs[6])
    l(rmix.outputs[2], emit.inputs["Color"])
    l(emit.outputs["Emission"], out.inputs["Surface"])
    return m


def normal_depth_material(cam_dist):
    m = bpy.data.materials.new("nd")
    m.use_nodes = True
    nt = m.node_tree
    nt.nodes.clear()
    n = nt.nodes.new
    out = n("ShaderNodeOutputMaterial")
    emit = n("ShaderNodeEmission")
    geo = n("ShaderNodeNewGeometry")
    vt = n("ShaderNodeVectorTransform")
    vt.vector_type = "NORMAL"
    vt.convert_from = "WORLD"
    vt.convert_to = "CAMERA"
    sep = n("ShaderNodeSeparateXYZ")
    mx = n("ShaderNodeMapRange")
    mx.inputs[1].default_value, mx.inputs[2].default_value = -1.0, 1.0
    my = n("ShaderNodeMapRange")
    my.inputs[1].default_value, my.inputs[2].default_value = -1.0, 1.0
    camd = n("ShaderNodeCameraData")
    mz = n("ShaderNodeMapRange")
    mz.inputs[1].default_value, mz.inputs[2].default_value = cam_dist - 3.0, cam_dist + 3.0
    comb = n("ShaderNodeCombineXYZ")
    l = nt.links.new
    l(geo.outputs["Normal"], vt.inputs[0])
    l(vt.outputs[0], sep.inputs[0])
    l(sep.outputs[0], mx.inputs[0])
    l(sep.outputs[1], my.inputs[0])
    l(camd.outputs["View Z Depth"], mz.inputs[0])
    l(mx.outputs[0], comb.inputs[0])
    l(my.outputs[0], comb.inputs[1])
    l(mz.outputs[0], comb.inputs[2])
    l(comb.outputs[0], emit.inputs["Color"])
    l(emit.outputs["Emission"], out.inputs["Surface"])
    return m


def find_action(name):
    for a in bpy.data.actions:
        if a.name == name or a.name.endswith("|" + name) or a.name.split("|")[-1] == name:
            return a
    return None


def set_action(arm, act):
    ad = arm.animation_data or arm.animation_data_create()
    for t in ad.nla_tracks:
        t.mute = True
    ad.action = act
    if hasattr(ad, "action_slot") and len(getattr(act, "slots", [])) > 0:
        ad.action_slot = act.slots[0]


def setup_render(cfg):
    sc = bpy.context.scene
    for eng in ("BLENDER_EEVEE", "BLENDER_EEVEE_NEXT"):
        try:
            sc.render.engine = eng
            break
        except TypeError:
            continue
    sc.render.resolution_x = cfg["size"][0]
    sc.render.resolution_y = cfg["size"][1]
    sc.render.resolution_percentage = 100
    sc.render.film_transparent = True
    sc.render.filter_size = 0.0
    sc.render.image_settings.file_format = "PNG"
    sc.render.image_settings.color_mode = "RGBA"
    sc.view_settings.view_transform = "Standard"
    sc.view_settings.look = "None"
    if hasattr(sc, "eevee"):
        sc.eevee.taa_render_samples = 1
    world = bpy.data.worlds.new("w")
    world.color = (0, 0, 0)
    sc.world = world


def main():
    job = json.loads(Path(sys.argv[sys.argv.index("--") + 1]).read_text())
    clean()
    objs = import_glb(job["model"])
    arm = next(o for o in objs if o.type == "ARMATURE")
    for extra in job.get("attach", []):
        eobjs = import_glb(extra["from"])
        src = next(o for o in eobjs if o.name.split(".")[0] == extra["object"])
        mpi = src.matrix_parent_inverse.copy()
        bone = src.parent_bone
        src.parent = arm
        src.parent_type = "BONE"
        src.parent_bone = bone
        src.matrix_parent_inverse = mpi
        for o in eobjs:
            if o is not src:
                bpy.data.objects.remove(o, do_unlink=True)
        objs.append(src)
    keep = set(job.get("keep", []))
    mat = toon_material(job["texture"], job)
    for o in objs:
        if o.type != "MESH":
            continue
        base = o.name.split(".")[0]
        if base.startswith(ACCESSORY_PREFIXES) and base not in keep:
            o.hide_render = True
            continue
        o.data.materials.clear()
        o.data.materials.append(mat)
    pivot = bpy.data.objects.new("pivot", None)
    bpy.context.scene.collection.objects.link(pivot)
    for o in objs:
        if o.parent is None:
            o.parent = pivot
    pivot.scale = (job.get("scale", 1.0),) * 3
    setup_render(job)
    cam_data = bpy.data.cameras.new("cam")
    cam_data.type = "ORTHO"
    cam_data.ortho_scale = job["ortho_scale"]
    cam = bpy.data.objects.new("cam", cam_data)
    bpy.context.scene.collection.objects.link(cam)
    bpy.context.scene.camera = cam
    pitch = math.radians(job["pitch"])
    dist = 20.0
    target = Vector((0, 0, job["target_h"]))
    cam.location = target + Vector((0, -math.cos(pitch), math.sin(pitch))) * dist
    cam.rotation_euler = (math.pi * 0.5 - pitch, 0, 0)
    nd = normal_depth_material(dist)
    out = Path(job["out"]) / "raw"
    out.mkdir(parents=True, exist_ok=True)
    sc = bpy.context.scene
    for anim, spec in job["anims"].items():
        act = find_action(anim)
        if act is None:
            print("missing action", anim, [a.name for a in bpy.data.actions][:10])
            continue
        set_action(arm, act)
        f0, f1 = act.frame_range
        frames = spec["frames"]
        for d in job.get("dirs", [0]):
            pivot.rotation_euler = (0, 0, math.radians(45.0 * d))
            for i in range(frames):
                t = spec.get("times", [None] * frames)[i] if "times" in spec else (
                    f0 + (f1 - f0) * (i / max(frames, 1)) if frames > 1 else f0 + (f1 - f0) * spec.get("at", 0.0))
                sc.frame_set(int(t), subframe=t - int(t))
                stem = f"{anim}_d{d}_f{i:02d}"
                bpy.context.view_layer.material_override = None
                sc.render.filepath = str(out / f"{stem}_c.png")
                bpy.ops.render.render(write_still=True)
                bpy.context.view_layer.material_override = nd
                sc.render.filepath = str(out / f"{stem}_n.png")
                bpy.ops.render.render(write_still=True)
    print("DONE", out)


main()
