<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: sans-serif; font-size: 12px; }
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #333; padding: 6px; }
        th { background: #eee; }
        .total { text-align: right; font-weight: bold; margin-top: 15px; }
    </style>
</head>
<body>

<h2>Laporan Keuangan KSM Tanjung</h2>
<p>Periode: {{ $periode }}</p>

<table>
    <thead>
        <tr>
            <th>Tanggal</th>
            <th>Pelanggan</th>
            <th>Tagihan</th>
            <th>Jumlah</th>
        </tr>
    </thead>
    <tbody>
        @foreach ($payments as $p)
        <tr>
            <td>{{ $p->created_at->format('d-m-Y') }}</td>
            <td>{{ $p->tagihan->pelanggan->nama ?? '-' }}</td>
            <td>#{{ $p->tagihan_id }}</td>
            <td>Rp {{ number_format($p->jumlah_bayar, 0, ',', '.') }}</td>
        </tr>
        @endforeach
    </tbody>
</table>

<p class="total">
    Total Pendapatan: Rp {{ number_format($total, 0, ',', '.') }}
</p>

</body>
</html>