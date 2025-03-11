# 📖 Language Translator App

A powerful **Language Translator** app built using **Flutter** and integrated with **Google Gemini API** for text translation and **Dictionary API** for word meanings. The app also includes a chat feature and learning modules for better language understanding.



## 🌟 Features

- 📖 **Dictionary** - Get word meanings, synonyms, and antonyms.
- 🌍 **Language Translation** - Translate text between multiple languages.
- 💬 **Chatbot** - Communicate in different languages.
- 📚 **Learning Section** - Improve vocabulary with books and language lessons.
- 🖼️ **Beautiful UI** - Responsive and user-friendly design.

---

## 📷 Screenshots

Splash screen | Home Screen | Dictionary | Translator | Chat | 
|------------|------------|------------|------------|------------|
| <img src="https://github.com/rahulkumardev24/Language_translator_Project_using_flutter/blob/master/Screenshot_20250311_215538.png" width="200"/>| <img src="https://raw.githubusercontent.com/rahulkumardev24/Language_translator_Project_using_flutter/master/Screenshot_20250311_220616.png" width="200"/> | <img src="https://github.com/rahulkumardev24/Language_translator_Project_using_flutter/blob/master/Screenshot_20250311_221448.png" width="200"/>| <img src="https://github.com/rahulkumardev24/Language_translator_Project_using_flutter/blob/master/Screenshot_20250311_221409.png" width="200"/> | <img src="https://github.com/rahulkumardev24/Language_translator_Project_using_flutter/blob/master/Screenshot_20250311_221839.png" width="200"/> |




## 🛠️ Tech Stack

- **Flutter** - UI Development
- **Dart** - Programming Language
- **Google Gemini API** - Text Translation
- **Dictionary API** - Word Meanings & Definitions
- **Firebase** - Backend for Chat & Storage

---

## 🚀 Installation & Setup

### 1️⃣ Clone the repository
```sh
$ git clone https://github.com/yourusername/translator-app.git
$ cd translator-app
```

### 2️⃣ Install dependencies
```sh
$ flutter pub get
```

### 3️⃣ Set up API Keys
Create a `.env` file in the root directory and add:
```env
GEMINI_API_KEY=your_api_key_here
```

Load it in `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
```

### 4️⃣ Run the App
```sh
$ flutter run
```

---

## 🛠 API Configuration

- **Google Gemini API** - [Get API Key](https://console.cloud.google.com/)
- **Dictionary API** - [Free Dictionary API](https://dictionaryapi.dev/)

---

## 📜 License

This project is licensed under the **MIT License**. Feel free to use and modify it.

---

## 🎯 Future Enhancements

- 🌐 **More Language Support**
- 🎙️ **Voice Translation**
- 📌 **Save Translations & Favorites**

---

## 🤝 Contribution

Contributions are welcome! Feel free to fork this repo and submit pull requests.

---

## 🔗 Contact

👨‍💻 Developed by **Rahul Kumar Sahu**  
📧 Email: [your.email@example.com](mailto:your.email@example.com)  
🔗 GitHub: [https://github.com/rahulkumardev24](https://github.com/rahulkumardev24))  
🔗 GitHub: [https://github.com/rahulkumardev24](https://github.com/rahulkumardev24)  

