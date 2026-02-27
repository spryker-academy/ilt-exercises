# Spryker Backend Developer Training - Student Setup Guide

## Prerequisites

- Docker Desktop installed and running
- Git installed

---

## Step 1: Clone the Exercise Project

```bash
git clone git@github.com:spryker-academy/ilt-exercises.git
cd ilt-exercises
```

## Step 2: Boot the Docker Environment

```bash
docker/sdk boot deploy.dev.yml
docker/sdk up
```

Wait for all services to be ready. This may take several minutes on first run.

---

## Loading Exercises

Use the `exercises/load.sh` script to load any exercise. It handles everything automatically: cloning repos, switching branches, copying files into `src/`, and configuring the project.

```bash
./exercises/load.sh <package> <branch>
```

After loading, run inside `docker/sdk cli`:

```bash
composer dump-autoload
console transfer:generate
console propel:install
```

---

## Exercise Progression

### Part 1: Basics (Hello World)

#### Module 1: Hello World Back Office

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/hello-world-back-office/skeleton
```

Your task: Implement a Zed controller and Twig template to display a "Hello World" page in the Back Office.

Files to work on: `src/SprykerAcademy/Zed/HelloWorld/`

Check the solution:

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/hello-world-back-office/complete
```

---

#### Module 2: Data Transfer Objects

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/data-transfer-object/skeleton
```

Your task: Define transfer objects for the HelloWorld module.

After modifying transfer XML files, run inside `docker/sdk cli`:

```bash
console transfer:generate
```

Check the solution:

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/data-transfer-object/complete
```

---

#### Module 3: Message Table Schema

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/message-table-schema/skeleton
```

Your task: Define the Propel database schema for the message table.

After modifying schema XML files, run inside `docker/sdk cli`:

```bash
console propel:install
console transfer:generate
```

Check the solution:

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/message-table-schema/complete
```

---

#### Module 4: Module Layers

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/module-layers/skeleton
```

Your task: Implement the full module layer architecture (Business, Persistence, Communication, Client, Yves).

Check the solution:

```bash
./exercises/load.sh hello-world ilt/202512.0/basics/module-layers/complete
```

---

### Part 2: Basics (Supplier - Table Schema)

#### Module 4b: Supplier Table Schema

```bash
./exercises/load.sh supplier ilt/202512.0/basics/supplier-table-schema/skeleton
```

Your task: Define the Propel database schema for supplier tables.

After modifying schema XML files, run inside `docker/sdk cli`:

```bash
console propel:install
console transfer:generate
```

---

### Part 3: Intermediate (Supplier)

#### Module 6: Back Office (CRUD)

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/back-office/skeleton
```

Your task: Build the Back Office GUI for managing suppliers (list, create, edit, delete).

Check the solution:

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/back-office/complete
```

---

#### Module 7: Data Import

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/data-import/skeleton
```

Your task: Implement data importers for suppliers and supplier locations.

After implementing, run inside `docker/sdk cli`:

```bash
console data:import
```

Check the solution:

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/data-import/complete
```

---

#### Module 8: Publish & Synchronize

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/publish-synchronize/skeleton
```

Your task: Implement event publishing and synchronization for supplier data to storage/search.

After implementing, run inside `docker/sdk cli`:

```bash
console event:trigger
console queue:worker:start
```

Check the solution:

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/publish-synchronize/complete
```

---

#### Module 9: Search

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/search/skeleton
```

Your task: Implement Elasticsearch integration for supplier search.

Check the solution:

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/search/complete
```

---

#### Module: Storage Client

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/storage-client/skeleton
```

Your task: Implement the Client layer to read supplier data from Redis storage.

Check the solution:

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/storage-client/complete
```

---

#### Module 10: Glue Storefront API

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/glue-storefront/skeleton
```

Your task: Build a Glue API resource for exposing supplier data to storefront applications.

After implementing, run inside `docker/sdk cli`:

```bash
console glue-api:controller:cache:warm-up
```

Check the solution:

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/glue-storefront/complete
```

---

#### Module 11: Order Management System (OMS)

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/oms/skeleton
```

Your task: Define OMS states, transitions, events, conditions, and commands in `config/Zed/oms/Demo01.xml` and implement the OMS plugins.

Check the solution:

```bash
./exercises/load.sh supplier ilt/202512.0/intermediate/oms/complete
```

---

## Common Commands Reference

Run these inside `docker/sdk cli`:

| Command | When to use |
|---------|-------------|
| `composer dump-autoload` | After loading a new exercise |
| `console transfer:generate` | After modifying `.transfer.xml` files |
| `console propel:install` | After modifying `.schema.xml` files |
| `console data:import` | After implementing data importers |
| `console event:trigger` | To trigger publish & sync events |
| `console queue:worker:start` | To process queued messages |
| `console search:setup:sources` | After modifying search schemas |
| `console glue-api:controller:cache:warm-up` | After adding Glue API resources |
| `console router:cache:warm-up` | After adding new route providers |
| `console navigation:build-cache` | After modifying navigation XML |

## Troubleshooting

**Script says "not found" or permission denied:**
```bash
chmod +x exercises/load.sh
```

**Transfer/Propel errors after switching exercises:**
Always regenerate after switching (inside `docker/sdk cli`):

```bash
composer dump-autoload
console propel:install
console transfer:generate
```

**Cache issues:**
```bash
console cache:empty-all
```

**List available branches:**
```bash
./exercises/load.sh
```
