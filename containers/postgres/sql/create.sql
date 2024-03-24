BEGIN;

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL,
    CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

CREATE TABLE users (
    user_id SERIAL NOT NULL,
    name VARCHAR(64) NOT NULL,
    surname VARCHAR(64) NOT NULL,
    PRIMARY KEY (user_id)
);

INSERT INTO alembic_version (version_num) VALUES ('ec5ddda825ce') RETURNING alembic_version.version_num;

COMMIT;