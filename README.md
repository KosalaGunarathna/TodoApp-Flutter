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


## 🖼 Screenshots

<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center">
      <img width="240" src="https://github.com/user-attachments/assets/61f1094c-2314-4c71-803f-2cd250118b84" /><br>
      Home Screen
    </td>
    <td align="center">
      <img width="240" src="https://github.com/user-attachments/assets/ea5e39b8-9e2e-4572-88dc-11c352e28b78" /><br>
      Add Task
    </td>
    <td align="center">
      <img width="240" src="https://github.com/user-attachments/assets/0c20fc65-f683-4813-8ff2-dd713f9979da" /><br>
      Completed Tasks
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="240" src="https://github.com/user-attachments/assets/c96921a2-6606-465c-9194-d1b6ddf885d2" /><br>
      Update Task
    </td>
    <td align="center">
      <img width="240" src="https://github.com/user-attachments/assets/62e17b9b-6355-4df6-943d-e6b31078df47" /><br>
      Delete Task
    </td>
    <td align="center">
      <img width="240" src="https://github.com/user-attachments/assets/3eb981ae-4017-4d03-8a1a-3f83759182df" /><br>
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

