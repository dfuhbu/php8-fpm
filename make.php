<?php
$content = file_get_contents('Dockerfile');
$content = preg_replace_callback('/INCLUDE\((?<filename>[^)]+)\)/m', static function (array $matches) {
    return '# ' . $matches['filename'] . PHP_EOL
        . file_get_contents($matches['filename']) . PHP_EOL
        . '#';
}, $content);

echo $content, PHP_EOL;