# 🧹 dock-volume-cleanup

A handy script to clean up unused Docker volumes.

---

## 🔧 Features

- 🗑️ Removes **dangling volumes** (default behavior)
- 💣 Optional: Use `--force-all` to remove **all unused volumes**, even named ones
- 📋 Lists remaining volumes after cleanup
- ✅ Safe: does **not** touch containers or images

---

## 📦 Requirements

- Docker must be **installed** and **running**

---

## 🚀 Installation

1. Save the script as `docker-volume-cleanup.sh`
2. Make it executable:
   ```bash
   chmod +x docker-volume-cleanup.sh
    ```
   ![Screenshot from 2025-06-18 08-32-10](https://github.com/user-attachments/assets/fa33b51c-85f6-4ac8-aca2-3485b592f989)


   ![image](https://github.com/user-attachments/assets/3af6a851-0639-4c92-b76e-b8e305562a50)
