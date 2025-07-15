import json

# Paths to your JSON files
json_86_path = "8.6/tibia_items.json"
json_87_path = "8.7/tibia_items.json"

# Load both JSON files
with open(json_86_path, "r", encoding="utf-8") as f:
    data_86 = json.load(f)
with open(json_87_path, "r", encoding="utf-8") as f:
    data_87 = json.load(f)

# Get sets of item_ids for both versions
ids_86 = {item["item_id"] for item in data_86["items"]}
ids_87 = {item["item_id"] for item in data_87["items"]}

# Find new items in 8.7
new_ids = ids_87 - ids_86

# Get the full item data for new items
new_items = [item for item in data_87["items"] if item["item_id"] in new_ids]

# Print or save the result
print(f"New items in 8.7 (count: {len(new_items)}):")
for item in new_items:
    #only print item_id;
    print(item["item_id"])



#lets also check, for items that were modified
modified_items = []
for item in data_87["items"]:
    item_id = item["item_id"]
    if item_id in ids_86:
        # Check if the item has been modified
        old_item = next((i for i in data_86["items"] if i["item_id"] == item_id), None)
        if old_item and old_item != item:
            modified_items.append(item)

print(f"Modified items in 8.7 (count: {len(modified_items)}):")
for item in modified_items:
    #only print item_id;
    print(item["item_id"])


# load the [
    # {
    #     "100": "void"
    # },
    # {
    #     "101": "earth"
    # },

# from tibia_13_21_13810_asset_names.json

with open("tibia_13_21_13810_asset_names.json", "r", encoding="utf-8") as f:
    asset_names = json.load(f)
# Create a mapping from item_id to asset name
asset_name_map = {int(k): v for item in asset_names for k, v in item.items()}
# Print the asset names and names for new items
print("Asset names and names for new items:")
for item in new_items:
    item_id = item["item_id"]
    asset_name = asset_name_map.get(item_id, "Unknown")
    name = item.get("name", "Unknown")
    print(f"Item ID: {item_id}, Name: {name}, Asset Name: {asset_name}")

# Save the new items to a JSON file, including asset name and name
for item in new_items:
    item["asset_name"] = asset_name_map.get(item["item_id"], "Unknown")
    item["name"] = item.get("name", "Unknown")

with open("new_items_8.7.json", "w", encoding="utf-8") as f:
    json.dump(new_items, f, ensure_ascii=False, indent=2)


# Save the modified items to a JSON file, including asset name and name
for item in modified_items:
    item["asset_name"] = asset_name_map.get(item["item_id"], "Unknown")
    item["name"] = item.get("name", "Unknown")
with open("modified_items_8.7.json", "w", encoding="utf-8") as f:
    json.dump(modified_items, f, ensure_ascii=False, indent=2)