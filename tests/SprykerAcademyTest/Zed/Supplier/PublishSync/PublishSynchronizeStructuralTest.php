<?php

declare(strict_types=1);

namespace SprykerAcademyTest\Zed\Supplier\PublishSync;

use Codeception\Test\Unit;

/**
 * Structural tests for the Publish & Synchronize exercise.
 * Verifies the SupplierSearch, SupplierStorage, and DataImport modules
 * have the required classes, methods, schemas, and behaviors.
 *
 * Run: vendor/bin/codecept run -c tests/SprykerAcademyTest/Zed/Supplier/ PublishSync
 */
class PublishSynchronizeStructuralTest extends Unit
{
    // --- SupplierSearch Constants ---

    public function testSupplierSearchConfigHasRequiredConstants(): void
    {
        $class = 'SprykerAcademy\Shared\SupplierSearch\SupplierSearchConfig';
        $this->assertTrue(class_exists($class), 'SupplierSearchConfig must exist.');
        $this->assertTrue(defined("$class::SUPPLIER_PUBLISH"), 'Must have SUPPLIER_PUBLISH constant.');
        $this->assertTrue(defined("$class::SUPPLIER_PUBLISH_SEARCH_QUEUE"), 'Must have publish queue constant.');
        $this->assertTrue(defined("$class::SUPPLIER_SYNC_SEARCH_QUEUE"), 'Must have sync queue constant.');
        $this->assertTrue(defined("$class::ENTITY_PYZ_SUPPLIER_CREATE"), 'Must have entity create constant.');
        $this->assertTrue(defined("$class::ENTITY_PYZ_SUPPLIER_UPDATE"), 'Must have entity update constant.');
    }

    // --- SupplierStorage Constants ---

    public function testSupplierStorageConfigHasRequiredConstants(): void
    {
        $class = 'SprykerAcademy\Shared\SupplierStorage\SupplierStorageConfig';
        $this->assertTrue(
            class_exists($class) || interface_exists($class),
            'SupplierStorageConfig must exist.',
        );
    }

    // --- SupplierSearch Writer ---

