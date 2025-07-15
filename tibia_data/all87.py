import json


json_87_path = "8.7/tibia_items.json"


with open(json_87_path, "r", encoding="utf-8") as f:
    data_87 = json.load(f)

ids_87 = {item["item_id"] for item in data_87["items"]}

# Find new items in 8.7
new_ids = ids_87

# Get the full item data for new items
new_items = [item for item in data_87["items"] if item["item_id"] in new_ids]




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

with open("items_8.7.json", "w", encoding="utf-8") as f:
    json.dump(new_items, f, ensure_ascii=False, indent=2)
