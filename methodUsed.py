import json
import re

# Load the JSON data
with open('achivements_with_version.json', 'r', encoding='utf-8') as f:
    achievements = json.load(f)


# word to method mapping
word_method_mapping = {
    'killing': 'killing',
    'slaying': 'killing',
    'using': 'using',
    'walking': 'walking',
    'harvesting': 'harvesting',
    'outfit': 'outfit',
    'kill': 'killing',
    'defeat': 'killing',
    'taming': 'mount',
    'catching': 'using',
    'changing': 'using',
    'steping': 'walking',
    'stepping': 'walking',
    'charging': 'using',
    
    'baking': 'baking',
    'skinning': 'skinning',
    'mount': 'mount',
    'task': 'task',
    
    'quest': 'inQuest',
    'event': 'inEvent',
    'world change': 'inWorldChange',

}



# Update each achievement with 'methodUsed' key
for achievement in achievements:
    spoiler = achievement.get('spoiler', '')

    method_used = None
    for word, method in word_method_mapping.items():
        if re.search(re.escape(word), spoiler, re.IGNORECASE):
            method_used = method
            break
    if method_used is None:
        method_used = 'other'
    achievement['methodUsed'] = method_used

# Save the updated data back to the file
with open('achivements_with_version.json', 'w', encoding='utf-8') as f:
    json.dump(achievements, f, ensure_ascii=False, indent=2)
    

