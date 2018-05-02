"""
Simple python script to extract information from db of slant information

First script gets "slanttopic" and "viewpoint":
python data.py fetch slant_topics --show-progress

Second script gets pros and cons for each viewpoint:
python data.py fetch slant_pros_and_cons --show-progress
"""
import sqlite3

# Connect to DB
conn = sqlite3.connect("fetcher.db")

# Get table info
cur = conn.cursor()
cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
tables = cur.fetchall()
for table in tables:
    cur.execute("SELECT * FROM {}".format(table[0].encode('ascii', 'ignore')))
    table_len = len(cur.fetchall())

    # Only print non-empty tables
    if table_len > 0:
        print "Number of rows in " + table[0].encode('ascii', 'ignore') + \
         ": " + str(table_len)

# Get column information of viewpoint table
cur.execute("PRAGMA TABLE_INFO({})".format("viewpoint"))
viewpoint_names = [tup[1] for tup in cur.fetchall()]
print(viewpoint_names)

# Get column information of viewpointsection table
cur.execute("PRAGMA TABLE_INFO({})".format("viewpointsection"))
viewpointsection_names = [tup[1] for tup in cur.fetchall()]
print(viewpointsection_names)

# Get column information of slanttopic table
cur.execute("PRAGMA TABLE_INFO({})".format("slanttopic"))
slanttopic_names = [tup[1] for tup in cur.fetchall()]
print(slanttopic_names)

# Get data in column of viewpoint
cur.execute("SELECT * FROM viewpoint")
viewpoint_result = cur.fetchall()
print viewpoint_result[0]

# Get data in column of viewpointsection
cur.execute("SELECT * FROM viewpointsection")
viewpointsection_result = cur.fetchall()
print viewpointsection_result[0]

# Get data in column of slanttopic
cur.execute("SELECT * FROM slanttopic")
slanttopic_result = cur.fetchall()
print slanttopic_result[0]

print "\nEND OF DB INFO\n"

# Experimentation
print "QUESTION"
cur.execute("SELECT * FROM slanttopic WHERE title LIKE '%javascript%'")
result = cur.fetchall()
for temp in result:
    print temp[4].encode('ascii', 'ignore')
print "ANSWERS"
cur.execute("SELECT * FROM viewpoint WHERE topic_id LIKE {}".format(result[0][0]))
result = cur.fetchall()
for temp in result:
    print temp[5]

# for temp in result:
#     cur.execute("SELECT * FROM viewpointsection WHERE viewpoint_id LIKE {}".format(temp[3]))
#     print cur.fetchall()[0]

# print "COMBINE TABLES"
# # Combine tables
# cur.execute("SELECT * FROM viewpointsection JOIN viewpoint ON \
# viewpointsection.viewpoint_id = viewpoint.id JOIN slanttopic on viewpoint.topic_id = slanttopic.topic_id")
# result = cur.fetchall()
# print "Number of rows after combining tables: " + str(len(result))
# print result[0]
# print result[1]

# Close connection to DB
conn.close()
