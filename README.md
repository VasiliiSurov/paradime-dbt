1. Create a new gcp account and activate 90 days trial
   ```
   sova.paradime@gmial.com
   boxwood-academy-373200
   ```

2. Switch default project to the newly created one
   ```
   gcloud auth login
   gcloud config configurations list
   gcloud config set project boxwood-academy-373200
   ```

3. Create 2 buckets
   ```
   # boxwood-academy-inbound
   # boxwood-academy-archive
   # boxwood-academy-source

   gsutil mb gs://boxwood-academy-inbound
   gsutil mb gs://boxwood-academy-archive
   gsutil mb gs://boxwood-academy-source
   ```

4. Create BQ dataset for raw data
   ```
   bq mk raw
   ```

5. Create new dbt profile
   Add new profile (create new)
   ```
   vi ~/.dbt/profiles.yml
   ```
   ```
    paradime:
        outputs:
            dev:
            dataset: dev
            fixed_retries: 1
            location: US
            method: service-account
            keyfile: /Users/vasilii.surov/vscode/paradime-dbt/docker/dbt-paradime.json
            priority: interactive
            project: boxwood-academy-373200
            threads: 5
            timeout_seconds: 300
            type: bigquery

            prod:
            dataset: prod
            fixed_retries: 1
            location: US
            method: service-account
            keyfile: /Users/vasilii.surov/vscode/paradime-dbt/docker/dbt-paradime.json
            priority: interactive
            project: boxwood-academy-373200
            threads: 5
            timeout_seconds: 300
            type: bigquery

    target: dev
   ```

6. Create and authenticate new dbt project
   ```
   dbt init --adapter bigquery paradime
   gcloud auth application-default login --scopes=https://www.googleapis.com/auth/bigquery,https://www.googleapis.com/auth/drive.readonly
   ```

7. Check out dbt configuration
   ```
   dbt debug
   ```

8. Initialize git
   ```
   git init
   ```

9. dbt-utils package
   ```
   dbt deps
   ````

10. Download all csv data locally
    ```
    /home/sova/.venv/dbt/bin/python3 /home/sova/IdeaProjects/dbt/sunrun/scripts/download.py
    ```

11. Recompressing with gzip
    ```
    unzip \*.zip
    gzip *.csv
    ```

12. Upload all files to source bucket
    ```
    gsutil -m cp *.csv.gz gs://boxwood-academy-source/citibike/
    ```

13. Load test volume of data into inbound bucket
    ```
    gsutil -m cp gs://boxwood-academy-source/citibike//2018*.gz gs://boxwood-academy-inbound/citibike/
    ```

14. Load files from gcs into BQ
    ```
    ./scripts/bq_load.sh
    ```

15. Build dbt models:
    chains start [end == start] [end == start] .. end

16. Cloud build
    1. Authorize application in github
    2. Add IAM role to the SA (Composer Admin or less)
    3. Triggers on push to master
    4. Synchronizes Airflow DAG folder with github

17. Triggers Composer job to run and test dbt in DEV

18. Cloud function
    Triggers Composer job to load csv, rebuilds and test dbt, and finally archive source file

19. Composer jobs
    1. run and test dbt in DEV, triggers from github on push to master
    2. load csv, run and test in PROD, archive csv, triggers by cloud function when new file arrives

20. Models: see dbt docs
    ```
    dbt docs generate
    dbt docs serve
    ```
