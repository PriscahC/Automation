import time, os, subprocess

while True:
    if os.path.exists(r"D:\go.txt"):
        os.remove(r"D:\go.txt")
        subprocess.Popen(["python", r"C:\Users\iris\Desktop\AutoGui\Terrun\rerun.py"])
    time.sleep(5)
