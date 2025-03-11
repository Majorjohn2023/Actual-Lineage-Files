import time
import json
import requests
import datetime
from pytz import timezone  
import sys, os
import csv, io
import logging
import warnings
import calendar
import ast
import pickle
from bs4 import BeautifulSoup as BS
from pathlib import Path
warnings.simplefilter(action='ignore', category=FutureWarning)

###########################################  Python Logger Configuration ###########################

class InfoFilter(logging.Filter):
    """
        FIlter Class for Only Capturing
        Warning and Error level logs.
    """

    def filter(self, rec):
        return rec.levelno in (logging.INFO, logging.ERROR, logging.WARNING)
        

def logger_config():
    """
        Python logger config to filter out log level.
    """
    logging.basicConfig(format='%(asctime)s  %(levelname)-s  %(name)s %(message)s', datefmt="%d-%m-%Y %H:%M:%S",
                        handlers=[logging.StreamHandler(sys.stdout)])

    logger = logging.getLogger(__name__)
    logger.addFilter(InfoFilter())
    logging.getLogger().setLevel(logging.INFO)
    warnings.simplefilter(action='ignore', category=FutureWarning)
    logging.getLogger("requests").setLevel(logging.WARNING)
    logging.getLogger("urllib3").setLevel(logging.WARNING)
    logging.getLogger("snowflake").setLevel(logging.WARNING)


###########################################################################


def validate_response(response):
    """
    This function is helper function to validate_response
    response.
    
    :param response(string) response from api endpoint
    
    """ 
        
    if int(response.status_code) == 429:
        logging.warning("API Call Limit is hit.")
        logging.warning(response.content)
        logging.warning(response.status_code)
        logging.warning(response.url)
        return True    
        
    elif int(response.status_code) != 200:
        logging.error("Something has failed, please see below error message.")
        logging.error(response.content)
        logging.error(response.status_code)
        logging.error(response.url)
        sys.exit(1)

def validate_post(response):
    """
    This function is helper function to validate_response
    response.
    
    :param response(string) response from api endpoint
    
    """ 
    if int(response.status_code) == 200 or int(response.status_code) == 202:
        okay = 10
    else:
        logging.error("Something has failed, please see below error message.")
        logging.error(response.content)
        logging.error(response.status_code)
        logging.error(response.url)
        sys.exit(1)        
        
def get_products(token, lastCursor, latestFeaturedAt, hasMore):
    
    url = f"https://api.producthunt.com/v2/api/graphql"
    headers = {"Authorization": f'Bearer {token}', "Connection": "keep-alive"}
    postedAfter = latestFeaturedAt
    after = lastCursor
    hasMore = hasMore    
    
    if lastCursor != "" and latestFeaturedAt != "":
        condition = f'featured: true, order: FEATURED_AT, after: "{lastCursor}", postedAfter: "{postedAfter}"'
    elif lastCursor != "" and latestFeaturedAt == "":
        condition = f'featured: true, order: FEATURED_AT, after: "{lastCursor}"'
    elif lastCursor == "" and latestFeaturedAt != "":
        condition = f'featured: true, order: FEATURED_AT, postedAfter: "{postedAfter}"'    
    else:
        condition = f'featured: true, order: FEATURED_AT'
        

    data = {"query": f'''{{
  posts( {condition} ) {{
    totalCount
    pageInfo{{
      hasNextPage
      hasPreviousPage
      endCursor
      startCursor
    }}
    edges{{    
      cursor
      node {{
        id
        name
        tagline
        slug
        description
        featuredAt
        createdAt
        commentsCount
        votesCount
        reviewsCount
        website
        userId
        isVoted
        isCollected
        makers {{
          id
          createdAt
          name
          username
          headline
          twitterUsername
          websiteUrl
          url
        }}
      }}
    }}
  }}
}}'''}
    
    logging.info(f"Getting product list.")
    response = requests.post(url = url, headers=headers, data=data)
    call_resp = validate_response(response)
    
    if call_resp == True:
        print('API Limit hit')
        dum = []
        return dum
    else:
        response = response.json()
        logging.info(f"Successfully fetched product list.")
        return response 


