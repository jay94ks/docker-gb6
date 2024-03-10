#!/usr/bin/php -q
<?php

/**
 * 이 스크립트는 CLI 환경에서만 실행됩니다.
 * 실제 동작 환경에는 PHP 서버 자체가 존재하지 않습니다.
 */

if (!is_dir('/app/volume')) {
    shell_exec('mkdir -pv /app/volume');
}

if (!is_file('/app/volume/.copied')) {
    shell_exec('cp -r /app/g6/* /app/volume/');
    shell_exec('cp -r /app/g6/.* /app/volume/');
    file_put_contents('/app/volume/.copied', date('Y-m-d H:i:s'));
}

chdir('/app/volume');
passthru(
    '/usr/bin/uvicorn main:app ' . 
    '--reload --host 0.0.0.0 --port 8000');
