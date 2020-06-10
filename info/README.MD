----1-psql----
1. install psql (https://docs.google.com/document/d/1g2FLZ2ps2HdQB_23t4hKP83hwZRXj4ZjWhnqo-MtCt4/edit)
2. psql -d postgres -U postgres
3. CREATE ROLE my_user WITH LOGIN PASSWORD 'root';
4. ALTER ROLE my_user CREATEDB;
5. \q
6. psql -d postgres -U my_user
7. CREATE DATABASE detox;
8. \c detox;
9. GRANT ALL PRIVILEGES ON DATABASE detox to my_user;

And fill database
exit psql "\q"

----2-USAGE----
1. first connect server ("node index.js" in server folder)
2. then you can start react ("npm start" in react-postgres folder)
3. Note: every time you make changes in server, you have to restart it
4. restart server: stop with "^C", NOT with "^Z". Then "node index.js"


Links:
https://blog.logrocket.com/getting-started-with-postgres-in-your-react-app/
VIDEO:
https://youtu.be/l6Vy93xNZ4k
