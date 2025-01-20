import os
from PIL import Image, ImageChops
from robot.libraries.BuiltIn import BuiltIn


def capture_full_page_screenshot_part(file_name):
    selenium_lib = BuiltIn().get_library_instance('SeleniumLibrary')
    driver = selenium_lib.driver
    # Sayfa boyutlarını al
    total_height = driver.execute_script("return document.body.scrollHeight")
    viewport_height = driver.execute_script("return window.innerHeight")
    print(f"{total_height} {viewport_height}")
    # Tarayıcı boyutunu genişlet
    driver.set_window_size(1920, total_height + 5000)  # Yükseklik için fazladan bir tampon ekleyin


    # Parça parça ekran görüntüsü al
    images = []
    for offset in range(0, total_height, viewport_height):
        driver.execute_script(f"window.scrollTo(0, {offset})")
        BuiltIn().sleep(1)  # Dinamik yükleme bekleme süresi artırıldı
        screenshot_path = f"temp_screenshot_{offset}.png"
        driver.save_screenshot(screenshot_path)
        images.append(Image.open(screenshot_path))

    # Görselleri birleştir
    total_image = Image.new("RGB", (1920, sum(img.height for img in images)))
    y_offset = 0
    for img in images:
        total_image.paste(img, (0, y_offset))
        y_offset += img.height

    # Hedef dosya yolunu oluştur
    final_path = os.path.join("screenshots", file_name)
    total_image.save(final_path)
    print(f"Full page screenshot saved to: {final_path}")


def compare_images(page_name, new_img, diff_img):
    """
    İki görüntüyü karşılaştırır ve farklılıkları screenshots klasörüne kaydeder.
    """
    # Referans görüntü ismini oluştur
    reference_img = f"{page_name}_reference.png"

    # Görselleri aç
    ref_image_path = os.path.join("screenshots", reference_img)
    new_image_path = os.path.join("screenshots", new_img)
    diff_path = os.path.join("screenshots", diff_img)

    if not os.path.exists(ref_image_path):
        print(f"Reference image not found: {ref_image_path}")
        return False

    ref_image = Image.open(ref_image_path)
    new_image = Image.open(new_image_path)

    # Görselleri karşılaştır
    diff = ImageChops.difference(ref_image, new_image)

    # Eğer farklılık yoksa (tamamen aynıysa), diff siyah olur
    if diff.getbbox() is None:
        print("Images are identical.")
        return True

    # Farklılıkları kaydet
    diff.save(diff_path)
    print(f"Images are different. Differences saved to {diff_path}.")
    return False
