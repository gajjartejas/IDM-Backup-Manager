import os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, "..", "..", "..", "..", "Desktop", "Autoit-Projects", "Git-Projects", "IDM-Backup-Manager"))
RESOURCES_DIR = os.path.join(REPO_DIR, "Resources")
os.makedirs(RESOURCES_DIR, exist_ok=True)

SIZES = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]

def save_ico(img_256, path):
    images = [img_256.resize(s, Image.Resampling.LANCZOS) for s in SIZES]
    images[0].save(path, format='ICO', sizes=SIZES, append_images=images[1:])
    print(f"Saved {os.path.basename(path)}")

def create_base(size=256):
    return Image.new("RGBA", (size, size), (0, 0, 0, 0))

# 1. Main Icon from AI Generated Master
master_img_path = r"C:\Users\gajja\.gemini\antigravity-ide\brain\e5e927c0-1265-4ecb-a55d-e1ccea272435\idm_backup_manager_fluent_icon_1791041454893.jpg"
if os.path.exists(master_img_path):
    img = Image.open(master_img_path).convert("RGBA")
    # Make corners round with transparent background
    w, h = img.size
    mask = Image.new("L", (w, h), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([15, 15, w - 16, h - 16], radius=int(w * 0.22), fill=255)
    
    output = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    output.paste(img, (0, 0), mask=mask)
    save_ico(output, os.path.join(RESOURCES_DIR, "icon.ico"))

# Helper for Drawing Modern WinUI 3 Fluent Vector Shapes at 256x256
def draw_fluent_icon(name, draw_fn):
    img = create_base(256)
    draw = ImageDraw.Draw(img)
    draw_fn(draw, img)
    save_ico(img, os.path.join(RESOURCES_DIR, f"{name}.ico"))

# 2. Backup Icon (Cloud with down arrow & shield)
def draw_backup(draw, img):
    # Rounded Squircle Background in Blue-Cyan gradient
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#0078D4")
    # Inner cloud
    draw.ellipse([60, 90, 196, 190], fill="#FFFFFF")
    draw.ellipse([80, 60, 160, 140], fill="#FFFFFF")
    draw.ellipse([130, 75, 205, 150], fill="#FFFFFF")
    # Down arrow in vibrant teal
    draw.polygon([(128, 185), (95, 135), (115, 135), (115, 95), (141, 95), (141, 135), (161, 135)], fill="#00B7C3")
draw_fluent_icon("Backup", draw_backup)

# 3. Restore Icon (Cloud with circular restore arrow)
def draw_restore(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#107C41")
    # Inner cloud
    draw.ellipse([60, 90, 196, 190], fill="#FFFFFF")
    draw.ellipse([80, 60, 160, 140], fill="#FFFFFF")
    draw.ellipse([130, 75, 205, 150], fill="#FFFFFF")
    # Circular counter-clockwise restore arrow
    draw.arc([88, 88, 168, 168], start=45, end=330, fill="#107C41", width=16)
    draw.polygon([(150, 80), (180, 95), (150, 120)], fill="#107C41")
draw_fluent_icon("Restore", draw_restore)

# 4. Open Folder Icon
def draw_open(draw, img):
    # Back folder tab
    draw.rounded_rectangle([25, 55, 120, 110], radius=15, fill="#D99B00")
    draw.rounded_rectangle([25, 75, 231, 215], radius=20, fill="#FFB900")
    # Front angled flap
    draw.polygon([(20, 215), (55, 115), (245, 115), (225, 215)], fill="#FFE066")
    # Soft shadow
    draw.line([(55, 115), (245, 115)], fill="#FFF399", width=4)
draw_fluent_icon("open", draw_open)

# 5. Save Icon (Floppy / Disk)
def draw_save(draw, img):
    draw.rounded_rectangle([25, 25, 231, 231], radius=40, fill="#0067B8")
    # Top white label
    draw.rounded_rectangle([60, 25, 196, 105], radius=10, fill="#F2F2F2")
    draw.rounded_rectangle([75, 40, 120, 90], radius=5, fill="#0067B8")
    # Bottom metal shutter
    draw.rounded_rectangle([60, 135, 196, 231], radius=15, fill="#CCCCCC")
    draw.rounded_rectangle([85, 150, 171, 215], radius=8, fill="#333333")
draw_fluent_icon("Save", draw_save)

# 6. Setting Icon (Modern Gear)
def draw_setting(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#505C6E")
    # Gear outer circle
    draw.ellipse([50, 50, 206, 206], fill="#FFFFFF")
    # Teeth (8 teeth)
    for angle in [0, 45, 90, 135, 180, 225, 270, 315]:
        tooth = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
        tdraw = ImageDraw.Draw(tooth)
        tdraw.rounded_rectangle([112, 30, 144, 75], radius=6, fill="#FFFFFF")
        tooth = tooth.rotate(angle, center=(128, 128))
        img.paste(tooth, (0, 0), mask=tooth)
    # Center hole
    draw.ellipse([98, 98, 158, 158], fill="#505C6E")
draw_fluent_icon("Setting", draw_setting)

# 7. Tool Icon (Wrench & Screwdriver)
def draw_tool(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#D83B01")
    # Screwdriver
    draw.line([(55, 201), (170, 86)], fill="#FFFFFF", width=18)
    draw.rounded_rectangle([40, 170, 85, 215], radius=8, fill="#333333")
    # Wrench
    draw.line([(201, 201), (86, 86)], fill="#EEEEEE", width=20)
    draw.ellipse([60, 60, 110, 110], fill="#EEEEEE")
    draw.ellipse([75, 75, 95, 95], fill="#D83B01")
draw_fluent_icon("Tool", draw_tool)

# 8. Help Icon (Question Mark)
def draw_help(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#0078D4")
    # Inner circle with ?
    draw.ellipse([45, 45, 211, 211], fill="#FFFFFF")
    draw.ellipse([65, 65, 191, 191], fill="#0078D4")
    # Question symbol
    draw.arc([98, 85, 158, 145], start=180, end=0, fill="#FFFFFF", width=16)
    draw.line([(158, 115), (128, 155)], fill="#FFFFFF", width=16)
    draw.ellipse([120, 175, 136, 191], fill="#FFFFFF")
draw_fluent_icon("Help", draw_help)

# 9. Forum / Community Icon
def draw_forum(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#8764B8")
    # Main bubble
    draw.rounded_rectangle([45, 55, 185, 155], radius=25, fill="#FFFFFF")
    draw.polygon([(65, 145), (45, 185), (105, 155)], fill="#FFFFFF")
    # Small bubble
    draw.rounded_rectangle([105, 115, 215, 195], radius=20, fill="#B146C2")
    draw.polygon([(185, 185), (215, 215), (195, 175)], fill="#B146C2")
draw_fluent_icon("Forum", draw_forum)

# 10. Internet / Web Icon
def draw_internet(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#005A9E")
    # Globe
    draw.ellipse([45, 45, 211, 211], fill="#00B7C3")
    draw.ellipse([45, 45, 211, 211], outline="#FFFFFF", width=10)
    draw.ellipse([90, 45, 166, 211], outline="#FFFFFF", width=10)
    draw.line([(45, 128), (211, 128)], fill="#FFFFFF", width=10)
    draw.line([(55, 80), (201, 80)], fill="#FFFFFF", width=8)
    draw.line([(55, 176), (201, 176)], fill="#FFFFFF", width=8)
draw_fluent_icon("Internet", draw_internet)

# 11. License Icon (Certificate / Document)
def draw_license(draw, img):
    draw.rounded_rectangle([45, 25, 211, 231], radius=20, fill="#F2F2F2")
    draw.line([(75, 65), (181, 65)], fill="#0078D4", width=12)
    draw.line([(75, 95), (181, 95)], fill="#505C6E", width=8)
    draw.line([(75, 120), (181, 120)], fill="#505C6E", width=8)
    draw.line([(75, 145), (145, 145)], fill="#505C6E", width=8)
    # Gold Seal
    draw.ellipse([145, 155, 195, 205], fill="#FFB900")
    draw.polygon([(155, 195), (150, 225), (170, 210), (190, 225), (185, 195)], fill="#D83B01")
draw_fluent_icon("License", draw_license)

# 12. History Icon (Clock)
def draw_history(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#498205")
    # Clock
    draw.ellipse([45, 45, 211, 211], fill="#FFFFFF")
    draw.ellipse([60, 60, 196, 196], fill="#498205")
    # Hands
    draw.line([(128, 128), (128, 80)], fill="#FFFFFF", width=12)
    draw.line([(128, 128), (165, 128)], fill="#FFFFFF", width=12)
    draw.ellipse([120, 120, 136, 136], fill="#FFFFFF")
draw_fluent_icon("History", draw_history)

# 13. Search Icon
def draw_search(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#0078D4")
    # Glass circle
    draw.ellipse([55, 55, 165, 165], outline="#FFFFFF", width=18)
    draw.ellipse([65, 65, 155, 155], fill="#00B7C3")
    # Handle
    draw.line([(150, 150), (205, 205)], fill="#FFFFFF", width=22)
draw_fluent_icon("search", draw_search)

# 14. FileType Icon
def draw_filetype(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#881798")
    # Document outline
    draw.rounded_rectangle([55, 45, 175, 215], radius=15, fill="#FFFFFF")
    draw.rounded_rectangle([80, 75, 195, 145], radius=12, fill="#00B7C3")
    draw.text((95, 95), "EXT", fill="#FFFFFF")
draw_fluent_icon("FileType", draw_filetype)

# 15. Update Icon
def draw_update(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#008272")
    # Cloud with upward arrow
    draw.ellipse([60, 90, 196, 190], fill="#FFFFFF")
    draw.ellipse([80, 60, 160, 140], fill="#FFFFFF")
    draw.ellipse([130, 75, 205, 150], fill="#FFFFFF")
    draw.polygon([(128, 95), (95, 145), (115, 145), (115, 185), (141, 185), (141, 145), (161, 145)], fill="#008272")
draw_fluent_icon("Update", draw_update)

# 16. Refresh Icon
def draw_refresh(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=50, fill="#038387")
    # Dual circular arrows
    draw.arc([60, 60, 196, 196], start=30, end=150, fill="#FFFFFF", width=18)
    draw.polygon([(185, 90), (195, 125), (160, 115)], fill="#FFFFFF")
    draw.arc([60, 60, 196, 196], start=210, end=330, fill="#FFFFFF", width=18)
    draw.polygon([(71, 166), (61, 131), (96, 141)], fill="#FFFFFF")
draw_fluent_icon("refresh", draw_refresh)

# 17. Log Icon
def draw_log(draw, img):
    draw.rounded_rectangle([45, 25, 211, 231], radius=20, fill="#F2F2F2")
    draw.rounded_rectangle([65, 55, 191, 205], radius=10, fill="#1E1E1E")
    # Code / text lines
    draw.line([(85, 80), (135, 80)], fill="#569CD6", width=8)
    draw.line([(85, 105), (170, 105)], fill="#4EC9B0", width=8)
    draw.line([(85, 130), (155, 130)], fill="#CE9178", width=8)
    draw.line([(85, 155), (175, 155)], fill="#DCDCAA", width=8)
    draw.line([(85, 180), (125, 180)], fill="#6A9955", width=8)
draw_fluent_icon("Log", draw_log)

# 18. Ok.ico and ok32.ico
def draw_ok(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#107C41")
    # Checkmark
    draw.line([(65, 130), (110, 175)], fill="#FFFFFF", width=28)
    draw.line([(100, 175), (195, 80)], fill="#FFFFFF", width=28)
draw_fluent_icon("Ok", draw_ok)
draw_fluent_icon("ok32", draw_ok)

# 19. Status Icons
def draw_status_info(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#0078D4")
    draw.ellipse([116, 60, 140, 84], fill="#FFFFFF")
    draw.rounded_rectangle([116, 105, 140, 195], radius=8, fill="#FFFFFF")
draw_fluent_icon("StatusInfo", draw_status_info)

def draw_status_warning(draw, img):
    draw.polygon([(128, 20), (20, 226), (236, 226)], fill="#FFB900")
    draw.rounded_rectangle([116, 85, 140, 160], radius=8, fill="#000000")
    draw.ellipse([116, 175, 140, 199], fill="#000000")
draw_fluent_icon("StatusWarning", draw_status_warning)

def draw_status_completed(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#107C41")
    draw.line([(65, 130), (110, 175)], fill="#FFFFFF", width=28)
    draw.line([(100, 175), (195, 80)], fill="#FFFFFF", width=28)
draw_fluent_icon("StatusCompled", draw_status_completed)

def draw_status_error(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#D13438")
    draw.line([(70, 70), (186, 186)], fill="#FFFFFF", width=28)
    draw.line([(186, 70), (70, 186)], fill="#FFFFFF", width=28)
draw_fluent_icon("StatusError", draw_status_error)

def draw_status_working(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#00B7C3")
    draw.arc([50, 50, 206, 206], start=45, end=300, fill="#FFFFFF", width=24)
draw_fluent_icon("StatusWorking", draw_status_working)

# 20. Modern Social Logos
def draw_social(name, bg_color, draw_symbol):
    img = Image.new("RGB", (256, 256), bg_color)
    draw = ImageDraw.Draw(img)
    draw_symbol(draw)
    img = img.resize((40, 40), Image.Resampling.LANCZOS)
    img.save(os.path.join(RESOURCES_DIR, f"{name}.jpg"), quality=95)
    print(f"Saved {name}.jpg")

draw_social("facebook", "#1877F2", lambda d: (
    d.rounded_rectangle([130, 40, 180, 230], radius=10, fill="#FFFFFF"),
    d.rounded_rectangle([80, 95, 210, 145], radius=10, fill="#FFFFFF")
))

draw_social("twitter", "#1DA1F2", lambda d: (
    d.ellipse([60, 60, 196, 196], outline="#FFFFFF", width=24),
    d.line([(80, 80), (176, 176)], fill="#FFFFFF", width=24),
    d.line([(176, 80), (80, 176)], fill="#FFFFFF", width=24)
))

print("All modern WinUI 3 Fluent icons generated successfully!")
