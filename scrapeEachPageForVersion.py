import json
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import requests
import re

import concurrent.futures

#https://tibia.fandom.com/api.php?action=query&format=json&titles={link}&prop=revisions&rvprop=content&rvslots=main&origin=*

# Load table.json
with open('table.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

def extract_title_from_name(name):
    # Remove leading slash and decode URL if needed
    return name.lstrip('/').replace('_', ' ')

def batch_query_versions(objs, batch_size=50):
    base_url = "https://tibia.fandom.com/api.php"
    results = []
    for i in range(0, len(objs), batch_size):
        batch = objs[i:i+batch_size]
        titles = "|".join([extract_title_from_name(obj['name']) for obj in batch])
        params = {
            "action": "query",
            "format": "json",
            "titles": titles,
            "prop": "revisions",
            "rvprop": "content",
            "rvslots": "main",
            "origin": "*"
        }
        response = requests.get(base_url, params=params)
        data = response.json()
        pages = data.get("query", {}).get("pages", {})
        title_to_version = {}
        for page in pages.values():
            title = page.get("title")
            revisions = page.get("revisions", [])
            version = None
            if revisions:
                content = revisions[0].get("slots", {}).get("main", {}).get("*", "")
                match = re.search(r"\|\s*implemented\s*=\s*([^\n|]+)", content)
                if match:
                    version = match.group(1).strip()
            title_to_version[title] = version
        for obj in batch:
            title = extract_title_from_name(obj['name'])
            obj['version'] = title_to_version.get(title)
            print(f"{obj['name']}: {obj['version']}")
            results.append(obj)
    return results

results = batch_query_versions(data)

results.append({
    'name': 'Smart Thinking',
    'id': 195,
    'secret': True,  # replace with the actual secret if needed
    'grade': '',
    'points': '',
    'description': '',
    'spoiler': '',
    'version': "8.70",
    'link': None
})

#sort by id
results.sort(key=lambda x: int(str(x['id'])) if str(x['id']).isdigit() else float('inf'))

with open('achivements_with_version.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)





