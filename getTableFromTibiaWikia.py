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
    # Check if the 'name' cell contains an <a> tag
    name_cell = cells[0]
    a_tag = name_cell.find('a')
    if a_tag and a_tag.has_attr('href'):
        entry['link'] = a_tag['href']
    else:
        entry['link'] = None
    data.append(entry)

with open('table.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)