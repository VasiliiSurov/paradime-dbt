import requests
import xmltodict
import os
from os.path import exists


LINK = 'https://s3.amazonaws.com/tripdata/'
PATH = '../csv_data/'


def download():
    request = requests.get(LINK)
    data = xmltodict.parse(request.text)

    for content in data['ListBucketResult']['Contents']:
        filename = content['Key']
        url = LINK + filename
        if filename[-3:] == 'zip':
            print(url)
            file_path = os.path.join(PATH, filename)
            if exists(file_path):
                print('File already exists')
            else:
                r = requests.get(url, stream=True)
                if r.ok:
                    print("saving to", os.path.abspath(file_path))
                    with open(file_path, 'wb') as f:
                        for chunk in r.iter_content(chunk_size=1024 * 8):
                            if chunk:
                                f.write(chunk)
                                f.flush()
                                os.fsync(f.fileno())
                else:  # HTTP status code 4XX/5XX
                    print("Download failed: status code {}\n{}".format(r.status_code, r.text))


if __name__ == '__main__':
    download()

# Doesn't work on python3.10, run on python3.8