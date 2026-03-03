# Spryker Academy ILT Exercises

## Project Overview

This is a Spryker training project for instructor-led training (ILT). Students complete progressive exercises to learn Spryker fundamentals. The project consists of three repos:

- **ilt-exercises** (this repo): The Spryker demo shop project where students work
- **hello-world** (`packages/hello-world`): Exercise source code with branches per exercise (basics)
- **supplier** (`packages/supplier`): Exercise source code with branches per exercise (intermediate)
- **instructor-exercises** (`packages/instructor-exercises`): `load.sh` script, exercise guides, tests, presentation

## Repository Locations

```
/Users/hidranarias/spryker/courses/ilt/
├── ilt-exercises/              # Main Spryker project (this repo)
├── packages/
│   ├── hello-world/            # git@github.com-spryker:spryker-academy/hello-world.git
│   ├── supplier/               # git@github.com-spryker:spryker-academy/supplier.git
│   └── instructor-exercises/   # https://github.com/spryker-academy/instructor-exercises
```

## Hello-World Package (Basics)

### Branch Structure

Every branch is a single orphan commit, authored by `Hidran Arias <hidran.arias@spryker.com>`.

| Branch | Content |
|--------|---------|
| `basics/hello-world-back-office/skeleton` | Ex 1 skeleton |
| `basics/hello-world-back-office/complete` | Ex 1 complete |
| `basics/data-transfer-object/skeleton` | Ex 2 skeleton |
| `basics/data-transfer-object/complete` | Ex 2 complete |
| `basics/message-table-schema/skeleton` | Ex 3 skeleton |
| `basics/message-table-schema/complete` | Ex 3 complete |
| `basics/module-layers/skeleton` | Ex 4+5 skeleton |
| `basics/module-layers/complete` | Ex 4+5 complete |
| `basics/extending-core-modules/skeleton` | Ex 7 skeleton |
| `basics/extending-core-modules/complete` | Ex 7 complete |
| `basics/extending-core-modules/complete-ajax` | Ex 7 AJAX variant |
| `basics/configuration/complete` | Ex 6 complete (no skeleton) |
| `main` | All exercises complete, all tests |

### Key Source Files (namespace: `SprykerAcademy`)

- **Shared**: `HelloWorldConstants.php`, `Transfer/helloworld.transfer.xml`
- **Zed Controllers**: `HelloController` (Ex 1), `MessageController` (Ex 4), `GatewayController` (Ex 5), `ConfigController` (Ex 6)
- **Zed Business**: `MessageReader`, `MessageWriter`, `MessageDeleter`, `HelloWorldFacade`, `HelloWorldBusinessFactory`
- **Zed Persistence**: `HelloWorldRepository`, `HelloWorldEntityManager`, `MessageMapper`, `pyz_message.schema.xml`
- **Client**: `HelloWorldStub` (uses `ZedRequestClientInterface`)
- **Yves HelloWorldPage**: `MessageController`, `HelloWorldPageRouteProviderPlugin`
- **Yves CustomerPage** (Ex 7): `MessageController`, `MessageAsyncController`, `MessageForm`, `CustomerPageRouteProviderPlugin`, `CustomerPageFactory`, `CustomerPageDependencyProvider`

### Exercise 7: Extending Core Modules - Customer Messages

- Schema: `pyz_message` with `fk_customer` FK to `spy_customer`, composite unique `(message, fk_customer)`, timestampable behavior
- Transfer: `Message` (idMessage, message, fkCustomer, createdAt), `MessageCriteria`, `MessageCollection`, `MessageResponse`
- Full CRUD: create + delete messages via Client/Stub/GatewayController
- SOLID: Separate `MessageReader`, `MessageWriter`, `MessageDeleter` classes
- Yves: Extends SprykerShop's `CustomerPage` module (DependencyProvider, Factory, Controller, RouteProviderPlugin)
- Forms: Data-mapped `MessageForm` bound to `MessageTransfer`, form factory chain via `createCustomerFormFactory()->getFormFactory()->create()`
- Navigation: Override `navigation-sidebar.twig` with "My Messages" link
- Router: Override `RouterDependencyProvider` with extended `CustomerPageRouteProviderPlugin`
- AJAX variant (`complete-ajax`): `MessageAsyncController` + Spryker AJAX trio (ajax-provider, ajax-form-submitter, ajax-renderer)
- Controller patterns: `castId()` for safe ID handling, `setFkCustomerOrFail()` for strict validation
- Tests: 30 structural + mock + SOLID tests in Exercise7 suite

### Test Structure

Tests live in `tests/SprykerAcademyTest/Zed/HelloWorld/` with per-exercise suites:

| Suite | Tests | Approach |
|-------|-------|----------|
| Exercise1 | 5 | Structural: reflection, class_exists |
| Exercise2 | 4 | XML parsing: SimpleXML + XPath on helloworld.transfer.xml |
| Exercise3 | 9 | XML parsing: SimpleXML on pyz_message.schema.xml |
| Exercise4 | 3 | Unit: mock Repository/EntityManager interfaces |
| Exercise5 | 2 | Unit: mock ZedRequestClientInterface |
| Exercise6 | 11 | Structural: reflection on Constants, Config, Factory, Controller |
| Exercise7 | 30 | Structural + mock + XML + SOLID enforcement |

Tests use `Codeception\Test\Unit` — no Spryker kernel bootstrap needed.

## Supplier Package (Intermediate)

### Branch Structure

