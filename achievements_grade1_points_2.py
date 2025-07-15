import json

# Load data from the JSON file
with open('achivements_with_version.json', 'r', encoding='utf-8') as f:
    achievements = json.load(f)

# Filter achievements with grade == 1 and points == 2
filtered = [a for a in achievements if a.get('grade') == 1 and a.get('points') == 2]

# Save the filtered achievements to a new JSON file
with open('achievements_grade1_points_2.json', 'w', encoding='utf-8') as f:
    json.dump(filtered, f, ensure_ascii=False, indent=2)