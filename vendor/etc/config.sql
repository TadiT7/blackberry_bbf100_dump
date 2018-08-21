--
-- File generated with SQLiteStudio v3.0.7 on Thu Jan 7 15:25:32 2016
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: configdata
CREATE TABLE configdata (
    "source" TEXT,
    "dataowner" TEXT,
    "property" TEXT,
    "value" TEXT,
    "version" TEXT,
    "conflictindex" TEXT,
    "propertystate" TEXT,
    "modified" TEXT,
    "txnid" TEXT,
    "extra1" TEXT,
    "extra2" TEXT,
    "extra3" TEXT,
    "extra4" TEXT
, "uri" TEXT);

-- Table: history
CREATE TABLE history (
    "datetime" TEXT,
    "description" TEXT,
    "tag" TEXT
);

-- Table: conflict
CREATE TABLE conflict (
    "conflict" INTEGER,
    "priority" INTEGER,
    "condition" TEXT,
    "subject" TEXT,
    "verb" TEXT,
    "target" TEXT
);

-- Table: state
CREATE TABLE "state" (
    "key" TEXT,
    "value" TEXT
);

-- Table: breadcrumb
CREATE TABLE "breadcrumb" (
    "datetime" TEXT,
    "description" TEXT
);

-- Index: property
CREATE UNIQUE INDEX "property" on configdata (source ASC, property ASC);

-- Index: stateindex
CREATE UNIQUE INDEX "stateindex" on state (key ASC);

-- Index: primary
CREATE UNIQUE INDEX "primary" on conflict (conflict ASC, priority ASC);

-- View: dump
CREATE VIEW "dump" AS select * from configdata;

-- View: showhistory
CREATE VIEW "showhistory" AS select * from history;

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
