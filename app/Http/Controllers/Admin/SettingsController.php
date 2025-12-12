<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function show()
    {
        // return config settings (dummy)
    }

    public function update(Request $request)
    {
        // update setting (WA notif, timeout, dll)
    }

    public function regenerateJwt()
    {
        // generate JWT secret baru (dummy)
        return response()->json(['message' => 'JWT regenerated']);
    }
}
