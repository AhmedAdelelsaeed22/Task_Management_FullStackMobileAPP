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

### 📂 Project Management

* Create and manage projects
* Add members to projects
* Organize tasks by project
* Track project-related activities

### 🏷️ Labels

* Create and manage labels
* Assign labels to tasks
* Filter tasks using labels

### 💬 Comments

* Add comments to tasks
* View task discussions
* Keep communication connected to individual tasks

### 🔔 Notifications

* Track important task activities
* Notify users about relevant changes

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
| 📁 **File Picker**            | File selection and attachment handling        |

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

## 🗃️ Database

The application uses **PostgreSQL** as its relational database.

Main entities include:

```text
👤 Users
📁 Projects
👥 Project Members
✅ Tasks
📊 Task Status
🔥 Task Priority
👤 Task Assignments
🏷️ Labels
🔗 Task Labels
💬 Comments
🔔 Notifications
📋 Activity Logs
📎 Attachments
```

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

---

# 📱 Application Structure

```text
Task Management App
│
├── 📱 Flutter Mobile App
│   │
│   ├── 🔐 Authentication
│   │   ├── Login
│   │   ├── Signup
│   │   └── Token Management
│   │
│   ├── 📋 Tasks
│   │   ├── Task List
│   │   ├── Task Details
│   │   ├── Add Task
│   │   └── Edit Task
│   │
│   ├── 📁 Projects
│   │
│   ├── 👤 Profile
│   │
│   ├── 🔔 Notifications
│   │
│   └── ⚙️ Settings
│
└── ⚙️ ASP.NET Core Web API
    │
    ├── 🔐 Authentication
    ├── 👤 Users
    ├── 📁 Projects
    ├── ✅ Tasks
    ├── 🏷️ Labels
    ├── 💬 Comments
    ├── 🔔 Notifications
    └── 📋 Activity Logs
```

---

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

> ⚠️ Never commit database passwords, JWT secrets, API keys, or other sensitive credentials to GitHub.

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

---

# 🧪 Testing & Validation

The application includes validation for important operations such as:

* 👤 User registration
* 🔑 Login credentials
* 📝 Task title
* 📊 Task status
* 🔥 Task priority
* ⏱️ Estimated hours
* 📁 Project membership
* 🔐 Authorization

---

# 🚀 Getting Started

## 1️⃣ Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
```

## 2️⃣ Backend Setup

Navigate to the backend project:

```bash
cd TaskManager.API
```

Restore dependencies:

```bash
dotnet restore
```

Configure your PostgreSQL connection string and required secrets.

Then run:

```bash
dotnet run
```

---

## 3️⃣ Database Setup

Create a PostgreSQL database and configure the connection string.

Example:

```text
Host=localhost;
Port=5432;
Database=TaskManager;
Username=YOUR_USERNAME;
Password=YOUR_PASSWORD;
```

Apply the Entity Framework Core migrations if migrations are included in the project:

```bash
dotnet ef database update
```

---

## 4️⃣ Flutter Setup

Navigate to the Flutter application:

```bash
cd FlutterApp
```

Get dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# 🌐 API Configuration

Update the API base URL in the Flutter application according to your environment.

For Android Emulator, a local ASP.NET Core API may require:

```text
http://10.0.2.2:PORT
```

instead of:

```text
http://localhost:PORT
```

because `localhost` inside the Android emulator refers to the emulator itself.

---

# 📸 Screenshots

Add screenshots of your application here.

### 🔐 Login

*Add login screen screenshot here.*

### 📝 Sign Up

*Add signup screen screenshot here.*

### 📋 Task List

*Add task list screenshot here.*

### ➕ Add Task

*Add add-task screen screenshot here.*

### 📄 Task Details

*Add task details screenshot here.*

### 👤 Profile

*Add profile screen screenshot here.*

---

# 🎯 Project Goals

The main goals of this project are to build a complete full-stack application while practicing:

* 📱 Mobile application development
* ⚙️ Backend API development
* 🗄️ Database design
* 🔐 Secure authentication
* 🏛️ Software architecture
* 🔗 API integration
* 🧩 OOP and clean code
* 🚀 Production-oriented development

---

# 🔮 Future Improvements

Possible future features include:

* 🔔 Real-time notifications
* 💬 Real-time task comments
* 📎 File upload and cloud storage
* 📊 Advanced dashboards
* 📈 Task analytics
* 📅 Calendar integration
* 🔎 Advanced search
* 🌐 Web administration dashboard
* ☁️ Cloud deployment
* 🐳 Docker support
* 🔄 CI/CD pipeline
* 🧪 Automated unit and integration tests

---

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
