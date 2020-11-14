Asi se hace un dump de la base de datos:
pg_dump postgres://u1gp8rb4538t6l:p7076e86ae8520f4875ca0ff255c8c5c66aabf13f4a01e7650327a243ad35c483@ec2-18-210-201-193.compute-1.amazonaws.com:5432/daubsivlv0pqmv -f dump.sql
Asi se hace un restore de la base de datos
psql postgres://zmzlqcphnapeix:8d15a06fd88cdd79be00e7fad2e46701e3052b587bf6e26453898467bff4bf26@ec2-23-21-238-28.compute-1.amazonaws.com:5432/da1ji60e4pq33a < dump.sql


psql postgres://ahixdomzabntdn:4ed6ae1287a8e156de4360273e1b3e230466d5969fbe377c4fea2dfacc693a22@ec2-23-23-245-89.compute-1.amazonaws.com:5432/daucikifs6jg2d < dump.sql
