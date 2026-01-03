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
     * Ambil semua pengaturan
     */
    public function show()
    {
        $settings = Setting::all()
            ->pluck('value', 'key');

        return response()->json($settings);
    }

    /**
     * PUT /admin/settings
     * Update banyak setting sekaligus
     */
    public function update(Request $request)
    {
        foreach ($request->all() as $key => $value) {
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
     * Regenerate JWT / APP KEY
     */
    public function regenerateJwt()
    {
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
}