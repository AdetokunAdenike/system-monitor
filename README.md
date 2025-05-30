# System Resource Monitor (RAM & CPU Logger)

This project is a simple **Bash-based** system resource monitor that tracks **RAM and CPU usage** at regular intervals and logs the results to a CSV file. It also supports **real-time alerts** for high RAM usage and can **send daily reports via email** using `msmtp`.


🚀 Features

- ✅ Logs RAM and CPU usage every few seconds
- ✅ Real-time warning when RAM usage exceeds a set threshold
- ✅ Daily system usage report sent via email
- ✅ Logs saved in CSV format for easy analysis
- ✅ Customizable interval and thresholds


📂 Project Structure

```
├── monitor_system.sh       # Main monitoring script
├── send_report.sh          # Script to email daily logs
├── .env                    # Environment variables (e.g., recipient email)
├── .gitignore              # Git ignore rules
├── system_usage.log        # CSV log file (auto-generated)
└── README.md               # Project documentation
```

## ⚙️ Requirements

* Bash shell
* `msmtp` installed and configured (for sending email)
* Optional: `notify-send` (for desktop RAM alerts)
* Linux or WSL (for Windows users)


## 🔧 Setup

1. **Clone the repository**:

   ```bash
   git clone https://github.com/adetokunadenike/system-monitor.git
   cd system-monitor
   ```

2. **Install `msmtp`** and configure your SMTP settings (e.g., for Gmail).
   See: [msmtp documentation](https://marlam.de/msmtp/)

3. **Create a `.env` file** with your email (optional if using Docker or PipeOps):

   ```bash
   echo "EMAIL=your_email@example.com" > .env
   ```

   📌 If you're deploying via PipeOps or Docker with environment variables, `.env` is optional and not required.

4. **Make scripts executable**:

   ```bash
   chmod +x monitor_system.sh send_report.sh
   ```

## ▶️ Usage

### Run the Monitor Manually

```bash
./monitor_system.sh
```

This logs system usage to `system_usage.log` every 5 seconds and triggers an alert if RAM usage exceeds 80%.

### Send Daily Email Manually (for testing)

```bash
./send_report.sh
```

### Automate Email via Cron

Open your crontab:

```bash
crontab -e
```

Add this line to run the report daily at midnight:

```cron
0 0 * * * /bin/bash /full/path/to/send_report.sh >> /tmp/send_report.log 2>&1
```

> You can check `/tmp/send_report.log` for cron job output.

---

## 📄 Sample Log

```csv
Timestamp,RAM_Total_MB,RAM_Used_MB,RAM_Free_MB,RAM_Usage_%,CPU_Usage_%
2025-05-28 10:00:01,7980,3000,4980,37.59,12.0
2025-05-28 10:00:06,7980,3100,4880,38.85,15.5
```

---

## ⚠️ Alerts

When RAM usage exceeds the set threshold (default: **80%**), the script will:

* Print a warning in the terminal
* Trigger a desktop notification (if `notify-send` is installed)

---

## 🔐 .gitignore

This project ignores sensitive and generated files:

```gitignore
.env
*.log
```

---

## 📬 Email Configuration Tips (msmtp)

1. Install `msmtp`:

   ```bash
   sudo apt install msmtp
   ```

2. Create a config file at `~/.msmtprc`:

   ```conf
   defaults
   auth on
   tls on
   tls_trust_file /etc/ssl/certs/ca-certificates.crt
   logfile ~/.msmtp.log

   account gmail
   host smtp.gmail.com
   port 587
   from your_email@gmail.com
   user your_email@gmail.com
   password your_app_password

   account default : gmail
   ```

3. Make it secure:

   ```bash
   chmod 600 ~/.msmtprc
   ```

---

## 🚢 Deploying on PipeOps

This project can be deployed using [PipeOps](https://pipeops.io) for automated daily email reports in the cloud.

1. Add a `pipeops.yaml` file to define the job and schedule.
2. Include a `Dockerfile` to run `send_report.sh`.
3. Set `EMAIL` as a secure environment variable in the PipeOps dashboard.
4. Logs and email confirmations are available in the PipeOps dashboard.

---

## 👤 Author

**Adetokun Adenike**

* [GitHub](https://github.com/adetokunadenike)
* Email: `adetokunadenike@gmail.com`

---

## 📃 License

This project is licensed under the MIT License.

```