import subprocess
import time
import os
import sys

# Force UTF-8 encoding for stdout on Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

LIB_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "lib")
FLUTTER_PATH = r"C:\src\flutter\bin\flutter.bat"
DEVICE_ID = "emulator-5554"

def get_mtime_dict(directory):
    mtimes = {}
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                try:
                    mtimes[filepath] = os.path.getmtime(filepath)
                except Exception:
                    pass
    return mtimes

def main():
    print(f"[Flutter Auto-Reloader] Launching app on Android emulator ({DEVICE_ID})...")
    cmd = [FLUTTER_PATH, "run", "-d", DEVICE_ID]
    
    proc = subprocess.Popen(
        cmd,
        cwd=os.path.dirname(os.path.abspath(__file__)),
        stdin=subprocess.PIPE,
        stdout=sys.stdout,
        stderr=sys.stderr,
        text=True,
        bufsize=1
    )

    last_mtimes = get_mtime_dict(LIB_DIR)
    print(f"[Flutter Auto-Reloader] Watching {LIB_DIR} for file changes...")

    try:
        while True:
            time.sleep(1)
            if proc.poll() is not None:
                print("[Auto-Reloader] Flutter process exited.")
                break
            
            current_mtimes = get_mtime_dict(LIB_DIR)
            changed_file = None
            for path, mtime in current_mtimes.items():
                if path not in last_mtimes or mtime > last_mtimes[path]:
                    changed_file = os.path.basename(path)
                    break
            
            if changed_file:
                last_mtimes = current_mtimes
                print(f"\n[Auto-Reloader] Change detected in '{changed_file}'! Hot reloading emulator...")
                try:
                    proc.stdin.write("r\n")
                    proc.stdin.flush()
                except Exception as e:
                    print(f"[Auto-Reloader] Error sending hot reload: {e}")
    except KeyboardInterrupt:
        proc.terminate()

if __name__ == "__main__":
    main()
