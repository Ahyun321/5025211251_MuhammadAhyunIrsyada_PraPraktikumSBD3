CREATE TABLE customer (
  id_customer char(6) NOT NULL,
  nama_customer varchar(100) NOT NULL,
  PRIMARY KEY (id_customer)
);

INSERT INTO customer (id_customer, nama_customer) VALUES
('CTR001', 'Budi Santoso'),
('CTR002', 'Sisil Triana'),
('CTR003', 'Davi Liam'),
('CTR004', 'Sutris Ten An'),
('CTR005', 'Hendra Asto');

CREATE TABLE pegawai (
  nik char(16) NOT NULL,
  nama_pegawai varchar(100) NOT NULL,
  jenis_kelamin char(1) DEFAULT NULL,
  email varchar(50) DEFAULT NULL,
  umur int(11) NOT NULL,
  telepon varchar(15) NOT NULL,
  PRIMARY KEY (nik)
);

INSERT INTO pegawai (nik, nama_pegawai, jenis_kelamin, email, umur, telepon) VALUES
('1111222233334444', 'Maimunah', 'P', 'maimunah@gmail.com', '25', '621234567'),
('1234567890123456', 'Naufal Raf', 'L', 'naufal@gmail.com', '19', '62123456789'),
('2345678901234561', 'Surinala', 'P', 'surinala@gmail.com', '24', '621234567890'),
('3456789012345612', 'Ben John', 'L', 'benjohn@gmail.com', '22', '6212345678');


CREATE TABLE menu_minuman (
  id_minuman char(6) NOT NULL,
  nama_minuman varchar(50) NOT NULL,
  harga_minuman float NOT NULL,
  PRIMARY KEY (id_minuman)
);

INSERT INTO menu_minuman (id_minuman, nama_minuman, harga_minuman) VALUES
('MNM001', 'Expresso', '18000'),
('MNM002', 'Cappucino', '20000'),
('MNM003', 'Latte', '21000'),
('MNM004', 'Americano', '19000'),
('MNM005', 'Mocha', '22000'),
('MNM006', 'Macchiato', '23000'),
('MNM007', 'Cold Brew', '21000'),
('MNM008', 'Iced Coffe', '18000'),
('MNM009', 'Affogato', '23000'),
('MNM010', 'Coffe Frappe', '22000');

CREATE TABLE membership (
  id_membership char(6) NOT NULL,
  no_telp_customer varchar(15) NOT NULL,
  alamat_customer varchar(150) DEFAULT NULL,
  tanggal_pembuatan date DEFAULT NULL,
  tanggal_kedaluwarsa date DEFAULT NULL,
  total_poin int(11) NOT NULL,
  m_id_customer char(6) NOT NULL,
  PRIMARY KEY (id_membership),
  FOREIGN KEY (m_id_customer) REFERENCES customer(id_customer)
);

INSERT INTO membership (id_membership, no_telp_customer, alamat_customer, tanggal_pembuatan, tanggal_kedaluwarsa, total_poin, m_id_customer) VALUES
('MBR001', '08123456789', 'Jl. Imam Bonjol', '2023-10-24', '2023-11-30', '0', 'CTR001'),
('MBR002', '0812345678', 'Jl. Kelinci', '2023-10-24', '2023-11-30', '0', 'CTR002'),
('MBR003', '081234567890', 'Jl. Abah Ojak', '2023-10-25', '2023-12-01', '2', 'CTR003'),
('MBR004', '08987654321', 'Jl. Kenangan', '2023-10-26', '2023-12-02', '6', 'CTR005');

CREATE TABLE transaksi (
  id_transaksi char(10) NOT NULL,
  tanggal_transaksi date NOT NULL,
  metode_pembayaran varchar(15) NOT NULL,
  customer_id_customer char(6) NOT NULL,
  pegawai_nik char(16) NOT NULL,
  PRIMARY KEY (id_transaksi),
  FOREIGN KEY (customer_id_customer) REFERENCES customer(id_customer),
  FOREIGN KEY (pegawai_nik) REFERENCES pegawai(nik)
);

INSERT INTO transaksi (id_transaksi, tanggal_transaksi, metode_pembayaran, customer_id_customer, pegawai_nik) VALUES
('TRX0000001', '2023-10-01', 'Kartu kredit', 'CTR002', '2345678901234561'),
('TRX0000002', '2023-10-03', 'Transfer bank', 'CTR004', '3456789012345612'),
('TRX0000003', '2023-10-05', 'Tunai', 'CTR001', '3456789012345612'),
('TRX0000004', '2023-10-15', 'Kartu debit', 'CTR003', '1234567890123456'),
('TRX0000005', '2023-10-15', 'E-wallet', 'CTR004', '1234567890123456'),
('TRX0000006', '2023-10-21', 'Tunai', 'CTR001', '2345678901234561'),
('TRX0000007', '2023-10-03', 'Transfer bank', 'CTR004', '2345678901234561');

CREATE TABLE transaksi_minuman (
tm_menu_minuman_id char(6) NOT NULL,
tm_transaksi_id char(10) NOT NULL,
jumlah_minuman INTEGER NOT NULL,
FOREIGN KEY (tm_menu_minuman_id) REFERENCES menu_minuman(id_minuman),
FOREIGN KEY (tm_transaksi_id) REFERENCES transaksi(id_transaksi)
);

