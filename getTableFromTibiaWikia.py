import json
from bs4 import BeautifulSoup

with open('table.html', 'r', encoding='utf-8') as f:
    soup = BeautifulSoup(f, 'html.parser')

columns = ['name', 'id', 'secret', 'grade', 'points', 'description', 'spoiler']
data = []

for row in soup.find_all('tr'):
    cells = row.find_all(['td', 'th'])
    if len(cells) != len(columns):
        continue
    entry = {col: cell.get_text(strip=True) for col, cell in zip(columns, cells)}
    # For 'grade', set value to count of <span> inside the cell
    grade_cell = cells[3]
    entry['grade'] = len(grade_cell.find_all('span'))

    try:
        entry["id"] = int(cells[1].get_text(strip=True))
    except ValueError:
        entry["id"] = None



    # Extract spoiler text, preserving only left-side spaces
    spoiler_cell = cells[6]
    text = ''.join(spoiler_cell.strings)
    entry['spoiler'] = ' '.join(text.lstrip().split())

    # Check if the 'name' cell contains an <a> tag
    try:
        entry["points"] = int(cells[4].get_text(strip=True))
    except ValueError:
        entry["points"] = None
    name_cell = cells[0]
    entry['secret'] = '✗' not in cells[2].get_text(strip=True).lower()
    a_tag = name_cell.find('a')
    if a_tag and a_tag.has_attr('href'):
        entry['link'] = "https://tibia.fandom.com" + a_tag['href']
    else:
        entry['link'] = None
    data.append(entry)



with open('table.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)