<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Setting;
use Illuminate\Support\Str;

class SettingsController extends Controller
{
    /**
     * GET /admin/settings
     */
    public function show(Request $request)
    {
        $this->ensureAdmin($request);

        return response()->json(
            Setting::pluck('value', 'key')
        );
    }

    /**
     * PUT /admin/settings
     */
    public function update(Request $request)
    {
        $this->ensureAdmin($request);

        // 🔒 Hanya key yang diizinkan
        $allowedKeys = [
            'app_name',
            'contact_phone',
            'contact_email',
            'payment_note',
        ];

        foreach ($request->only($allowedKeys) as $key => $value) {
            Setting::updateOrCreate(
                ['key' => $key],
                ['value' => $value]
            );
        }

        return response()->json([
            'message' => 'Pengaturan berhasil diperbarui'
        ]);
    }

    /**
     * POST /admin/settings/regenerate-jwt
     */
    public function regenerateJwt(Request $request)
    {
        $this->ensureAdmin($request);

        $newKey = 'base64:' . base64_encode(
            random_bytes(32)
        );

        Setting::updateOrCreate(
            ['key' => 'jwt_secret'],
            ['value' => $newKey]
        );

        return response()->json([
            'message' => 'JWT Secret berhasil diperbarui'
        ]);
    }

    /**
     * ======================
     * GUARD
     * ======================
     */
    private function ensureAdmin(Request $request): void
    {
        if ($request->user()->role !== 'admin') {
            abort(403, 'Forbidden');
        }
    }
}