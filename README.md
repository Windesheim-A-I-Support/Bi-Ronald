
# Supply Chain Resilience Survey Platform (Integrated with Local AI Stack)

> “What if every participant got a personalized report — immediately after submitting your survey — and you never had to touch a spreadsheet again?”

---

### What is it?

This is a self-hosted platform that automates the entire research survey process: it collects responses, generates personalized reports, and sends them to participants — using only open-source tools, on infrastructure you control.

---

### How does it work?

A participant completes a multi-step survey. Their responses are stored in a secure local database. That data triggers an automated workflow that generates a customized report in PDF or HTML format. The report is then emailed to the participant.

At the same time, the data is saved and ready for structured analysis — using dashboards or custom analytics built from your own templates. All services are containerized and run locally: from the survey UI to the report generation, to the delivery process.

---

### Why do I care?

Manual survey reporting is slow. Most cloud tools don’t meet institutional or ethical standards. And participants rarely receive meaningful feedback.

This system fixes all of that:

- It replaces spreadsheets and templates with a reproducible pipeline.
- It respects data sovereignty, working entirely within your infrastructure.
- It gives participants immediate, personalized feedback.
- It adapts to any research topic — from sustainability to compliance to behavioral studies.

It’s efficient, auditable, and reusable — whether for a single study or a recurring academic program.

---

### What’s the catch?

You’ll need to deploy it yourself. That means using Docker, configuring open-source tools, and maintaining a small server or VM.

But once it’s live, it runs on its own — no SaaS, no exports, no recurring costs.




This system collects supply chain survey data, generates reports, and delivers them via email — fully self-hosted using components from the [local-ai-packaged](https://github.com/coleam00/local-ai-packaged) stack.

---

## 🧩 Architecture Overview (All tools from local-ai-packaged)
```mermaid
graph TD

%% === FRONTEND SURVEY UI ===
Survey[SurveyJS Frontend hosted via Traefic] -->|Form Submission| Webhook[n8n Webhook]

%% === BACKEND WORKFLOW ===
Webhook -->|Store Response| DB[Supabase Postgres]
Webhook -->|Trigger Report Generation| Report[Quarto Script or CLI Tool]
Report -->|Generate PDF or HTML| File[Report File]
File -->|Send to User| Email[SMTP via n8n]

%% === DASHBOARD ===
DB --> Dashboard[Quarto Dashboard Static HTML]

%% === OPTIONAL ===
subgraph Optional Future AI Layer
    Ollama[LLM via Ollama]
    Qdrant[Vector DB]
    WebUI[Open WebUI / Flowise]
    Dashboard --> Ollama
end
```


## ⚙️ Tools Used (All from Local AI Packaged)

| Component            | Tool                  |
|----------------------|-----------------------|
| Survey Frontend      | SurveyJS (static HTML)|
| Workflow Engine      | n8n                   |
| Database             | Supabase (PostgreSQL) |
| Report Generator     | Python or Shell (inside n8n) |
| Email Delivery       | n8n SMTP node         |
| LLM Option (future)  | Ollama                |
| Vector DB (optional) | Qdrant                |
| Dashboard (optional) | Add Metabase manually |
| HTTPS + Routing      | Caddy                 |

---

## 🧭 Setup Steps

1. **Provision the stack**  
   Clone and run the `start_services.py` from `local-ai-packaged`.

2. **Configure DNS via Cloudflare**  
   Point subdomains (`n8n.yourdomain.com`, etc.) to your cloud instance.

3. **Host the survey**  
   Serve the static SurveyJS wizard with Caddy or GitHub Pages.

4. **Build your workflow in n8n**  
   - HTTP Webhook receives survey data  
   - Store data in Supabase  
   - Trigger script to generate report (HTML or PDF)  
   - Send via SMTP  

5. **Optional: Add Metabase dashboard**  
   Deploy Metabase in `docker-compose.override.yml` and connect to Supabase.

6. **Optional: Enable AI Enhancements**  
   - Use Ollama to summarize answers  
   - Use Qdrant for semantic search or question answering  
   - Use Flowise to build local agents  

---

## 🧾 Minimum Workflow (n8n)

1. `HTTP Webhook` → Receives JSON from survey form  
2. `Postgres Insert` → Saves data to Supabase  
3. `Execute Command` → Runs local script to generate report  
4. `Email` → Sends report as attachment

---

## 🔒 Security Notes

- No user auth is enabled in first version  
- No external services are used (fully local)  
- All services are containerized via Docker  
- TLS is managed via Caddy using Let’s Encrypt

---

## 📦 Folder Structure Suggestion

```
/survey/               # Static SurveyJS files
/workflows/            # Exported n8n workflows
/reports/              # Output PDFs/HTML reports
/scripts/              # Report generation scripts
.env                   # Environment configuration
README.md              # This file
```

---

## 📬 Next Steps

- [ ] Host SurveyJS form via Caddy
- [ ] Build and test n8n workflow
- [ ] Store form results in Supabase
- [ ] Generate and send reports
- [ ] Optionally connect Metabase or AI extensions

