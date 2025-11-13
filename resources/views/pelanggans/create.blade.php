<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tambah Pelanggan</title>
</head>
<body>
    <h1>Tambah Pelanggan Baru</h1>

    <form action="{{ route('pelanggans.store') }}" method="POST">
        @csrf
        <label>Nama:</label><br>
        <input type="text" name="nama" required><br>

        <label>Alamat:</label><br>
        <input type="text" name="alamat" required><br>

        <label>No HP:</label><br>
        <input type="text" name="no_hp" required><br>

        <label>Email:</label><br>
        <input type="email" name="email" required><br><br>

        <button type="submit">Simpan</button>
    </form>

    <a href="{{ route('pelanggans.index') }}">Kembali</a>
</body>
</html>