def sub_main(token,latestFeaturedAt,lastCursor):
    
    hasMore = True
    data = []
    #webhook_url = 'https://webhooks.fivetran'
    webhook_url = 'https://webhook-test.com/9de8126b9a79465082a512ce53f6d8f5'
    latestFeaturedAt_new = latestFeaturedAt
    lastCursor_new = lastCursor
    while hasMore is True:
        response = get_products(token, lastCursor_new, latestFeaturedAt_new, hasMore)
        print(response)
        if len(response) != 0 and (response['data']['posts']['totalCount']) != 0:            
            #hasMore = False
            hasMore = (response['data']['posts']['pageInfo']['hasNextPage'])
            lastCursor_new = (response['data']['posts']['pageInfo']['endCursor'])
            latestFeatured = latestFeaturedAt_new
            count = (response['data']['posts']['totalCount'])
            if (count > 0):
                
                if len(latestFeaturedAt_new) == 0 or datetime.datetime.strptime(latestFeatured, "%Y-%m-%dT%H:%M:%SZ") < datetime.datetime.strptime((response['data']['posts']['edges'][0]['node']['featuredAt']), "%Y-%m-%dT%H:%M:%SZ"):
                    latestFeatured = (response['data']['posts']['edges'][0]['node']['featuredAt'])
                    latestFeatured = datetime.datetime.strptime(latestFeatured, "%Y-%m-%dT%H:%M:%SZ") 
                    latestFeatured += datetime.timedelta(seconds=1)
                    firstCursor_new = (response['data']['posts']['pageInfo']['startCursor'])
                    latestFeatured = datetime.datetime.strftime(latestFeatured, "%Y-%m-%dT%H:%M:%SZ")
                    latestFeatured = str(latestFeatured)
            insert = {"PRODUCTS":response}

            for key, value in insert.items():
                for index, each_item in enumerate(value['data']['posts']['edges']):
                    website = None if each_item['node']['website'] == '' else each_item['node']['website']
                
                    if website is not None:
                        try:
                            r = requests.get(website)
                            each_item['node']['actual_url'] = r.url
                        except:
                            each_item['node']['actual_url'] = website

                    data.append({"object_identifier": key, "content" : each_item})
        else:
            break
            
    n = 1000
    data  = [data[i:i+n] for i in range(0, len(data), n)]
    logging.info(f"Created {len(data)} chunks of whole data, each having {n} items.")
    proceed_so_far = 0

    for index, each_req in enumerate(data):
        post_already = False
        retry_count = 0
        while post_already == False:
            try:
                retry_count += 1
                req = requests.post(webhook_url, data=json.dumps(each_req), headers={'Content-type' : 'application/json'})
                validate_post(req)
                logging.info(f"Processed Chunk number {index} in {retry_count} try, message - {req.text}")
                post_already = True
            except Exception as e:
                logging.error(f"Something has failed for chunk {index} while dumping data to webhook, please see below error message, retry count is {retry_count} will retry again - {e}")

        proceed_so_far += n
        if proceed_so_far == 5000:
            logging.warning("Posted 5000 events, waiting for one second")
            time.sleep(60)
            proceed_so_far = 0

    #ph_config_file = Path(__file__).with_name('product_hunt.config')
    #with open(ph_config_file) as f:
    content = ['latestFeaturedAt=2024-07-03T00:10:22Z','lastCursor=','token=TWuVtrAdUwpPSp5mXf14EeT5ubIH2-btrGauQ7lVAMA']

    if hasMore is True:
        content = [f'lastCursor={lastCursor_new}' if  i.split('=')[0] == 'lastCursor' else i for i in content]
        
    elif hasMore is False:
        content = [f'latestFeaturedAt={latestFeatured}' if  i.split('=')[0] == 'latestFeaturedAt' else i for i in content]
        content = [f'lastCursor=' if  i.split('=')[0] == 'lastCursor' else i for i in content]
    
    #with open(ph_config_file, 'w') as f:
    #    for line in content:
    #        f.write(f"{line}\n")
        
def main():
    logger_config()
    logging.info(f"Reading product hunt config file from current directory, please make sure file exist in current directory and all the key value pairs are setup correctly. If not script will fail eventually. Good Luck!!")
    
    #ph_config_file = Path(__file__).with_name('product_hunt.config')
    
    #with open(ph_config_file) as f:
    content = ['latestFeaturedAt=2024-07-03T00:10:22Z','lastCursor=','token=TWuVtrAdUwpPSp5mXf14EeT5ubIH2-btrGauQ7lVAMA']
    
    ph_config_dict = {i.split('=')[0]:i.split('=')[1] for i in content}
    required_keys = ["latestFeaturedAt", "lastCursor", "token"]
     
    for i in required_keys:
        if i not in ph_config_dict:
            logging.error(f"key {i} and value pair is missing in dictionary, please make sure it exist in the config file, logging off for now.")
            sys.exit(1)
    
    resp = sub_main( ph_config_dict["token"], ph_config_dict["latestFeaturedAt"], ph_config_dict["lastCursor"])
    logging.info(f"Script Completed!!")
    
main()