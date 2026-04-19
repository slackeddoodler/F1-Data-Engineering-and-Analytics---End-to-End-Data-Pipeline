# F1-Data-Engineering-and-Analytics---End-to-End-Data-Pipeline

This project is a production-grade data engineering pipeline designed to ingest, transform, and visualize **Formula 1 2024 season** data. By leveraging modern orchestration, cloud-native storage, and analytics engineering best practices, this repository demonstrates a complete lifecycle from raw API ingestion to a functional stakeholder dashboard.

---

## 🏎️ Project Overview

The goal of this project is to provide deep insights into race dynamics, driver performance, and technical trends (such as tyre degradation) using the 2024 F1 Sprint and Race data.

### Tech Stack
* **Orchestration:** [Kestra](https://kestra.io/)
* **Data Warehouse:** [MotherDuck](https://motherduck.com/) (Serverless DuckDB)
* **Transformation:** [dbt (data build tool)](https://www.getdbt.com/)
* **Visualization:** [Metabase](https://www.metabase.com/)
* **Infrastructure:** Docker & Docker Compose

---

## 🏗️ Architecture

1.  **Ingestion:** Kestra orchestrates the extraction of 2024 race and sprint data, loading it directly into **MotherDuck**.
2.  **Storage:** MotherDuck acts as the centralized OLAP warehouse, hosting both raw and modeled data.
3.  **Transformation:** dbt connects to MotherDuck to run modular SQL transformations, building the analytics layer (Championship standings, tyre life, etc.).
4.  **Analytics:** Metabase queries the materialized tables in MotherDuck to power a unified dashboard.

---

## 📊 Data Insights & Transformations

The following models were developed using dbt to drive the final Metabase dashboard:

* **Race Progression:** A temporal analysis of positions throughout the Grand Prix.
* **Constructor Championship:** Real-time standings based on team points.
* **Drivers Championship:** Current season standings for the driver's title.
* **Driver Consistency:** Analysis of lap-time variance and finishing reliability.
* **Tyre Life Degradation:** Detailed telemetry-based analysis of tire performance over stint lengths.

> **Note:** The **Emilia Romagna Grand Prix** was utilized as the primary filter for the "Race Progression," "Driver Consistency," and "Tyre Life" visualizations to demonstrate deep-dive capabilities.

## F1 Analytics Dashboard
<img width="894" height="1080" alt="image" src="https://github.com/user-attachments/assets/ae1fd82e-0165-4f82-b32e-5951412c3553" />

---

## 🚀 Steps to Reproduce

### 1. Prerequisites
* Docker and Docker Compose installed.
* A [MotherDuck](https://motherduck.com/) account and an **API Token**.

### 2. Infrastructure Setup
Clone this repository and navigate to the project root.

### 3. Database Initialization
Before starting the orchestration or transformation layers, log in to your **MotherDuck** account and create the target database:
```sql
CREATE DATABASE raw_data;
```

---

### 4. Orchestration (Kestra)
1.  **Secrets Management:** * Base64 encode your MotherDuck API token.
    * Open the `.env-encoded` file in the project root and paste the encoded string as the value for your MotherDuck secret.
2.  **Deployment:** Run the following command to start the Kestra instance:
    ```bash
    docker compose up -d
    ```
3.  Access the Kestra UI at `http://localhost:8080`, import the `f1_ingestion_workflow.yaml`, and execute the flow to populate the `raw_data` database.

---

### 5. Transformation (dbt)

1.  **Initialize the Project:**
    Run the following command to create your dbt workspace. When prompted for a name, use `f1_project`:
    ```bash
    dbt init f1_project
    ```

2.  **Configure your Profile:**
    dbt requires a `profiles.yml` file to authenticate with MotherDuck.
    * Navigate to your dbt configuration directory (usually `~/.dbt/` on macOS/Linux or `%USERPROFILE%\.dbt\` on Windows).
    * Replace the existing `profiles.yml` with the version provided in this repository.
    * **Action Required:** Open the file and ensure you update the `token` placeholder with your actual MotherDuck API token.

3.  **Import Models:**
    To ensure the transformations are ready to run, copy the SQL files from the `/models` directory in this repository and paste them into the `f1_project/models` folder created during initialization.

4.  Run the following command to build the models:
    ```bash
    dbt run
    ```


## 📂 Project Structure
* `/kestra`: Workflow YAMLs and orchestration config.
* `/dbt`: dbt project, including `profiles.yml` (placeholder) and `/models` for SQL transformations.
