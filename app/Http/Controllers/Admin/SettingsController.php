<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Setting;

class SettingsController extends Controller
{
    /**
     * =========================
     * GET /api/admin/settings
     * =========================
     */
    public function show(Request $request)
    {
        $this->ensureAdmin($request);

        // Default value jika DB kosong
        $defaults = [
            'wa_notification'       => true,
            'notification_timeout'  => 30,
            'enforce_https'         => true,
            'midtrans_enabled'      => false,
            'midtrans_key'          => null,
        ];

        $db = Setting::pluck('value', 'key')->toArray();

        return response()->json([
            'wa_notification' => filter_var(
                $db['wa_notification'] ?? $defaults['wa_notification'],
                FILTER_VALIDATE_BOOLEAN
            ),

            'notification_timeout' => (int) (
                $db['notification_timeout'] ?? $defaults['notification_timeout']
            ),

            'enforce_https' => filter_var(
                $db['enforce_https'] ?? $defaults['enforce_https'],
                FILTER_VALIDATE_BOOLEAN
            ),

            'midtrans_enabled' => filter_var(
                $db['midtrans_enabled'] ?? $defaults['midtrans_enabled'],
                FILTER_VALIDATE_BOOLEAN
            ),

            'midtrans_key' => $db['midtrans_key'] ?? null,
        ]);
    }

    /**
     * =========================
     * PUT /api/admin/settings
     * =========================
     */
    public function update(Request $request)
    {
        $this->ensureAdmin($request);

        $allowedKeys = [
            'wa_notification',
            'notification_timeout',
            'enforce_https',
            'midtrans_enabled',
        ];

        foreach ($request->only($allowedKeys) as $key => $value) {
            Setting::updateOrCreate(
                ['key' => $key],
                ['value' => (string) $value]
            );
        }

        return response()->json([
            'message' => 'Pengaturan berhasil diperbarui'
        ]);
    }

    /**
     * =========================
     * POST /api/admin/settings/regenerate-jwt
     * =========================
     */
    public function regenerateJwt(Request $request)
    {
        $this->ensureAdmin($request);

        $newKey = 'base64:' . base64_encode(random_bytes(32));

        Setting::updateOrCreate(
            ['key' => 'jwt_secret'],
            ['value' => $newKey]
        );

        return response()->json([
            'message' => 'JWT Secret berhasil diperbarui'
        ]);
    }

    /**
     * =========================
     * GUARD
     * =========================
     */
    private function ensureAdmin(Request $request): void
    {
        if ($request->user()->role !== 'admin') {
            abort(403, 'Forbidden');
        }
    }
}