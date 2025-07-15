import os
from PIL import Image
import json

def generate_obj_gif(object_info, sprites_dir, output_path):
    width = object_info["width"]
    height = object_info["height"]
    anim_len = object_info["anim_len"]
    sprite_ids = object_info["sprite_ids"]

    frame_size = width * height
    sprite_img_size = 32  # assuming each sprite is 32x32 px
    out_width = width * sprite_img_size
    out_height = height * sprite_img_size

    frames = []

    for frame in range(anim_len):
        out_img = Image.new("RGBA", (out_width, out_height), (0, 0, 0, 0))
        for y in range(height):
            for x in range(width):
                adj_y = height - 1 - y
                adj_x = width - 1 - x
                idx = frame * frame_size + adj_y * width + adj_x
                sprite_id = sprite_ids[idx] if idx < len(sprite_ids) else 0
                px = x * sprite_img_size
                py = y * sprite_img_size
                if sprite_id == 0:
                    continue
                else:
                    sprite_path = os.path.join(sprites_dir, f"{sprite_id}.png")
                    if not os.path.exists(sprite_path):
                        sprite_img = Image.new("RGBA", (sprite_img_size, sprite_img_size), (0, 0, 0, 0))
                    else:
                        sprite_img = Image.open(sprite_path).convert("RGBA")
                out_img.paste(sprite_img, (px, py), sprite_img)
        frames.append(out_img)

    # Save as GIF
    frames[0].save(
        output_path,
        save_all=True,
        append_images=frames[1:],
        duration=300,  # ms per frame, adjust as needed
        loop=0,
        disposal=2,
        transparency=0
    )

if __name__ == "__main__":
    json_path = "items_8.7.json"
    sprites_dir = "./8.7/sprites/"
    output_dir = "./generated_gifs/"
    os.makedirs(output_dir, exist_ok=True)

    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    for obj in data:
        object_info = obj["object_info"]
        asset_name = obj.get("asset_name", f"item_{obj.get('item_id', 'unknown')}")
        output_path = os.path.join(output_dir, f"{asset_name}.gif")
        generate_obj_gif(object_info, sprites_dir, output_path)
        print(f"Generated: {output_path}")
