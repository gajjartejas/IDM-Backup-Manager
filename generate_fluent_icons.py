import os
from PIL import Image, ImageDraw

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_DIR = SCRIPT_DIR
RESOURCES_DIR = os.path.join(REPO_DIR, "Resources")
os.makedirs(RESOURCES_DIR, exist_ok=True)

# Standard Windows 11 icon sizes (includes 125%, 150%, 200% DPI steps)
SIZES = [(16, 16), (20, 20), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]

def save_ico(img_256, path):
    img_256.save(path, format='ICO', sizes=SIZES)
    print(f"Saved {os.path.basename(path)}")

def create_base(size=256):
    return Image.new("RGBA", (size, size), (0, 0, 0, 0))

# 1. Main Application Icon (Windows 11 Fluent Squircle)
def make_main_app_icon():
    img = create_base(256)
    draw = ImageDraw.Draw(img)
    # Background squircle in Fluent Cobalt Blue
    draw.rounded_rectangle([16, 16, 240, 240], radius=54, fill="#0F6CBD")
    # Inner subtle highlight plate
    draw.rounded_rectangle([28, 28, 228, 228], radius=44, fill="#1175D1")
    # Central Disk / Cloud container in Emerald & Teal
    draw.ellipse([50, 85, 206, 195], fill="#00B7C3")
    draw.ellipse([70, 60, 150, 140], fill="#00B7C3")
    draw.ellipse([125, 70, 195, 145], fill="#00B7C3")
    # Crisp white download arrow
    draw.polygon([(128, 190), (85, 135), (110, 135), (110, 85), (146, 85), (146, 135), (171, 135)], fill="#FFFFFF")
    # Synchronizing badge / circular arrows
    draw.arc([75, 75, 181, 181], start=135, end=405, fill="#107C41", width=12)
    save_ico(img, os.path.join(RESOURCES_DIR, "icon.ico"))

make_main_app_icon()

def draw_fluent(name, draw_fn):
    img = create_base(256)
    draw = ImageDraw.Draw(img)
    draw_fn(draw, img)
    save_ico(img, os.path.join(RESOURCES_DIR, f"{name}.ico"))

