<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Pelanggan</title>
</head>
<body>
    <h1>Edit Pelanggan</h1>

    <form action="{{ route('pelanggans.update', $pelanggan->id) }}" method="POST">
        @csrf
        @method('PUT')

        <label>Nama:</label><br>
        <input type="text" name="nama" value="{{ $pelanggan->nama }}" required><br>

        <label>Alamat:</label><br>
        <input type="text" name="alamat" value="{{ $pelanggan->alamat }}" required><br>

        <label>No HP:</label><br>
        <input type="text" name="no_hp" value="{{ $pelanggan->no_hp }}" required><br>

        <label>Email:</label><br>
        <input type="email" name="email" value="{{ $pelanggan->email }}" required><br><br>

        <button type="submit">Update</button>
    </form>

    <a href="{{ route('pelanggans.index') }}">Kembali</a>
</body>
</html>
