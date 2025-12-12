<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

// Tambahkan ini
use App\Http\Middleware\AdminMiddleware;
use App\Http\Middleware\RoleMiddleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )

    ->withMiddleware(function (Middleware $middleware): void {

        /*
        |--------------------------------------------------------------------------
        | Session untuk API (dibutuhkan Flutter login OTP)
        |--------------------------------------------------------------------------
        */
        $middleware->api(append: [
            \Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse::class,
            \Illuminate\Session\Middleware\StartSession::class,
        ]);


        /*
        |--------------------------------------------------------------------------
        | Register Middleware Alias
        |--------------------------------------------------------------------------
        */
        $middleware->alias([
            'admin' => AdminMiddleware::class,
            'role' => RoleMiddleware::class, // opsional
        ]);


        /*
        |--------------------------------------------------------------------------
        | CSRF Exceptions (untuk web)
        |--------------------------------------------------------------------------
        */
        $middleware->validateCsrfTokens(except: [
            'send-otp',
            'verify-otp',
        ]);
    })

    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })

    ->create();