    public function testSupplierSearchWriterExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierSearch\Business\Writer\SupplierSearchWriter';
        $this->assertTrue(class_exists($class), 'SupplierSearchWriter must exist.');
        $this->assertTrue(
            method_exists($class, 'writeCollectionBySupplierEvents'),
            'Must have writeCollectionBySupplierEvents() method.',
        );
    }

    // --- SupplierSearch Facade ---

    public function testSupplierSearchFacadeExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierSearch\Business\SupplierSearchFacade';
        $this->assertTrue(class_exists($class), 'SupplierSearchFacade must exist.');
        $this->assertTrue(
            method_exists($class, 'writeCollectionBySupplierEvents'),
            'Facade must expose writeCollectionBySupplierEvents().',
        );
    }

    // --- SupplierSearch Publisher Plugin ---

    public function testSupplierSearchWritePublisherPluginExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierSearch\Communication\Plugin\Publisher\SupplierSearchWritePublisherPlugin';
        $this->assertTrue(class_exists($class), 'SupplierSearchWritePublisherPlugin must exist.');
        $this->assertTrue(method_exists($class, 'handleBulk'), 'Must have handleBulk() method.');
        $this->assertTrue(method_exists($class, 'getSubscribedEvents'), 'Must have getSubscribedEvents() method.');
    }

    public function testSupplierSearchPluginSubscribesToCorrectEvents(): void
    {
        $plugin = new \SprykerAcademy\Zed\SupplierSearch\Communication\Plugin\Publisher\SupplierSearchWritePublisherPlugin();
        $events = $plugin->getSubscribedEvents();

        $this->assertNotEmpty($events, 'Plugin must subscribe to at least one event.');
        $this->assertContains(
            \SprykerAcademy\Shared\SupplierSearch\SupplierSearchConfig::SUPPLIER_PUBLISH,
            $events,
            'Must subscribe to SUPPLIER_PUBLISH event.',
        );
        $this->assertContains(
            \SprykerAcademy\Shared\SupplierSearch\SupplierSearchConfig::ENTITY_PYZ_SUPPLIER_CREATE,
            $events,
            'Must subscribe to entity create event.',
        );
    }

    // --- SupplierSearch DependencyProvider ---

    public function testSupplierSearchDependencyProviderExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierSearch\SupplierSearchDependencyProvider';
        $this->assertTrue(class_exists($class), 'SupplierSearchDependencyProvider must exist.');
        $this->assertTrue(defined("$class::FACADE_EVENT_BEHAVIOR"), 'Must have FACADE_EVENT_BEHAVIOR constant.');
        $this->assertTrue(defined("$class::FACADE_SUPPLIER"), 'Must have FACADE_SUPPLIER constant.');
    }

    // --- SupplierSearch Factory ---

    public function testSupplierSearchBusinessFactoryExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierSearch\Business\SupplierSearchBusinessFactory';
        $this->assertTrue(class_exists($class), 'SupplierSearchBusinessFactory must exist.');
        $this->assertTrue(
            method_exists($class, 'createSupplierSearchWriter'),
            'Must have createSupplierSearchWriter() method.',
        );
    }

    // --- SupplierStorage Writer ---

    public function testSupplierStorageWriterExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierStorage\Business\Writer\SupplierStorageWriter';
        $this->assertTrue(class_exists($class), 'SupplierStorageWriter must exist.');
        $this->assertTrue(
            method_exists($class, 'writeCollectionBySupplierEvents'),
            'Must have writeCollectionBySupplierEvents() method.',
        );
    }

    // --- SupplierStorage Facade ---

    public function testSupplierStorageFacadeExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierStorage\Business\SupplierStorageFacade';
        $this->assertTrue(class_exists($class), 'SupplierStorageFacade must exist.');
        $this->assertTrue(
            method_exists($class, 'writeCollectionBySupplierEvents'),
            'Facade must expose writeCollectionBySupplierEvents().',
        );
    }

    // --- SupplierStorage Publisher Plugin ---

    public function testSupplierStorageWritePublisherPluginExists(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierStorage\Communication\Plugin\Publisher\SupplierStorageWritePublisherPlugin';
        $this->assertTrue(class_exists($class), 'SupplierStorageWritePublisherPlugin must exist.');
        $this->assertTrue(method_exists($class, 'handleBulk'), 'Must have handleBulk().');
        $this->assertTrue(method_exists($class, 'getSubscribedEvents'), 'Must have getSubscribedEvents().');
    }

    // --- Schema: Event Behavior on pyz_supplier ---

    public function testSupplierSchemaHasEventBehavior(): void
    {
        $path = $this->findSchemaPath('pyz_supplier.schema.xml');
        $this->assertNotNull($path, 'pyz_supplier.schema.xml must exist.');

        $xml = simplexml_load_file($path);
        $behaviors = $xml->xpath("//table[@name='pyz_supplier']/behavior[@name='event']");
        $this->assertCount(1, $behaviors, 'pyz_supplier must have the event behavior.');
    }

    // --- Schema: Synchronization Behavior on pyz_supplier_search ---

    public function testSupplierSearchSchemaHasSynchronizationBehavior(): void
    {
        $path = $this->findSchemaPath('pyz_supplier_search.schema.xml');
        $this->assertNotNull($path, 'pyz_supplier_search.schema.xml must exist.');

        $xml = simplexml_load_file($path);
        $behaviors = $xml->xpath("//table[@name='pyz_supplier_search']/behavior[@name='synchronization']");
        $this->assertCount(1, $behaviors, 'pyz_supplier_search must have the synchronization behavior.');

        $resourceParam = $xml->xpath("//table[@name='pyz_supplier_search']/behavior[@name='synchronization']/parameter[@name='resource']");
        $this->assertCount(1, $resourceParam, 'Synchronization must have a resource parameter.');
        $this->assertSame('supplier', (string)$resourceParam[0]['value'], 'Resource must be "supplier".');

        $queueParam = $xml->xpath("//table[@name='pyz_supplier_search']/behavior[@name='synchronization']/parameter[@name='queue_group']");
        $this->assertCount(1, $queueParam, 'Must have queue_group parameter.');
    }

    // --- Schema: Synchronization Behavior on pyz_supplier_storage ---

    public function testSupplierStorageSchemaHasSynchronizationBehavior(): void
    {
        $path = $this->findSchemaPath('pyz_supplier_storage.schema.xml');
        $this->assertNotNull($path, 'pyz_supplier_storage.schema.xml must exist.');

        $xml = simplexml_load_file($path);
        $behaviors = $xml->xpath("//table[@name='pyz_supplier_storage']/behavior[@name='synchronization']");
        $this->assertCount(1, $behaviors, 'pyz_supplier_storage must have the synchronization behavior.');
    }

    // --- DataImport: PublishAwareStep ---

    public function testSupplierWriterStepExtendsPublishAwareStep(): void
    {
        $class = 'SprykerAcademy\Zed\SupplierDataImport\Business\DataImportStep\SupplierWriterStep';
        $this->assertTrue(class_exists($class), 'SupplierWriterStep must exist.');

        $parentClass = 'Spryker\Zed\DataImport\Business\Model\DataImportStep\PublishAwareStep';
        if (class_exists($parentClass)) {
            $this->assertTrue(
                is_subclass_of($class, $parentClass),
                'SupplierWriterStep must extend PublishAwareStep for manual event triggering.',
            );
        }
    }

    // --- Helpers ---

    private function findSchemaPath(string $filename): ?string
    {
        $patterns = [
            __DIR__ . '/../../../../../src/SprykerAcademy/Zed/*/Persistence/Propel/Schema/' . $filename,
            getcwd() . '/src/SprykerAcademy/Zed/*/Persistence/Propel/Schema/' . $filename,
        ];

        foreach ($patterns as $pattern) {
            $matches = glob($pattern);
            if ($matches) {
                return $matches[0];
            }
        }

        return null;
    }
}
