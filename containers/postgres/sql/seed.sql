BEGIN;

insert into users(name, surname) values('Jan1', 'Kowalski');

insert into users(name, surname) values('Jan2', 'Kowalski');

insert into users(name, surname) values('Jan3', 'Kowalski');

UPDATE alembic_version SET version_num='d26fafd3a01b' WHERE alembic_version.version_num = 'ec5ddda825ce';

COMMIT;
