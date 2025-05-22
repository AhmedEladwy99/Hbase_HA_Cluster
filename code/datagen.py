from faker import Faker
import happybase
import random
import time

connection = happybase.Connection('localhost')
table = connection.table('webpages')

fake = Faker()
domains = ['example.com', 'test.org', 'demo.net', 'site.edu', 'blog.info']

def generate_page(domain, page_id):
    url = f"https://{domain}/page{page_id}"
    row_key = f"{domain}!{url}"

    content_size = random.choice(['small', 'medium', 'large'])
    if content_size == 'small':
        content = fake.text(max_nb_chars=200)
    elif content_size == 'medium':
        content = fake.text(max_nb_chars=1000)
    else:
        content = fake.text(max_nb_chars=5000)

    creation_date = fake.date_time_between(start_date='-180d', end_date='now')
    creation_ts = int(time.mktime(creation_date.timetuple()))

    metadata = {
        b'metadata:title': fake.sentence(nb_words=6).encode(),
        b'metadata:created': str(creation_ts).encode(),
        b'metadata:http_status': str(random.choice([200, 404, 500])).encode(),
        b'metadata:content_size': str(len(content)).encode()
    }

    content_data = {
        b'content:html': content.encode()
    }

    outlinks = {}
    inlinks = {}

    linked_pages = random.sample(range(1, 21), k=random.randint(0, 5))
    for i, linked_page_id in enumerate(linked_pages):
        linked_url = f"https://{random.choice(domains)}/page{linked_page_id}"
        outlinks[f'outlinks:url{i}'.encode()] = linked_url.encode()
        inlinks[f'inlinks:url{i}'.encode()] = linked_url.encode()

    data = {}
    data.update(metadata)
    data.update(content_data)
    data.update(outlinks)
    data.update(inlinks)

    table.put(row_key.encode(), data)

for i in range(1, 21):
    domain = random.choice(domains)
    generate_page(domain, i)

print("Sample data inserted successfully.")
