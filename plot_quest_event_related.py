import json
from collections import Counter
import numpy as np

import matplotlib.pyplot as plt

# Load data from JSON file
with open('achivements_with_version.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

    # Prepare data
    versions = []
    quest_related = []
    event_related = []
    neither_related = []
    mini_world_change_related = []

    # Group data by version
    version_groups = {}
    for item in data:
        version = item.get('version', 'Unknown')
        if version not in version_groups:
            version_groups[version] = {'quest': 0, 'event': 0, 'neither': 0, 'miniWorldChange': 0}
        if item.get('questRelated', False):
            version_groups[version]['quest'] += 1
        elif item.get('eventRelated', False):
            version_groups[version]['event'] += 1
        elif item.get('miniWorldChangeRelated', False):
            version_groups[version]['miniWorldChange'] += 1
        else:
            version_groups[version]['neither'] += 1

    # Sort versions for plotting
    # sorted_versions = sorted(version_groups.keys())
    for version in version_groups.keys():
        versions.append(version)
        quest_related.append(version_groups[version]['quest'])
        event_related.append(version_groups[version]['event'])
        neither_related.append(version_groups[version]['neither'])
        mini_world_change_related.append(version_groups[version]['miniWorldChange'])


    # Plot stacked bar chart
    ind = np.arange(len(versions))
    width = 0.6

    p1 = plt.bar(ind, quest_related, width, label='Quest Related', color='#4daf4a')
    p2 = plt.bar(ind, event_related, width, bottom=quest_related, label='Event Related', color='#377eb8')
    bottoms = np.array(quest_related) + np.array(event_related)
    p3 = plt.bar(ind, neither_related, width, bottom=bottoms, label='Neither', color='#e41a1c')
    p4 = plt.bar(ind, mini_world_change_related, width, bottom=bottoms + np.array(neither_related), label='Mini World Change Related', color='#ff7f00')

    plt.ylabel('Count')
    plt.xlabel('Version')
    plt.title('Achievements by Version and Relation')
    plt.xticks(ind, versions, rotation=45)
    plt.legend()
    plt.tight_layout()
    plt.show()