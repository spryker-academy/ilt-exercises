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

## Step 3: Register Exercise Packages

Enter the Docker CLI and register the exercise package repositories:

```bash
docker/sdk cli
```

Then run these two commands inside the CLI:

```bash
composer config repositories.hello-world git https://github.com/spryker-academy/hello-world.git
composer config repositories.supplier git https://github.com/spryker-academy/supplier.git
```

You only need to do this **once** per project setup.

---

## How Exercises Work

Each exercise is distributed as a Composer package with **two versions**:

- **skeleton** - Contains TODO stubs for you to implement
- **complete** - Contains the full solution (use only to check your work)

There are two packages:

| Package | Covers |
|---------|--------|
| `spryker-academy/hello-world` | Modules 1-4 (Basics) |
| `spryker-academy/supplier` | Modules 4-11 (Basics + Intermediate) |

All `composer` and `console` commands should be run **inside the Docker CLI** (`docker/sdk cli`).

---

## Exercise Progression

### Part 1: Basics (Hello World)

#### Module 1: Hello World Back Office

Install the skeleton:

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/hello-world-back-office/skeleton" --ignore-platform-reqs
```

Your task: Implement a Zed controller and Twig template to display a "Hello World" page in the Back Office.

Files to work on are in: `vendor/spryker-academy/hello-world/src/SprykerAcademy/Zed/HelloWorld/`

When done, check against the solution:

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/hello-world-back-office/complete" --ignore-platform-reqs
```

---

#### Module 2: Data Transfer Objects

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/data-transfer-object/skeleton" --ignore-platform-reqs
```

Your task: Define transfer objects for the HelloWorld module.

Check the solution:

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/data-transfer-object/complete" --ignore-platform-reqs
```

After modifying transfer XML files, generate transfers:

```bash
console transfer:generate
```

---

#### Module 3: Message Table Schema

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/message-table-schema/skeleton" --ignore-platform-reqs
```

Your task: Define the Propel database schema for the message table.

Check the solution:

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/message-table-schema/complete" --ignore-platform-reqs
```

After modifying schema XML files, run:

```bash
console propel:install
console transfer:generate
```

---

#### Module 4: Module Layers

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/module-layers/skeleton" --ignore-platform-reqs
```

Your task: Implement the full module layer architecture (Business, Persistence, Communication, Client, Yves).

Check the solution:

```bash
composer require "spryker-academy/hello-world:dev-ilt/202512.0/basics/module-layers/complete" --ignore-platform-reqs
```

---

### Part 2: Basics (Supplier - Table Schema)

#### Module 4b: Supplier Table Schema

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/basics/supplier-table-schema/skeleton" --ignore-platform-reqs
```

Your task: Define the Propel database schema for supplier tables.

After modifying schema XML files:

```bash
console propel:install
console transfer:generate
```

---

### Part 3: Intermediate (Supplier)

#### Module 6: Back Office (CRUD)

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/back-office/skeleton" --ignore-platform-reqs
```

Your task: Build the Back Office GUI for managing suppliers (list, create, edit, delete).

Check the solution:

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/back-office/complete" --ignore-platform-reqs
```

---

#### Module 7: Data Import

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/data-import/skeleton" --ignore-platform-reqs
```

Your task: Implement data importers for suppliers and supplier locations.

Check the solution:

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/data-import/complete" --ignore-platform-reqs
```

After implementing, run the import:

```bash
console data:import
```

---

#### Module 8: Publish & Synchronize

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/publish-synchronize/skeleton" --ignore-platform-reqs
```

Your task: Implement event publishing and synchronization for supplier data to storage/search.

Check the solution:

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/publish-synchronize/complete" --ignore-platform-reqs
```

After implementing:

```bash
console event:trigger
console queue:worker:start
```

---

#### Module 9: Search

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/search/skeleton" --ignore-platform-reqs
```

Your task: Implement Elasticsearch integration for supplier search.

Check the solution:

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/search/complete" --ignore-platform-reqs
```

---

#### Module: Storage Client

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/storage-client/skeleton" --ignore-platform-reqs
```

Your task: Implement the Client layer to read supplier data from Redis storage.

Check the solution:

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/storage-client/complete" --ignore-platform-reqs
```

---

#### Module 10: Glue Storefront API

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/glue-storefront/skeleton" --ignore-platform-reqs
```

Your task: Build a Glue API resource for exposing supplier data to storefront applications.

Check the solution:

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/glue-storefront/complete" --ignore-platform-reqs
```

After implementing:

```bash
console glue-api:controller:cache:warm-up
```

---

#### Module 11: Order Management System (OMS)

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/oms/skeleton" --ignore-platform-reqs
```

Your task: Define OMS states, transitions, events, conditions, and commands in `config/Zed/oms/Demo01.xml` and implement the OMS plugins.

Check the solution:

```bash
composer require "spryker-academy/supplier:dev-ilt/202512.0/intermediate/oms/complete" --ignore-platform-reqs
```

---

## Common Commands Reference

Run these inside `docker/sdk cli`:

| Command | When to use |
|---------|-------------|
| `console transfer:generate` | After modifying `.transfer.xml` files |
| `console propel:install` | After modifying `.schema.xml` files |
| `console data:import` | After implementing data importers |
| `console event:trigger` | To trigger publish & sync events |
| `console queue:worker:start` | To process queued messages |
| `console search:setup:sources` | After modifying search schemas |
| `console glue-api:controller:cache:warm-up` | After adding Glue API resources |
| `console router:cache:warm-up` | After adding new route providers |
| `console navigation:build-cache` | After modifying navigation XML |

## Switching Between Exercises

When moving to the next exercise, simply run the corresponding `composer require` command inside `docker/sdk cli`. Composer will replace the package contents with the new version automatically.

If you need to start an exercise fresh, re-run the skeleton `composer require` command.

## Troubleshooting

**"Package not found" error:**
Make sure you ran the repository setup commands (Step 3):

```bash
composer config repositories.hello-world git https://github.com/spryker-academy/hello-world.git
composer config repositories.supplier git https://github.com/spryker-academy/supplier.git
```

**Transfer/Propel errors after switching versions:**
Always regenerate after switching:

```bash
console propel:install
console transfer:generate
```

**Cache issues:**
```bash
console cache:empty-all
```
