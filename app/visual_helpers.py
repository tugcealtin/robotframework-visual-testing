from PIL import Image, ImageChops
from robot.libraries.BuiltIn import BuiltIn
import os

def capture_full_page_screenshot_part(file_path):
    selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')
    driver = selenium_lib.driver
    # Sayfa boyutlarını al
    total_height = driver.execute_script("return document.body.scrollHeight")
    viewport_height = driver.execute_script("return window.innerHeight")
    # Tarayıcı boyutunu genişlet
    driver.set_window_size(1920, total_height + 5000)  # Yükseklik için fazladan bir tampon ekleyin
    # Parça parça ekran görüntüsü al
    images = []
    for offset in range(0, total_height, viewport_height):
        driver.execute_script(f"window.scrollTo(0, {offset})")
        BuiltIn().sleep(0.5)
        screenshot_path = f"temp_screenshot_{offset}.png"
        driver.save_screenshot(screenshot_path)
        images.append(Image.open(screenshot_path))
    # Görselleri birleştir
    total_image = Image.new("RGB", (1920, sum(img.height for img in images)))
    y_offset = 0
    for img in images:
        total_image.paste(img, (0, y_offset))
        y_offset += img.height
    # Birleştirilen görseli kaydet
    total_image.save(file_path)
    print(f"Full page screenshot saved to: {file_path}")

def compare_images(reference_img, new_img, diff_img):
    """
    İki görüntüyü karşılaştırır ve farklılıkları diff_img dosyasına kaydeder.
    """
    # Görselleri aç
    ref_image = Image.open(reference_img)
    new_image = Image.open(new_img)
    # Görselleri karşılaştır
    diff = ImageChops.difference(ref_image, new_image)
    # Eğer farklılık yoksa (tamamen aynıysa), diff siyah olur
    if diff.getbbox() is None:
        print("Images are identical.")
        return True
    # Farklılıkları diff_img dosyasına kaydet
    diff.save(diff_img)
    print(f"Images are different. Differences saved to {diff_img}.")
    return False