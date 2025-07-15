import json

with open('new_items_8.7.json', 'r', encoding='utf-8') as f:
    items = json.load(f)

min_items = [
    {"item_id": item["item_id"], "asset_name": item["asset_name"]}
    for item in items
]

with open('min_items_8.7.json', 'w', encoding='utf-8') as f:
    json.dump(min_items, f, ensure_ascii=False, indent=2)