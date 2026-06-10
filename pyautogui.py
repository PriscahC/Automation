import pyautogui
import pyperclip
import time
import os
import subprocess
import psutil

BASE_DIR = r"D:\Datasets"

# ── helpers ────────────────────────────────────────────────────────────
def ensure_terra_running():
    for proc in psutil.process_iter(['name']):
        if 'DJITerra' in proc.info['name']:
            return
    subprocess.Popen(r"C:\Program Files\DJI Terra\DJITerra.exe")
    time.sleep(8)

def click(template, confidence=0.8, region=None):
    kwargs = {"confidence": confidence}
    if region:
        kwargs["region"] = region
    x, y = pyautogui.locateCenterOnScreen(template, **kwargs)
    pyautogui.moveTo(x, y, duration=0.5)
    pyautogui.leftClick()
    return x, y

def paste_path(path):
    pyperclip.copy(path)
    pyautogui.hotkey("ctrl", "l")
    time.sleep(0.3)
    pyautogui.hotkey("ctrl", "a")
    pyautogui.hotkey("ctrl", "v")
    pyautogui.press("enter")
    time.sleep(1.5)

# ── main ───────────────────────────────────────────────────────────────
ensure_terra_running()
click("terra-icon.PNG")

for area in os.listdir(BASE_DIR):
    area_path = os.path.join(BASE_DIR, area)

    if not os.path.isdir(area_path):
        continue

    for flight_date in os.listdir(area_path):
        target_path = os.path.join(area_path, flight_date)

        if not os.path.isdir(target_path):
            continue

        project_name = f"{area}-{flight_date}"
        print(f"Processing: {project_name}")

        # create project
        click("create-project.PNG")
        click("multispectral.PNG")

        # name it
        pyautogui.moveTo(960, 489, duration=1)
        pyautogui.leftClick()
        pyautogui.hotkey("ctrl", "a")
        pyautogui.typewrite(project_name, interval=0.1)
        pyautogui.moveTo(1120, 647, duration=1)
        pyautogui.leftClick()
        time.sleep(2)

        # upload folder
        click("folder.PNG", confidence=0.9)
        time.sleep(1.5)
        paste_path(target_path)  # uses the correct flight_date subfolder
        pyautogui.hotkey("ctrl", "a")
        time.sleep(0.5)
        pyautogui.moveTo(782, 514, duration=1)
        pyautogui.leftClick()
        time.sleep(3)

        time.sleep(40)
        pyautogui.moveTo(1732, 972, duration=1)
        pyautogui.leftClick()
        time.sleep(1)
        click("run.PNG", confidence=0.9)
        time.sleep(1)

        print(f"Queued: {project_name}")

        print("Going back...")
        pyautogui.moveTo(27, 45, duration=1)
        pyautogui.leftClick()
        time.sleep(2)

print("All projects queued. Terra is running.")
