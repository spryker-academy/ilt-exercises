<?php
define('APPLICATION', 'ZED');
define('APPLICATION_ROOT_DIR', __DIR__);
define('APPLICATION_CODE_BUCKET', 'EU');
define('APPLICATION_ENV', 'dockerdev');

require 'vendor/autoload.php';

$locator = \Spryker\Zed\Kernel\Locator::getInstance();
$eventFacade = $locator->event()->facade();

$transfer = new \Generated\Shared\Transfer\EventEntityTransfer();
$transfer->setId(1);

echo "Triggering SupplierSearch.supplier.publish...\n";
$eventFacade->triggerBulk('SupplierSearch.supplier.publish', [$transfer]);
echo "Done.\n";