INSERT INTO transaksi_minuman (tm_menu_minuman_id, tm_transaksi_id, jumlah_minuman) VALUES
('MNM001', 'TRX0000003', 3),
('MNM001', 'TRX0000005', 1),
('MNM003', 'TRX0000002', 2),
('MNM003', 'TRX0000003', 1),
('MNM003', 'TRX0000006', 2),
('MNM004', 'TRX0000004', 2),
('MNM005', 'TRX0000002', 1),
('MNM005', 'TRX0000007', 1),
('MNM006', 'TRX0000005', 2),
('MNM007', 'TRX0000001', 1),
('MNM009', 'TRX0000005', 1),
('MNM010', 'TRX0000001', 1),
('MNM010', 'TRX0000004', 1);

SELECT *
FROM transaksi
WHERE tanggal_transaksi BETWEEN '2023-10-10' AND '2023-10-20';

--2 

SELECT id_minuman, SUM(harga_minuman) AS TOTAL_HARGA
FROM menu_minuman
GROUP BY id_minuman;

--3

SELECT
    c.id_customer,
    c.nama_customer,
    COALESCE(SUM(mm.harga_minuman * tm.jumlah_minuman), 0) AS Total_Belanja
FROM
    customer c
LEFT JOIN
    transaksi t ON c.id_customer = t.customer_id_customer AND t.tanggal_transaksi BETWEEN '2023-10-03' AND '2023-10-22'
LEFT JOIN
    transaksi_minuman tm ON t.id_transaksi = tm.tm_transaksi_id
LEFT JOIN
    menu_minuman mm ON tm.tm_menu_minuman_id = mm.id_minuman
GROUP BY
    c.id_customer, c.nama_customer
ORDER BY
    c.nama_customer ASC;

--4

SELECT
    p.nik,
    p.nama_pegawai
FROM
    pegawai p
JOIN
    transaksi t ON p.nik = t.pegawai_nik
JOIN
    customer c ON t.customer_id_customer = c.id_customer
WHERE
    c.nama_customer IN ('Davi Liam', 'Sisil Triana', 'Hendra Asto');

--5

SELECT
    MONTH(t.tanggal_transaksi) AS BULAN,
    YEAR(t.tanggal_transaksi) AS TAHUN,
    SUM(tm.jumlah_minuman) AS JUMLAH_CUP
FROM
    transaksi t
JOIN
    transaksi_minuman tm ON t.id_transaksi = tm.tm_transaksi_id
JOIN
    menu_minuman mm ON tm.tm_menu_minuman_id = mm.id_minuman
WHERE
    mm.nama_minuman = 'Kopi Nuri'
GROUP BY
    BULAN, TAHUN
ORDER BY
    TAHUN DESC, BULAN ASC;

--6

SELECT
    AVG(COALESCE(total_belanja, 0)) AS Rata_rata_Total_Belanja
FROM (
    SELECT
        c.id_customer,
        COALESCE(SUM(mm.harga_minuman * tm.jumlah_minuman), 0) AS total_belanja
    FROM
        customer c
    LEFT JOIN
        transaksi t ON c.id_customer = t.customer_id_customer
    LEFT JOIN
        transaksi_minuman tm ON t.id_transaksi = tm.tm_transaksi_id
    LEFT JOIN
        menu_minuman mm ON tm.tm_menu_minuman_id = mm.id_minuman
    GROUP BY
        c.id_customer
) AS total_belanja_per_customer;

--7 
SELECT
    c.id_customer,
    c.nama_customer,
    COALESCE(SUM(mm.harga_minuman * tm.jumlah_minuman), 0) AS total_belanja
FROM
    customer c
LEFT JOIN
    transaksi t ON c.id_customer = t.customer_id_customer
LEFT JOIN
    transaksi_minuman tm ON t.id_transaksi = tm.tm_transaksi_id
LEFT JOIN
    menu_minuman mm ON tm.tm_menu_minuman_id = mm.id_minuman
GROUP BY
    c.id_customer, c.nama_customer
HAVING
    total_belanja > (SELECT AVG(COALESCE(total_belanja, 0)) FROM (
                        SELECT COALESCE(SUM(mm.harga_minuman * tm.jumlah_minuman), 0) AS total_belanja
                        FROM transaksi t
                        LEFT JOIN transaksi_minuman tm ON t.id_transaksi = tm.tm_transaksi_id
                        LEFT JOIN menu_minuman mm ON tm.tm_menu_minuman_id = mm.id_minuman
                        GROUP BY t.customer_id_customer
                    ) AS rata_rata_total_belanja);

--8 

SELECT
    c.id_customer,nama_customer
FROM
    customer c
LEFT JOIN
    membership m ON c.id_customer = m.m_id_customer
WHERE
    m.id_membership IS NULL;

--9

SELECT
    COUNT(DISTINCT c.id_customer) AS Jumlah_Customer_Pemesan_Latte
FROM
    customer c
JOIN
    transaksi t ON c.id_customer = t.customer_id_customer
JOIN
    transaksi_minuman tm ON t.id_transaksi = tm.tm_transaksi_id
JOIN
    menu_minuman mm ON tm.tm_menu_minuman_id = mm.id_minuman
WHERE
    mm.nama_minuman = 'Latte';

--10

SELECT
    c.nama_customer,
    mm.nama_minuman,
    SUM(tm.jumlah_minuman) AS Total_Jumlah_Cup
FROM
    customer c
JOIN
    transaksi t ON c.id_customer = t.customer_id_customer
JOIN
    transaksi_minuman tm ON t.id_transaksi = tm.tm_transaksi_id
JOIN
    menu_minuman mm ON tm.tm_menu_minuman_id = mm.id_minuman
WHERE
    c.nama_customer LIKE 'S%'
GROUP BY
    c.nama_customer, mm.nama_minuman;
