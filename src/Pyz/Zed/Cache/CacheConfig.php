<?php

/**
 * This file is part of the Spryker Commerce OS.
 * For full license information, please view the LICENSE file that was distributed with this source code.
 */

declare(strict_types=1);

namespace Pyz\Zed\Cache;

use Spryker\Zed\Cache\CacheConfig as SprykerCacheConfig;

class CacheConfig extends SprykerCacheConfig
{
    /**
     * Specification:
     * - Defines project specific cache paths that should be cleared.
     * - Includes Symfony application caches for all applications (Glue, GlueStorefront, GlueBackend, Zed, Yves).
     *
     * @api
     *
     * @return array<string>
     */
    public function getProjectSpecificCache(): array
    {
        return [
            APPLICATION_ROOT_DIR . '/data/cache/Glue',
            APPLICATION_ROOT_DIR . '/data/cache/GlueStorefront',
            APPLICATION_ROOT_DIR . '/data/cache/GlueBackend',
            APPLICATION_ROOT_DIR . '/data/cache/Zed',
            APPLICATION_ROOT_DIR . '/data/cache/Yves',
        ];
    }
}
