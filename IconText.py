import os
from PIL import Image, ImageDraw, ImageFont

sourcedir = 'C:\\Users\\dan\\Games\\Factorio\\Factorio Latest\\data\\base\\graphics\\item-group\\'
finaldir = 'src\\graphics\\item-group\\'

for filename in os.listdir(sourcedir):
    print(filename)
    image = Image.open(sourcedir + filename)
    draw = ImageDraw.Draw(image)
    font = ImageFont.truetype('arial.ttf', size=37)
    (x, y) = (0, 22)
    message = "BIG"
    color = 'rgb(244, 66, 89)'
    draw.text((x, y), message, fill=color, font=font)
    image.save(finaldir + filename)