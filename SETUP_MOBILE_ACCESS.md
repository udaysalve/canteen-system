# 📱 MOBILE ACCESS SETUP - USING NGROK

## 🌐 **SOLUTION: Use ngrok to expose your server to mobile**

Since your local network blocks device-to-device connections, we'll use **ngrok** to create a secure tunnel that makes your server accessible from anywhere.

---

## 🚀 **STEP-BY-STEP SETUP**

### **Step 1: Download ngrok**

1. Go to: https://ngrok.com/download
2. Click "Download for Windows"
3. Extract the ZIP file
4. Copy `ngrok.exe` to: `C:\Users\DELL\Desktop\cms\`

### **Step 2: Sign up (Free)**

1. Go to: https://dashboard.ngrok.com/signup
2. Sign up with email (free account)
3. After signup, copy your authtoken
4. It looks like: `2abc123def456ghi789jkl`

### **Step 3: Setup ngrok**

Open Command Prompt in cms folder and run:
```
ngrok config add-authtoken YOUR_TOKEN_HERE
```

Replace `YOUR_TOKEN_HERE` with your actual token.

### **Step 4: Start ngrok**

In Command Prompt, run:
```
ngrok http 8080
```

You'll see something like:
```
Forwarding   https://abc123.ngrok.io -> http://localhost:8080
```

### **Step 5: Use the ngrok URL**

Copy the HTTPS URL (e.g., `https://abc123.ngrok.io`)

Now you can access from mobile:
- Customer App: `https://abc123.ngrok.io/c3.html`
- Admin Portal: `https://abc123.ngrok.io/admin_portal.html`

---

## 📱 **ALTERNATIVE: Create QR Codes with ngrok URL**

Once ngrok is running:

1. Copy your ngrok URL (e.g., `https://abc123.ngrok.io`)
2. Open: http://localhost:8080/qr-codes.html
3. Update the `baseURL` to your ngrok URL
4. Generate QR codes
5. Scan with mobile - IT WILL WORK! ✅

---

## ⚡ **QUICK START SCRIPT**

I'll create a script that starts everything including ngrok.