# 2. Backup Icon (Cloud with downward arrow) - Modern Flat Blue
def draw_backup(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#0078D4")
    # Cloud body
    draw.ellipse([55, 95, 201, 190], fill="#FFFFFF")
    draw.ellipse([80, 65, 155, 140], fill="#FFFFFF")
    draw.ellipse([130, 75, 195, 150], fill="#FFFFFF")
    # Download arrow
    draw.polygon([(128, 180), (95, 135), (115, 135), (115, 95), (141, 95), (141, 135), (161, 135)], fill="#00B7C3")
draw_fluent("Backup", draw_backup)

# 3. Restore Icon (Cloud with circular rollback arrow) - Modern Flat Green
def draw_restore(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#107C41")
    # Cloud body
    draw.ellipse([55, 95, 201, 190], fill="#FFFFFF")
    draw.ellipse([80, 65, 155, 140], fill="#FFFFFF")
    draw.ellipse([130, 75, 195, 150], fill="#FFFFFF")
    # Counter-clockwise circular arrow
    draw.arc([90, 90, 166, 166], start=45, end=330, fill="#107C41", width=16)
    draw.polygon([(145, 80), (180, 95), (150, 120)], fill="#107C41")
draw_fluent("Restore", draw_restore)

# 4. Open Folder Icon - Windows 11 Modern Yellow Folder
def draw_open(draw, img):
    # Back folder flap
    draw.rounded_rectangle([25, 55, 115, 105], radius=12, fill="#D99B00")
    draw.rounded_rectangle([25, 75, 231, 215], radius=18, fill="#FFB900")
    # Inner document preview
    draw.rounded_rectangle([55, 60, 201, 130], radius=8, fill="#F2F2F2")
    draw.line([(75, 80), (140, 80)], fill="#0078D4", width=6)
    draw.line([(75, 95), (170, 95)], fill="#505C6E", width=6)
    # Front angled flap
    draw.polygon([(20, 215), (55, 115), (245, 115), (225, 215)], fill="#FFE066")
draw_fluent("open", draw_open)

# 5. Save Icon (Floppy / Disk) - Modern Flat Blue
def draw_save(draw, img):
    draw.rounded_rectangle([25, 25, 231, 231], radius=36, fill="#0067B8")
    # Top white label
    draw.rounded_rectangle([65, 25, 191, 105], radius=8, fill="#FFFFFF")
    draw.rounded_rectangle([80, 40, 125, 90], radius=4, fill="#0067B8")
    # Metal shutter
    draw.rounded_rectangle([65, 140, 191, 231], radius=12, fill="#E1DFDD")
    draw.rounded_rectangle([90, 155, 166, 215], radius=6, fill="#323130")
draw_fluent("Save", draw_save)

# 6. Setting Icon (Modern Windows 11 Gear) - Slate Blue
def draw_setting(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#505C6E")
    # Gear outer circle
    draw.ellipse([50, 50, 206, 206], fill="#FFFFFF")
    # 8 teeth
    for angle in [0, 45, 90, 135, 180, 225, 270, 315]:
        tooth = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
        tdraw = ImageDraw.Draw(tooth)
        tdraw.rounded_rectangle([112, 28, 144, 76], radius=6, fill="#FFFFFF")
        tooth = tooth.rotate(angle, center=(128, 128))
        img.paste(tooth, (0, 0), mask=tooth)
    # Center hole
    draw.ellipse([96, 96, 160, 160], fill="#505C6E")
draw_fluent("Setting", draw_setting)

# 7. Tool Icon (Wrench & Screwdriver) - Modern Flat Orange & Slate
def draw_tool(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#D83B01")
    # Screwdriver
    draw.line([(55, 201), (170, 86)], fill="#FFFFFF", width=18)
    draw.rounded_rectangle([40, 170, 85, 215], radius=8, fill="#333333")
    # Wrench
    draw.line([(201, 201), (86, 86)], fill="#F2F2F2", width=20)
    draw.ellipse([60, 60, 110, 110], fill="#F2F2F2")
    draw.ellipse([75, 75, 95, 95], fill="#D83B01")
draw_fluent("Tool", draw_tool)

# 8. Help Icon (Question Mark) - Cobalt Blue
def draw_help(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#0078D4")
    # Inner white circle
    draw.ellipse([45, 45, 211, 211], fill="#FFFFFF")
    draw.ellipse([62, 62, 194, 194], fill="#0078D4")
    # Question mark curve & stem
    draw.arc([98, 85, 158, 145], start=180, end=0, fill="#FFFFFF", width=16)
    draw.line([(158, 115), (128, 155)], fill="#FFFFFF", width=16)
    draw.ellipse([120, 175, 136, 191], fill="#FFFFFF")
draw_fluent("Help", draw_help)

# 9. Forum / Request New Features (Two Chat Bubbles) - Modern Purple
def draw_forum(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#8764B8")
    # Main bubble (white)
    draw.rounded_rectangle([45, 55, 185, 155], radius=24, fill="#FFFFFF")
    draw.polygon([(65, 145), (45, 185), (105, 155)], fill="#FFFFFF")
    # Three speech dots
    draw.ellipse([75, 95, 90, 110], fill="#8764B8")
    draw.ellipse([108, 95, 123, 110], fill="#8764B8")
    draw.ellipse([141, 95, 156, 110], fill="#8764B8")
    # Small overlap bubble (teal)
    draw.rounded_rectangle([115, 120, 215, 195], radius=20, fill="#00B7C3")
    draw.polygon([(185, 185), (215, 215), (195, 175)], fill="#00B7C3")
draw_fluent("Forum", draw_forum)

# 10. Internet / Website (Modern Blue Globe)
def draw_internet(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#005A9E")
    # Globe sphere
    draw.ellipse([45, 45, 211, 211], fill="#0078D4")
    draw.ellipse([45, 45, 211, 211], outline="#FFFFFF", width=10)
    # Longitude ellipse
    draw.ellipse([90, 45, 166, 211], outline="#FFFFFF", width=10)
    # Latitude lines
    draw.line([(45, 128), (211, 128)], fill="#FFFFFF", width=10)
    draw.line([(55, 82), (201, 82)], fill="#FFFFFF", width=8)
    draw.line([(55, 174), (201, 174)], fill="#FFFFFF", width=8)
draw_fluent("Internet", draw_internet)

# 11. License Icon (Legal Document with Ribbon & Seal)
def draw_license(draw, img):
    draw.rounded_rectangle([45, 25, 211, 231], radius=18, fill="#FFFFFF")
    # Header bar
    draw.rounded_rectangle([45, 25, 211, 55], radius=10, fill="#0078D4")
    # Text lines
    draw.line([(70, 80), (186, 80)], fill="#505C6E", width=10)
    draw.line([(70, 105), (186, 105)], fill="#505C6E", width=8)
    draw.line([(70, 130), (186, 130)], fill="#505C6E", width=8)
    draw.line([(70, 155), (145, 155)], fill="#505C6E", width=8)
    # Golden seal
    draw.ellipse([145, 150, 195, 200], fill="#FFB900")
    draw.polygon([(155, 195), (150, 225), (170, 210), (190, 225), (185, 195)], fill="#D83B01")
draw_fluent("License", draw_license)

# 12. History Icon (Clock & Timeline)
def draw_history(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#498205")
    # Outer clock
    draw.ellipse([45, 45, 211, 211], fill="#FFFFFF")
    draw.ellipse([60, 60, 196, 196], fill="#498205")
    # Hands
    draw.line([(128, 128), (128, 80)], fill="#FFFFFF", width=12)
    draw.line([(128, 128), (165, 128)], fill="#FFFFFF", width=12)
    draw.ellipse([118, 118, 138, 138], fill="#FFFFFF")
draw_fluent("History", draw_history)

# 13. Search Icon (Magnifying Glass)
def draw_search(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#0078D4")
    draw.ellipse([55, 55, 165, 165], outline="#FFFFFF", width=18)
    draw.ellipse([65, 65, 155, 155], fill="#00B7C3")
    draw.line([(150, 150), (205, 205)], fill="#FFFFFF", width=22)
draw_fluent("search", draw_search)

# 14. FileType Icon (Document with extension tag)
def draw_filetype(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#881798")
    draw.rounded_rectangle([55, 45, 175, 215], radius=14, fill="#FFFFFF")
    draw.rounded_rectangle([75, 80, 195, 150], radius=10, fill="#00B7C3")
    draw.line([(75, 175), (145, 175)], fill="#881798", width=10)
draw_fluent("FileType", draw_filetype)

# 15. Update Icon (Cloud with Refresh / Up Arrow)
def draw_update(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#008272")
    draw.ellipse([55, 95, 201, 190], fill="#FFFFFF")
    draw.ellipse([80, 65, 155, 140], fill="#FFFFFF")
    draw.ellipse([130, 75, 195, 150], fill="#FFFFFF")
    draw.polygon([(128, 95), (95, 145), (115, 145), (115, 185), (141, 185), (141, 145), (161, 145)], fill="#008272")
draw_fluent("Update", draw_update)

# 16. Refresh Icon (Twin Circular Arrows)
def draw_refresh(draw, img):
    draw.rounded_rectangle([20, 20, 236, 236], radius=48, fill="#038387")
    draw.arc([60, 60, 196, 196], start=30, end=150, fill="#FFFFFF", width=18)
    draw.polygon([(185, 90), (195, 125), (160, 115)], fill="#FFFFFF")
    draw.arc([60, 60, 196, 196], start=210, end=330, fill="#FFFFFF", width=18)
    draw.polygon([(71, 166), (61, 131), (96, 141)], fill="#FFFFFF")
draw_fluent("refresh", draw_refresh)

# 17. Log Icon (Text Code Document)
def draw_log(draw, img):
    draw.rounded_rectangle([45, 25, 211, 231], radius=18, fill="#FFFFFF")
    draw.rounded_rectangle([60, 55, 196, 205], radius=10, fill="#1E1E1E")
    draw.line([(80, 80), (130, 80)], fill="#569CD6", width=8)
    draw.line([(80, 105), (170, 105)], fill="#4EC9B0", width=8)
    draw.line([(80, 130), (155, 130)], fill="#CE9178", width=8)
    draw.line([(80, 155), (175, 155)], fill="#DCDCAA", width=8)
    draw.line([(80, 180), (125, 180)], fill="#6A9955", width=8)
draw_fluent("Log", draw_log)

# 18. Ok.ico & ok32.ico (Green Checkmark)
def draw_ok(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#107C41")
    draw.line([(65, 130), (110, 175)], fill="#FFFFFF", width=26)
    draw.line([(100, 175), (195, 80)], fill="#FFFFFF", width=26)
draw_fluent("Ok", draw_ok)
draw_fluent("ok32", draw_ok)

# 19. Status Icons
def draw_status_info(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#0078D4")
    draw.ellipse([116, 60, 140, 84], fill="#FFFFFF")
    draw.rounded_rectangle([116, 105, 140, 195], radius=8, fill="#FFFFFF")
draw_fluent("StatusInfo", draw_status_info)

def draw_status_warning(draw, img):
    draw.polygon([(128, 20), (20, 226), (236, 226)], fill="#FFB900")
    draw.rounded_rectangle([116, 85, 140, 160], radius=8, fill="#000000")
    draw.ellipse([116, 175, 140, 199], fill="#000000")
draw_fluent("StatusWarning", draw_status_warning)

def draw_status_completed(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#107C41")
    draw.line([(65, 130), (110, 175)], fill="#FFFFFF", width=26)
    draw.line([(100, 175), (195, 80)], fill="#FFFFFF", width=26)
draw_fluent("StatusCompled", draw_status_completed)

def draw_status_error(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#D13438")
    draw.line([(70, 70), (186, 186)], fill="#FFFFFF", width=26)
    draw.line([(186, 70), (70, 186)], fill="#FFFFFF", width=26)
draw_fluent("StatusError", draw_status_error)

def draw_status_working(draw, img):
    draw.ellipse([20, 20, 236, 236], fill="#00B7C3")
    draw.arc([50, 50, 206, 206], start=45, end=300, fill="#FFFFFF", width=24)
draw_fluent("StatusWorking", draw_status_working)

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

print("All modern flat Windows 11 icons generated successfully!")
