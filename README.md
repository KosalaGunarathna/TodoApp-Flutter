# 📋 Flutter ToDo App (Hive Database)

A simple and fast **ToDo list application** built with **Flutter** and **Hive** as the local database.  
This app allows users to create, edit, and delete tasks with persistent storage — even after restarting the app.

---

## ✨ Features
- ✅ Add new ToDos
- 📝 Edit existing ToDos
- ❌ Delete ToDos
- 📅 Add date and time (Hive with TimeOfDay Adapter)
- 💾 Data stored locally using Hive
- ⚡ Lightweight and offline-first

 Screenshots


<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center">
      <img width="250" src="https://github.com/user-attachments/assets/f1ab9217-6cc1-4608-a22b-df0b449abfab" /><br>
      Home Screen
    </td>
    <td align="center">
      <img width="250" src="https://github.com/user-attachments/assets/ea5e39b8-9e2e-4572-88dc-11c352e28b78" /><br>
      Add Task
    </td>
    <td align="center">
      <img width="250" src="https://github.com/user-attachments/assets/56d7e8d3-d77a-44fe-af3f-bd654fe18b50"  /><br>
      Completed Tasks
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="250" src="https://github.com/user-attachments/assets/2b5d2aa0-680a-4952-8322-928510166561" /><br>
      Update Task
    </td>
    <td align="center">
      <img width="250" src="https://github.com/user-attachments/assets/a1330b26-d6aa-4ebe-8650-fa3b1480c97d" /><br>
      Delete Task
    </td>
    <td align="center">
      <img width="250" src="https://github.com/user-attachments/assets/3eb981ae-4017-4d03-8a1a-3f83759182df" /><br>
      Popup mesage
    </td>
  </tr>
</table>


---

## 🛠️ Installation & Setup

### 1. Clone the repository
git clone https://github.com/KosalaGunarathna/TodoApp-Flutter<br>
cd TodoApp-Flutter

### 2. Install dependencies
flutter pub get

### 3. Generate Hive type adapters
flutter packages pub run build_runner build

### 4. Run the app
flutter run

