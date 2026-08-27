# 📱 Task Management App

A modern **full-stack mobile task management application** designed to help users organize, manage, and track their daily tasks efficiently.

The application provides secure authentication, task creation and management, priorities, statuses, assignments, labels, comments, notifications, and activity tracking through a **Flutter mobile application** connected to an **ASP.NET Core REST API** and **PostgreSQL database**.

---

## 🚀 Features

### 🔐 Authentication & Security

* User registration and login
* Access token & refresh token authentication
* Secure token storage
* Automatic token refresh
* Protected API endpoints
* User-based authorization

### ✅ Task Management

* Create new tasks
* Update tasks
* Delete tasks
* View task details
* Search and filter tasks
* Assign tasks to users
* Set task priority
* Set task status
* Estimate task duration


### 📊 Activity Tracking

* Record important system activities
* Track changes related to tasks and projects
* Maintain an activity history

---

# 🛠️ Technologies Used

## 📱 Mobile Application

| Technology                    | Usage                                         |
| ----------------------------- | --------------------------------------------- |
| 🐦 **Flutter**                | Cross-platform mobile application development |
| 🎯 **Dart**                   | Application programming language              |
| 🎨 **Material 3**             | Modern mobile UI design                       |
| 🌐 **HTTP**                   | REST API communication                        |
| 🔐 **Flutter Secure Storage** | Secure token storage                          |


---

## ⚙️ Backend

| Technology                    | Usage                                        |
| ----------------------------- | -------------------------------------------- |
| 🔷 **C#**                     | Backend programming language                 |
| 🚀 **ASP.NET Core Web API**   | RESTful API development                      |
| 🗄️ **Entity Framework Core** | ORM and database access                      |
| 🐘 **PostgreSQL**             | Relational database                          |
| 🔑 **JWT**                    | Authentication and authorization             |
| 📡 **REST API**               | Communication between mobile app and backend |

---


# 🏗️ Architecture

The backend follows a layered architecture to separate responsibilities and make the application easier to maintain and scale.

```text
📱 Flutter Mobile Application
              │
              │ HTTP / REST API
              ▼
┌──────────────────────────────┐
│      ASP.NET Core Web API    │
├──────────────────────────────┤
│     Presentation / API       │
├──────────────────────────────┤
│      Business Logic          │
├──────────────────────────────┤
│       Data Access            │
├──────────────────────────────┤
│     Entity Framework Core    │
└──────────────┬───────────────┘
               │
               ▼
        🐘 PostgreSQL
```

---

# 🔐 Authentication Flow

The application uses **JWT-based authentication** with access and refresh tokens.

```text
👤 User
   │
   ▼
📱 Login
   │
   ▼
🌐 ASP.NET Core API
   │
   ▼
🔑 Access Token + Refresh Token
   │
   ▼
🔐 Secure Storage
   │
   ▼
📡 Authenticated API Requests
```

When the access token expires, the application can use the refresh token to obtain a new access token.



# 🧠 Development Concepts

This project demonstrates practical knowledge of:

* 🏛️ Clean and layered architecture
* 🧩 Object-Oriented Programming
* 🔗 RESTful API design
* 🔐 Authentication & Authorization
* 🎟️ JWT Access & Refresh Tokens
* 🗄️ Relational database design
* 🔄 CRUD operations
* ✅ Input validation
* ⚠️ Exception handling
* 📦 Entity Framework Core
* 🔍 Searching and filtering
* 🔗 Entity relationships
* 📡 HTTP API communication
* 📱 Responsive Flutter UI
* 🔒 Secure local token storage

---

# 📂 Project Structure

A simplified project structure:

```text
TaskManagement/
│
├── 📱 FlutterApp/
│   ├── lib/
│   │   ├── api/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── services/
│   │   └── storage/
│   └── pubspec.yaml
│
└── ⚙️ Backend/
    │
    ├── TaskManager.API/
    ├── TaskManager.Business/
    ├── TaskManager.Data/
    └── TaskManager.Entities/
```

> The exact structure may vary depending on the final project organization.

---

# 🔄 Example Task Workflow

```text
➕ Create Task
      │
      ▼
📋 Task Created
      │
      ▼
👤 Assign User
      │
      ▼
🟡 Pending
      │
      ▼
🔵 In Progress
      │
      ▼
🟢 Completed
```

---

# 🛡️ Security

Security is an important part of the application.

The project uses:

* 🔑 JWT authentication
* 🔄 Refresh tokens
* 🔐 Secure token storage
* 🛡️ Protected API endpoints
* 👤 User authorization
* ✅ Server-side validation
* 🚫 Protection of sensitive configuration

For local development, sensitive configuration should be stored using environment variables or **.NET User Secrets**.

---

# ⚡ API Communication

The Flutter application communicates with the backend using HTTP requests.

Example:

```text
Flutter
   │
   │ POST /api/Auth/login
   ▼
ASP.NET Core API
   │
   ▼
PostgreSQL
```

For authenticated requests:

```text
Authorization: Bearer <access_token>
```


# ⭐ Why This Project?

This project demonstrates the ability to build a complete application across multiple layers:

```text
        📱 Flutter
           │
           ▼
      🌐 REST API
           │
           ▼
   ⚙️ ASP.NET Core
           │
           ▼
    🗄️ PostgreSQL
```

It combines **mobile development, backend engineering, database design, authentication, and API integration** into one practical full-stack project.

---

# 👨‍💻 Author

**Ahmed Adel**

If you find this project useful or interesting, consider giving the repository a ⭐.

---

# 📄 License

This project was developed for **educational and portfolio purposes**.
