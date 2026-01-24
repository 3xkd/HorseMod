"""
Used to generate screenshots of the items with transparent backgrounds
Screenshots are take using the Wiki Tools:
https://github.com/SirDoggyJvla/Wiki-Tools
"""


import os, glob
from PIL import Image

# Get the path to the screenshots folder relative to this script
script_dir = os.path.dirname(os.path.abspath(__file__))
itemType = 'reins'
screenshots_dir = os.path.join(script_dir, 'screenshots', itemType)

# Find all image files (jpg, png, etc.)
image_files = glob.glob(os.path.join(screenshots_dir, '*.png')) + \
              glob.glob(os.path.join(screenshots_dir, '*.jpg')) + \
              glob.glob(os.path.join(screenshots_dir, '*.jpeg'))

corner_top_left = (200, 200)
corner_bottom_right = (800, 800)

output_path = os.path.join(script_dir, 'output', itemType)
os.makedirs(output_path, exist_ok=True)

for img_path in image_files:
    img = Image.open(img_path).convert('RGBA')
    cropped_img = img.crop((corner_top_left[0], corner_top_left[1],
                            corner_bottom_right[0], corner_bottom_right[1]))
    # resized_img = cropped_img.resize((512, 512), Image.LANCZOS)
    resized_img = cropped_img

    # Sample green screen color from top-left pixel
    green_pixel = resized_img.getpixel((0, 0))[:3]


    # Replace green screen with transparency using color distance threshold
    datas = resized_img.getdata()
    newData = []
    def color_distance(c1, c2):
        return sum((a - b) ** 2 for a, b in zip(c1, c2)) ** 0.5

    threshold = 200  # Adjust as needed for tolerance
    for item in datas:
        if color_distance(item[:3], green_pixel) < threshold:
            newData.append((255, 255, 255, 0))  # Transparent
        else:
            newData.append(item)
    resized_img.putdata(newData)

    # Crop transparent borders
    bbox = resized_img.getbbox()
    if bbox:
        final_img = resized_img.crop(bbox)
    else:
        final_img = resized_img

    output_file_path = os.path.join(output_path, os.path.basename(img_path))
    # Ensure PNG format for RGBA images
    ext = os.path.splitext(output_file_path)[1].lower()
    if ext in ['.jpg', '.jpeg']:
        output_file_path = os.path.splitext(output_file_path)[0] + '.png'
    final_img.save(output_file_path)
