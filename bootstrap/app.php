<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

use App\Http\Middleware\AdminMiddleware;
use App\Http\Middleware\RoleMiddleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php', // ⬅️ command DI SINI
        health: '/up',
    )

    ->withMiddleware(function (Middleware $middleware): void {

        /*
        |--------------------------------------------------------------------------
        | API Middleware (OTP butuh session)
        |--------------------------------------------------------------------------
        */
        $middleware->api(append: [
            \Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse::class,
            \Illuminate\Session\Middleware\StartSession::class,
        ]);

        /*
        |--------------------------------------------------------------------------
        | Middleware Alias
        |--------------------------------------------------------------------------
        */
        $middleware->alias([
            'admin' => AdminMiddleware::class,
            'role'  => RoleMiddleware::class,
        ]);

        /*
        |--------------------------------------------------------------------------
        | CSRF Exception (OTP)
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