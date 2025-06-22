import json
import re

# Load the JSON data
with open('achivements_with_version.json', 'r', encoding='utf-8') as f:
    achievements = json.load(f)

# Update each achievement with 'questRelated' key
for achievement in achievements:

    spoiler = achievement.get('spoiler', '')
    if re.search(r'world\s*change', spoiler, re.IGNORECASE):
        achievement['miniWorldChangeRelated'] = True
        achievement['questRelated'] = False
        achievement['eventRelated'] = False
    else:
        achievement['miniWorldChangeRelated'] = False
    
    spoiler = achievement.get('spoiler', '')
    if re.search(r'quest', spoiler, re.IGNORECASE):
        achievement['questRelated'] = True
    else:
        achievement['questRelated'] = False

# update each achievvement with 'eventRelated' key
    spoiler = achievement.get('spoiler', '')
    if re.search(r'event', spoiler, re.IGNORECASE):
        achievement['eventRelated'] = True
    else:
        achievement['eventRelated'] = False

# update each achievvement with 'miniWorldChangeRelated' key


    # Save the updated data back to the file
with open('achivements_with_version.json', 'w', encoding='utf-8') as f:
    json.dump(achievements, f, ensure_ascii=False, indent=2)