| Branch | Content |
|--------|---------|
| `intermediate/data-import/skeleton` | Ex 8 skeleton |
| `intermediate/data-import/complete` | Ex 8 complete |
| `intermediate/back-office/skeleton` | Ex 9 skeleton |
| `intermediate/back-office/complete` | Ex 9 complete |
| `intermediate/publish-synchronize/skeleton` | Ex 10 skeleton |
| `intermediate/publish-synchronize/complete` | Ex 10 complete |
| `intermediate/search/skeleton` | Ex 11 skeleton |
| `intermediate/search/complete` | Ex 11 complete |
| `intermediate/storage-client/skeleton` | Ex 12 skeleton |
| `intermediate/storage-client/complete` | Ex 12 complete |
| `intermediate/glue-storefront/skeleton` | Ex 13 skeleton |
| `intermediate/glue-storefront/complete` | Ex 13 complete |
| `intermediate/oms/skeleton` | Ex 14 skeleton |
| `intermediate/oms/complete` | Ex 14 complete |
| `main` | All exercises complete |

### Modules

- **Supplier**: Core business logic (Reader, Writer, Facade, Repository, EntityManager)
- **SupplierLocation**: Related entity (1:N to Supplier)
- **SupplierGui**: Back Office CRUD (Table, Form, Controllers)
- **SupplierDataImport**: CSV import with WriterSteps, PublishAwareStep
- **SupplierSearch**: Publish to Elasticsearch (Writer, PublisherPlugin, Propel sync behavior)
- **SupplierStorage**: Publish to Redis (Writer, PublisherPlugin, SynchronizationDataPlugin)
- **Client/SupplierSearch**: Elasticsearch query/result plugins
- **Client/SupplierStorage**: Redis storage reader
- **Glue/Supplier**: REST API endpoints
- **Yves/SupplierPage**: Storefront page for supplier search
- **Oms**: State machine integration

### Test Suites (lightweight, no kernel needed)

| Suite | Tests | What |
|-------|-------|------|
| DataImport | 20 | Constants, steps, factory, facade, plugins, CSV validation |
| BackOffice | 20 | Table, controllers, form, factory, DP, navigation, templates |
| PublishSync | 15 | Writer, facade, plugin events, schema behaviors, PublishAwareStep |
| Search | 13 | Query plugin, result formatter, client, factory, ES schema |

### Publish & Synchronize Configuration

Requires entries in THREE config files:
1. `src/Pyz/Client/SymfonyMessenger/SymfonyMessengerConfig.php` — transport routing
2. `src/Pyz/Client/RabbitMq/RabbitMqConfig.php` — AMQP queue declaration
3. `src/Pyz/Zed/Queue/QueueDependencyProvider.php` — queue processors

Plus: `docker/sdk console messenger:setup-transports` to create AMQP exchanges.

## Instructor-Exercises Package

### Structure

```
guides/
  basics/
    00-spryker-backend-best-practices.md
    01-hello-world-back-office.md
    02-data-transfer-object.md
    03-message-table-schema.md
    04-module-layers-back-office.md
    05-module-layers-storefront.md
    06-configuration.md
    07-extending-core-modules.md
  intermediate/
    01-data-import.md
    02-back-office.md
    03-publish-synchronize.md
    04-search.md
  spryker-academy-exercises-presentation.html
load.sh
STUDENT_SETUP_GUIDE.md
```

### load.sh Behavior

1. Clones/fetches the exercise repo into `exercises/repos/<package>/`
2. Checks out the requested branch
3. Copies `src/SprykerAcademy/` to project
4. Copies `src/Pyz/` overrides if present
5. Copies `tests/SprykerAcademyTest/` and adds PSR-4 autoload-dev mapping
6. For `hello-world`: injects `HelloWorldConstants` into `config_default.php`
7. For `supplier`: copies CSVs, navigation.xml, OMS config
8. For `supplier`: injects plugins into `DataImportDependencyProvider`, `PublisherDependencyProvider`, `QueueDependencyProvider`
9. For `supplier`: registers queues in `RabbitMqConfig` and `SymfonyMessengerConfig`
10. For `supplier`: creates RabbitMQ queues + exchanges via management API

### Running Tests

```bash
# Hello-world exercises
docker/sdk cli vendor/bin/codecept run -c tests/SprykerAcademyTest/Zed/HelloWorld/ Exercise7

# Supplier exercises
docker/sdk cli vendor/bin/codecept run -c tests/SprykerAcademyTest/Zed/Supplier/ DataImport
docker/sdk cli vendor/bin/codecept run -c tests/SprykerAcademyTest/Zed/Supplier/ BackOffice
docker/sdk cli vendor/bin/codecept run -c tests/SprykerAcademyTest/Zed/Supplier/ PublishSync
docker/sdk cli vendor/bin/codecept run -c tests/SprykerAcademyTest/Zed/Supplier/ Search
```

## Conventions

- **Author/committer**: `Hidran Arias <hidran.arias@spryker.com>` for all commits
- **Branch squashing**: Each branch = 1 orphan commit (use `git commit-tree` + `git update-ref`)
- **Push**: Always `git push --force --all origin` after squashing
- **Spryker 202512.0+**: Uses Symfony Messenger for queues (not direct RabbitMQ)
- **Namespace**: `SprykerAcademy\` for all exercise code
- **Docker commands**: `docker/sdk cli` for PHP, `docker/sdk console` for Spryker console
- **CSVs**: No ID columns (id_supplier, id_supplier_location) — IDs are auto-generated
- **Guide style**: Hints and patterns only, never copy-paste solutions
- **Spryker buttons**: Use `generateEditButton()`, `generateRemoveButton()` in tables; `{{ createActionButton() }}`, `{{ backActionButton() }}` in Twig
- **Forms**: Data-mapped to transfers via factory chain `createCustomerFormFactory()->getFormFactory()->create()`
- **Queue setup**: After adding queues, run `docker/sdk console messenger:setup-transports`
