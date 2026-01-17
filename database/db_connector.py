import pymysql
import MySQLdb
import os
from dotenv import load_dotenv

pymysql.install_as_MySQLdb()

load_dotenv()

# Database credentials stored in environment variables
host = os.environ.get("HOST")
port = os.environ.get("PORT")
user = os.environ.get("USER")
passwd = os.environ.get("PASSWORD")
db = os.environ.get("DB")


def connectDB(host=host, port=port, user=user, passwd=passwd, db=db):
    """
    connects to a database and returns a database object
    """
    dbConnection = MySQLdb.connect(
        host=host, port=int(port), user=user, passwd=passwd, db=db, ssl={"ssl": {}}
    )
    return dbConnection


def query(dbConnection=None, query=None, query_params=()):
    """
    executes a given SQL query on the given db connection and returns a Cursor object
    dbConnection: a MySQLdb connection object created by connectDB()
    query: string containing SQL query
    returns: A Cursor object as specified at https://www.python.org/dev/peps/pep-0249/#cursor-objects.
    You need to run .fetchall() or .fetchone() on that object to actually acccess the results.
    """

    if dbConnection is None:
        print("No connection to the database found! Have you called connectDB() first?")
        return None

    if query is None or len(query.strip()) == 0:
        print("query is empty! Please pass a SQL query in query")
        return None

    print("Executing %s with %s" % (query, query_params))
    # Create a cursor to execute query. Why? Because apparently they optimize execution by retaining a reference according to PEP0249
    cursor = dbConnection.cursor(MySQLdb.cursors.DictCursor)

    # Sanitize the query before executing it.
    cursor.execute(query, query_params)

    # Commit any changes to the database.
    dbConnection.commit()

    return cursor
