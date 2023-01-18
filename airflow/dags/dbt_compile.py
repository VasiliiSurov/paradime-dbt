
# Example setup for running Paradime's Bolt in your own airflow DAG
#
# Airflow will need to be setup with the variables (please ask Paradime for these):
# - X-API-KEY
# - X-API-SECRET
# - URL
#
# The global variables should also be customised in this file:
# - SCHEDULE_NAME - should match the name of the name field in the paradime_schedules.yml file in the DBT folder
# - DAG_ID - a unique identifier for the DAG
# - SCHEDULE_INTERVAL - a cron schedule for when the dag should run (e.g. "0 0 * * *")
#

# Standard library modules
import datetime

# Third party modules
import requests
from airflow import DAG
from airflow.models import Variable
from airflow.models.taskinstance import TaskInstance
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from airflow.sensors.python import PythonSensor

SCHEDULE_NAME = "paradime_compile"

DAG_ID = "0_bolt_airflow"
SCHEDULE_INTERVAL = "None"


def run_schedule(
    schedule_name: str, url: str, headers: dict[str, str], task_instance: TaskInstance
) -> None:
    query = """
    mutation trigger($scheduleName: String!) {
      triggerBoltRun(scheduleName: $scheduleName){
        runId
      }
    }
    """

    response = requests.post(
        url,
        json={"query": query, "variables": {"scheduleName": schedule_name}},
        headers=headers,
    )
    run_id = _extract_gql_response(response, "triggerBoltRun", "runId")

    # store run_id
    task_instance.xcom_push(key="run_id", value=run_id)


def get_run_status(url: str, headers: dict[str, str], task_instance: TaskInstance) -> bool:
    query = """
    query Status($runId: Int!) {
      boltRunStatus(runId: $runId) {
        state
      }
    }
    """

    run_id = task_instance.xcom_pull(key="run_id")
    response = requests.post(
        url, json={"query": query, "variables": {"runId": int(run_id)}}, headers=headers
    )
    state = _extract_gql_response(response, "boltRunStatus", "state")

    if state == "FAILED":
        raise Exception(f"Run {run_id} failed")
    elif state == "ERROR":
        raise Exception(f"Run {run_id} has error(s)")

    return state != "RUNNING"


def _extract_gql_response(request: requests.Response, query_name: str, field: str) -> str:
    response_json = request.json()
    if "errors" in response_json:
        raise Exception(f"{response_json['errors']}")

    try:
        return response_json["data"][query_name][field]
    except (TypeError, KeyError) as e:
        raise ValueError(f"{e}: {response_json}")


with DAG(
    dag_id=DAG_ID,
    schedule_interval=SCHEDULE_INTERVAL,
    default_args={
        "start_date": datetime.datetime.today() - datetime.timedelta(days=1),
    },
    catchup=False,
) as dag:
    start = DummyOperator(task_id="start")

    safe_schedule_name = SCHEDULE_NAME.replace(" ", "_")
    url = Variable.get("URL")
    headers = {
        "Content-Type": "application/json",
        "X-API-KEY": Variable.get("X-API-KEY"),
        "X-API-SECRET": Variable.get("X-API-SECRET"),
    }

    opr_start_schedule_run = PythonOperator(
        task_id=f"start_schedule_run_{safe_schedule_name}",
        python_callable=run_schedule,
        op_kwargs={
            "schedule_name": SCHEDULE_NAME,
            "headers": headers,
            "url": url,
        },
    )

    sensor_get_run_status = PythonSensor(
        task_id=f"get_run_status_{safe_schedule_name}",
        python_callable=get_run_status,
        op_kwargs={
            "headers": headers,
            "url": url,
        },
    )

    end = DummyOperator(task_id="end")

    (start >> opr_start_schedule_run >> sensor_get_run_status >> end)
