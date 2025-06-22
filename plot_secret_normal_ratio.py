import json
from collections import Counter
import numpy as np

import matplotlib.pyplot as plt

# Load data from JSON file
with open('achivements_with_version.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Group achievements by version

# Count number of achievements per version
version_counts = Counter(item['version'] for item in data)

# Prepare data for plotting
def version_key(v):
    return [int(part) if part.isdigit() else part for part in v.split('.')]

all_versions = sorted(set(version_counts.keys()).union(
    item['version'] for item in data if item['secret'] == '✓'
), key=version_key)

all_counts = [version_counts.get(v, 0) for v in all_versions]

# Count number of secret achievements per version
secret_achievements = [item for item in data if item['secret'] == '✓']
secret_version_counts = Counter(item['version'] for item in secret_achievements)
secret_counts = [secret_version_counts.get(v, 0) for v in all_versions]

# Create stacked bar plot (dual color in one bar)
x = np.arange(len(all_versions))
width = 0.6

plt.figure(figsize=(12, 7))
plt.bar(x, all_counts, width, label='All Achievements', color='skyblue')
plt.bar(x, secret_counts, width, label='Secret Achievements', color='orange')

plt.bar(x, secret_counts, width, label='Secret Achievements', color='orange')
plt.bar(x, np.array(all_counts) - np.array(secret_counts), width, bottom=secret_counts, label='Non-Secret Achievements', color='skyblue')

plt.xlabel('Update Version')
plt.ylabel('Number of Achievements')
plt.title('Number of Achievements by Update Version (Secret vs Non-Secret)')
plt.xticks(x, all_versions, rotation=45)
plt.legend()
plt.tight_layout()
plt.show()
