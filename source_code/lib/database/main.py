# conda activate webservicep2plending webservicep2plending
# uvicorn main:app --reload


from pydantic import BaseModel
from typing import Union
from fastapi import FastAPI, Response, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import sqlite3
from typing import Optional
import random
import string

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# panggil sekali saja


@app.get("/init/")
def init_db():
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        create_table = """ CREATE TABLE user(
            id_user INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            foto_profile TEXT,
            role TEXT NOT NULL,
            token_verifikasi TEXT,
            saldo_dana INTEGER NOT NULL
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE umkm(
            id_umkm INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_umkm TEXT NOT NULL,
            deskripsi TEXT,
            omset INTEGER NOT NULL,
            lokasi TEXT NOT NULL,
            kategori TEXT NOT NULL,
            kelas TEXT NOT NULL,
            tahun_berdiri INTEGER NOT NULL,
            id_user_borrower INTEGER NOT NULL,
            FOREIGN KEY (id_user_borrower) REFERENCES user(id_user)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE pinjaman(
            id_pinjaman INTEGER PRIMARY KEY AUTOINCREMENT,
            judul_pinjaman TEXT NOT NULL,
            link_vidio TEXT NOT NULL,
            jumlah_pinjaman INTEGER NOT NULL,
            return_keuntungan INTEGER NOT NULL,
            lama_pinjaman    INTEGER NOT NULL,
            status TEXT NOT NULL,
            tanggal_pengajuan TEXT NOT NULL,
            id_umkm INTEGER NOT NULL,
            id_user_borrower INTEGER NOT NULL,
            FOREIGN KEY (id_umkm) REFERENCES umkm(id_umkm),
            FOREIGN KEY (id_user_borrower) REFERENCES user(id_user)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE investasi(
            id_investasi INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal_investasi TEXT NOT NULL,
            id_pinjaman INTEGER NOT NULL,
            id_user_lender INTEGER NOT NULL,
            FOREIGN KEY (id_pinjaman) REFERENCES pinjaman(id_pinjaman),
            FOREIGN KEY (id_user_lender) REFERENCES user(id_user)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE chat(
            id_chat INTEGER PRIMARY KEY AUTOINCREMENT,
            isi_chat TEXT NOT NULL,
            tanggal_chat TEXT NOT NULL,
            status TEXT NOT NULL,
            id_user_pengirim INTEGER NOT NULL,
            id_user_penerima INTEGER NOT NULL,
            FOREIGN KEY (id_user_pengirim) REFERENCES user(id_user),
            FOREIGN KEY (id_user_penerima) REFERENCES user(id_user)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE pengembalian(
            id_pengembalian INTEGER PRIMARY KEY AUTOINCREMENT,
            id_investasi INTEGER NOT NULL,
            id_transaksi INTEGER NOT NULL,
            id_user_lender INTEGER NOT NULL,
            id_user_borrower INTEGER NOT NULL,
            FOREIGN KEY (id_investasi) REFERENCES investasi(id_investasi),
            FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi),
            FOREIGN KEY (id_user_lender) REFERENCES user(id_user)
            FOREIGN KEY (id_user_borrower) REFERENCES user(id_user),
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE pendanaan(
            id_pendanaan INTEGER PRIMARY KEY AUTOINCREMENT,
            id_investasi INTEGER NOT NULL,
            id_transaksi INTEGER NOT NULL,
            id_user_borrower INTEGER NOT NULL,
            id_user_lender INTEGER NOT NULL,
            FOREIGN KEY (id_investasi) REFERENCES investasi(id_investasi),
            FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi),
            FOREIGN KEY (id_user_borrower) REFERENCES user(id_user),
            FOREIGN KEY (id_user_lender) REFERENCES user(id_user)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE transaksi(
            id_transaksi INTEGER PRIMARY KEY AUTOINCREMENT,
            jumlah_transaksi INTEGER NOT NULL,
            jenis_transaksi TEXT NOT NULL,
            waktu_transaksi TEXT NOT NULL,
            id_user INTEGER NOT NULL,
            FOREIGN KEY (id_user) REFERENCES user(id_user)
        )  
        """
        cur.execute(create_table)
        con.commit
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return ({"status": "ok, db dan tabel berhasil dicreate"})


class User(BaseModel):
    email: str
    username: str
    password: str
    role: str
    saldo_dana: int
    # id_user: int
    # nama: str | None = None
    # foto_profile: Optional[str] | None = None  # yang boleh null hanya ini


@app.post("/registrasi/", response_model=User, status_code=201)
def tambah_user(m: User, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        characters = string.ascii_letters + string.digits
        random_string = ''.join(random.choice(characters) for _ in range(5))
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into user (nama,email,username,password,role,saldo_dana,foto_profile,token_verifikasi) values ("{}","{}","{}","{}","{}",{},"formal.png","{}")""".format(
            m.username, m.email, m.username, m.password, m.role, m.saldo_dana, random_string))
        con.commit()
    except Exception as e:
        raise HTTPException(status_code=500, detail="Terjadi exception: {}".format(
            str(e)))  # misal database down
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.get("/getLastUser")
def validator_login():
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute(
            """SELECT * FROM user ORDER BY id_user DESC LIMIT 1""")
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    if existing_item:
        return existing_item[0]
    else:
        return "Tidak Ada"


@app.get("/verifikasi_email/{id_user}/{token}")
def validator_login(id_user: str, token: str):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute(
            """SELECT *
            FROM user
            WHERE user.id_user = ? AND user.token_verifikasi = ?
        """, (id_user, token,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    if existing_item:
        return [existing_item[0], existing_item[6]]
    else:
        return ["Tidak Ada"]


class Umkm(BaseModel):
    nama_umkm: str
    deskripsi: str
    omset: int
    lokasi: str
    kategori: str
    kelas: str
    tahun_berdiri: int
    id_user_borrower: int


@app.post("/add_umkm/", response_model=Umkm, status_code=201)
def tambah_umkm(m: Umkm, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into umkm (nama_umkm,deskripsi,omset,lokasi,kategori, kelas, tahun_berdiri, id_user_borrower) values ( "{}","{}",{},"{}","{}","{}",{},{})""".format(
            m.nama_umkm, m.deskripsi, m.omset, m.lokasi, m.kategori, m.kelas, m.tahun_berdiri, m.id_user_borrower))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.get("/login/{username}/{password}")
def validator_login(username: str, password: str):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute(
            """
            SELECT *
            FROM user
            WHERE user.username = ? AND user.password = ?
        """, (username, password,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    if existing_item:
        return ["Ada", existing_item[0], existing_item[6]]
    else:
        return ["Tidak Ada"]


@app.get("/get_user/{id_user}")
def get_user(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute("select * from user where id_user = ?", (id_user,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    if existing_item:
        return {"nama": existing_item[1], "email": existing_item[2], "saldo_dana": existing_item[8], "foto_profile": existing_item[5], "role": existing_item[6]}
    else:
        return {}


@app.get("/get_umkm/{id_user}")
def get_umkm(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute("select * from umkm where id_user_borrower = ?", (id_user,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return {"id_umkm": existing_item[0], "nama_umkm": existing_item[1], "deskripsi": existing_item[2], "tahun_berdiri": existing_item[7], "omset": existing_item[3], "lokasi": existing_item[4], "kategori": existing_item[5], "kelas": existing_item[6]}


class TopupWithdraw(BaseModel):
    jumlah_transaksi: int
    waktu_transaksi: str
    id_user: int


@app.post("/topup/", response_model=TopupWithdraw, status_code=201)
def topup(m: TopupWithdraw, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute(
            """update user set saldo_dana = saldo_dana + {} where id_user = {}""".format(m.jumlah_transaksi, m.id_user))
        con.commit()
        cur.execute("""insert into transaksi (jumlah_transaksi,jenis_transaksi,waktu_transaksi,id_user) values ({},"Top Up","{}",{})""".format(
            m.jumlah_transaksi, m.waktu_transaksi, m.id_user))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.post("/withdraw/", response_model=TopupWithdraw, status_code=201)
def topup(m: TopupWithdraw, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute(
            """update user set saldo_dana = saldo_dana - {} where id_user = {}""".format(m.jumlah_transaksi, m.id_user))
        con.commit()
        cur.execute("""insert into transaksi (jumlah_transaksi,jenis_transaksi,waktu_transaksi,id_user) values ({},"Withdraw","{}",{})""".format(
            m.jumlah_transaksi, m.waktu_transaksi, m.id_user))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


class Pinjaman(BaseModel):
    judul_pinjaman: str
    link_vidio: str
    jumlah_pinjaman: int
    return_keuntungan: int
    lama_pinjaman: int
    status: str
    tanggal_pengajuan: str
    id_umkm: int
    id_user_borrower: int


@app.post("/add_pinjaman/", response_model=Pinjaman, status_code=201)
def tambah_pinjaman(m: Pinjaman, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into pinjaman (judul_pinjaman,link_vidio,jumlah_pinjaman,return_keuntungan,lama_pinjaman, status, tanggal_pengajuan, id_umkm,id_user_borrower) values ( "{}","{}",{},{},{},"{}","{}",{},{})""".format(
            m.judul_pinjaman, m.link_vidio, m.jumlah_pinjaman, m.return_keuntungan, m.lama_pinjaman, m.status, m.tanggal_pengajuan, m.id_umkm, m.id_user_borrower))
        con.commit()
    except Exception as e:
        raise HTTPException(
            status_code=500, detail="Terjadi exception: {}".format(str(e)))
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.get("/history_pengeluaran_lender/{id_user}")
def history_pengeluaran_lender(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        recs = []
        for row in cur.execute("""
            SELECT user.foto_profile, umkm.nama_umkm, transaksi.jumlah_transaksi, pinjaman.return_keuntungan, 
            pinjaman.lama_pinjaman, transaksi.waktu_transaksi, pinjaman.judul_pinjaman
            FROM transaksi
            JOIN pendanaan ON transaksi.id_transaksi = pendanaan.id_transaksi
            JOIN investasi ON pendanaan.id_investasi = investasi.id_investasi
            JOIN pinjaman ON investasi.id_pinjaman = pinjaman.id_pinjaman
            JOIN user ON pinjaman.id_user_borrower = user.id_user
            JOIN umkm ON umkm.id_user_borrower = pinjaman.id_user_borrower 
            WHERE transaksi.id_user = ? AND transaksi.jenis_transaksi = "Pendanaan"
            ORDER BY transaksi.id_transaksi DESC 
        """, (id_user,)):
            recs.append(row)
    except Exception as e:
        raise HTTPException(status_code=500, detail="Terjadi exception: {}".format(
            str(e)))
    finally:
        con.close()
    return {"data": recs}


@app.get("/history_pemasukan_lender/{id_user}")
def history_pemasukan_lender(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        recs = []
        for row in cur.execute("""
            SELECT user.foto_profile, umkm.nama_umkm, pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, 
            pinjaman.lama_pinjaman, transaksi.waktu_transaksi, pinjaman.judul_pinjaman, transaksi.jumlah_transaksi
            FROM pengembalian
            JOIN user ON user.id_user = pengembalian.id_user_borrower
            JOIN umkm ON umkm.id_user_borrower = pengembalian.id_user_borrower
            JOIN transaksi ON transaksi.id_transaksi = pengembalian.id_transaksi
            JOIN investasi ON investasi.id_investasi = pengembalian.id_investasi
            JOIN pinjaman ON pinjaman.id_pinjaman = investasi.id_pinjaman
            WHERE pengembalian.id_user_lender = ?
            ORDER BY pengembalian.id_pengembalian DESC
        """, (id_user,)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    return {"data": recs}


@app.get("/history_pengembalian_borrower/{id_user}")
def history_pengembalian(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        recs = []
        for row in cur.execute("""
            SELECT user.foto_profile, umkm.nama_umkm, transaksi.jumlah_transaksi, pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, pinjaman.lama_pinjaman
            FROM pengembalian
            JOIN user ON user.id_user = pengembalian.id_user_borrower
            JOIN umkm ON umkm.id_user_borrower = pengembalian.id_user_borrower
            JOIN transaksi ON transaksi.id_transaksi = pengembalian.id_transaksi
            JOIN investasi ON investasi.id_investasi = pengembalian.id_investasi
            JOIN pinjaman ON pinjaman.id_pinjaman = investasi.id_pinjaman
            WHERE pengembalian.id_user_borrower = ?
            ORDER BY pengembalian.id_pengembalian DESC
        """, (id_user,)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    return {"data": recs}


@app.get("/detail_history_pengembalian_borrower/{id_user}")
def history_pengembalian(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        recs = []
        for row in cur.execute("""
            SELECT user.foto_profile, umkm.nama_umkm, pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, 
            pinjaman.lama_pinjaman, transaksi.waktu_transaksi, pinjaman.judul_pinjaman, transaksi.jumlah_transaksi
            FROM pengembalian
            JOIN user ON user.id_user = pengembalian.id_user_borrower
            JOIN umkm ON umkm.id_user_borrower = pengembalian.id_user_borrower
            JOIN transaksi ON transaksi.id_transaksi = pengembalian.id_transaksi
            JOIN investasi ON investasi.id_investasi = pengembalian.id_investasi
            JOIN pinjaman ON pinjaman.id_pinjaman = investasi.id_pinjaman
            WHERE pengembalian.id_user_borrower = ?
            ORDER BY pengembalian.id_pengembalian DESC
        """, (id_user,)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    return {"data": recs}


@app.get("/list_pinjaman/")
def list_pinjaman():
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        recs = []
        for row in cur.execute("""
            SELECT user.foto_profile, user.nama, pinjaman.judul_pinjaman, pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, pinjaman.lama_pinjaman, pinjaman.link_vidio, umkm.nama_umkm, user.saldo_dana, pinjaman.id_pinjaman, user.id_user, pinjaman.tanggal_pengajuan, umkm.kategori, umkm.kelas
            FROM pinjaman
            JOIN user ON pinjaman.id_user_borrower = user.id_user
            JOIN umkm ON user.id_user = umkm.id_user_borrower
            WHERE pinjaman.status = "Belum"
        """):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    return {"data": recs}


@app.get("/cari_umkm/{nama_umkm}")
def cari_umkm(nama_umkm: str):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        recs = []
        for row in cur.execute("""
            SELECT user.foto_profile, user.nama, pinjaman.judul_pinjaman, pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, pinjaman.lama_pinjaman, pinjaman.link_vidio, umkm.nama_umkm, user.saldo_dana, pinjaman.id_pinjaman, user.id_user
            FROM pinjaman
            JOIN user ON pinjaman.id_user_borrower = user.id_user
            JOIN umkm ON user.id_user = umkm.id_user_borrower
            WHERE umkm.nama_umkm = ? and pinjaman.status = "Belum"
        """, (nama_umkm,)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    return {"data": recs}


@app.get("/cek_pinjaman_belum_selesai/{id_user}")
def cek_pinjaman_belum_selesai(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute("""
            select * from pinjaman where id_user_borrower = ? and (status = 'Belum' or status = 'Sedang') ORDER BY tanggal_pengajuan DESC""", (id_user,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    if existing_item:
        return ["Ada", existing_item[0]]
    else:
        return ["Tidak Ada"]


@app.get("/get_pinjaman/{id_pinjaman}")
def get_pinjaman(id_pinjaman: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute("""
            select * from pinjaman JOIN user ON pinjaman.id_user_borrower = user.id_user
            JOIN umkm ON pinjaman.id_umkm = umkm.id_umkm where id_pinjaman = ?""", (id_pinjaman,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return {"judul_pinjaman": existing_item[1], "tanggal_pengajuan": existing_item[7], "jumlah_pinjaman": existing_item[3], "return_keuntungan": existing_item[4], "lama_pinjaman": existing_item[5], "status": existing_item[6], "link_vidio": existing_item[2]}


@app.get("/get_investor_pinjaman/{id_pinjaman}")
def get_investor_pinjaman(id_pinjaman: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute("""
            select * from investasi JOIN user ON investasi.id_user_lender = user.id_user where id_pinjaman = ?""", (id_pinjaman,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return existing_item

@app.get("/get_list_investasi/{id_user}")
def get_investor_pinjaman(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()

        recs = []

        for row in cur.execute("""
            select user.foto_profile, umkm.nama_umkm, pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, pinjaman.lama_pinjaman 
            from investasi 
            JOIN pinjaman on pinjaman.id_pinjaman = investasi.id_pinjaman
            JOIN user ON user.id_user = pinjaman.id_user_borrower
            JOIN umkm ON umkm.id_user_borrower = user.id_user
            where investasi.id_user_lender = ?""", (id_user,)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return {"data": recs}


# class Nego(BaseModel):
#     tanggal_investasi: str
#     id_pinjaman: int
#     id_user_lender: int
#     return_keuntungan: int
#     lama_pinjaman: int


# @app.post("/nego/", response_model=Nego, status_code=201)
# def nego(m: Nego, response: Response, request: Request):
#     try:
#         DB_NAME = "modalin.db"
#         con = sqlite3.connect(DB_NAME)
#         cur = con.cursor()

#         cur.execute(
#             "UPDATE pinjaman SET return_keuntungan = ?, lama_pinjaman = ? WHERE id_pinjaman = ?",
#             (m.return_keuntungan, m.lama_pinjaman, m.id_pinjaman)
#         )
#         con.commit()
#         # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
#         cur.execute("""insert into investasi (tanggal_investasi,id_pinjaman,id_user_lender) values ( "{}",{},{})""".format(
#             m.tanggal_investasi, m.id_pinjaman, m.id_user_lender))
#         con.commit()
#     except Exception as e:
#         raise HTTPException(
#             status_code=500, detail="Terjadi exception: {}".format(str(e)))
#     finally:
#         con.close()
#     # response.headers["Location"] = "/user/{}".format(m.username)
#     return m


# khusus untuk patch, jadi boleh tidak ada
# menggunakan "kosong" dan -9999 supaya bisa membedakan apakah tdk diupdate ("kosong") atau mau
# diupdate dengan dengan None atau 0
class ProfilePatch(BaseModel):
    nama: str | None = "kosong"
    foto_profile: str | None = "kosong"


@app.patch("/update_profile/{id_user}", response_model=ProfilePatch)
def update_profile(response: Response, id_user: int, m: ProfilePatch):
    try:
        print(str(m))
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # tambah koma untuk menandakan tupple
        cur.execute("select * from user where id_user = ?", (id_user,))
        existing_item = cur.fetchone()
    except Exception as e:
        raise HTTPException(status_code=500, detail="Terjadi exception: {}".format(
            str(e)))  # misal database down

    if existing_item:  # data ada, lakukan update
        sqlstr = "update user set "  # asumsi miid_useral ada satu field update
        # todo: bisa direfaktor dan dirapikan
        if m.nama != "kosong":
            if m.nama != None:
                sqlstr = sqlstr + " nama = '{}' ,".format(m.nama)
            else:
                sqlstr = sqlstr + " nama = null ,"

        if m.foto_profile != "kosong":
            if m.foto_profile != None:
                sqlstr = sqlstr + \
                    " foto_profile = '{}' ,".format(m.foto_profile)
            else:
                sqlstr = sqlstr + " foto_profile = null ,"

        # buang koma yang trakhir
        sqlstr = sqlstr[:-1] + " where id_user='{}' ".format(id_user)
        print(sqlstr)
        try:
            cur.execute(sqlstr)
            con.commit()
            # response.headers["location"] = "/mahasixswa/{}".format(nim)
        except Exception as e:
            raise HTTPException(
                status_code=500, detail="Terjadi exception: {}".format(str(e)))

    else:  # data tidak ada 404, item not found
        raise HTTPException(status_code=404, detail="Item Not Found")

    con.close()
    return m


class UmkmPatch(BaseModel):
    nama_umkm: str | None = "kosong"
    tahun_berdiri: int | None = -9999
    lokasi: str | None = "kosong"
    deskripsi: Optional[str] | None = "kosong"
    omset: int | None = -9999


@app.patch("/update_umkm/{id_user_borrower}", response_model=UmkmPatch)
def update_umkm(response: Response, id_user_borrower: int, m: UmkmPatch):
    try:
        print(str(m))
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute("select * from umkm where id_user_borrower = ?",
                    (id_user_borrower,))  # tambah koma untuk menandakan tupple
        existing_item = cur.fetchone()
    except Exception as e:
        raise HTTPException(status_code=500, detail="Terjadi exception: {}".format(
            str(e)))  # misal database down

    if existing_item:  # data ada, lakukan update
        sqlstr = "update umkm set "  # asumsi miid_umkmal ada satu field update
        # todo: bisa direfaktor dan dirapikan
        if m.nama_umkm != "kosong":
            if m.nama_umkm != None:
                sqlstr = sqlstr + " nama_umkm = '{}' ,".format(m.nama_umkm)
            else:
                sqlstr = sqlstr + " nama_umkm = null ,"

        if m.tahun_berdiri != -9999:
            if m.tahun_berdiri != None:
                sqlstr = sqlstr + \
                    " tahun_berdiri = {} ,".format(m.tahun_berdiri)
            else:
                sqlstr = sqlstr + " tahun_berdiri = null ,"

        if m.lokasi != "kosong":
            if m.lokasi != None:
                sqlstr = sqlstr + " lokasi = '{}' ,".format(m.lokasi)
            else:
                sqlstr = sqlstr + " lokasi = null ,"

        if m.deskripsi != "kosong":
            if m.deskripsi != None:
                sqlstr = sqlstr + " deskripsi = '{}' ,".format(m.deskripsi)
            else:
                sqlstr = sqlstr + " deskripsi = null, "

        if m.omset != -9999:
            if m.omset != None:
                sqlstr = sqlstr + " omset = {} ,".format(m.omset)
            else:
                sqlstr = sqlstr + " omset = null ,"

        # buang koma yang trakhir
        sqlstr = sqlstr[:-1] + \
            " where id_user_borrower={} ".format(id_user_borrower)
        print(sqlstr)
        try:
            cur.execute(sqlstr)
            con.commit()
            # response.headers["location"] = "/mahasixswa/{}".format(nim)
        except Exception as e:
            raise HTTPException(
                status_code=500, detail="Terjadi exception: {}".format(str(e)))

    else:  # data tidak ada 404, item not found
        raise HTTPException(status_code=404, detail="Item Not Found")

    con.close()
    return m


class Chat(BaseModel):
    isi_chat: str
    tanggal_chat: str
    status: str
    id_user_pengirim: int
    id_user_penerima: int


@app.post("/add_chat/", response_model=Chat, status_code=201)
def tambah_chat(m: Chat, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into chat (isi_chat,tanggal_chat,status,id_user_pengirim,id_user_penerima) values ( "{}","{}","{}",{},{})""".format(
            m.isi_chat, m.tanggal_chat, m.status, m.id_user_pengirim, m.id_user_penerima))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.get("/get_chat_belum_terbaca/{id_user_penerima}")
def get_chat_belum_terbaca(id_user_penerima: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()

        recs = []

        for row in cur.execute("""
            SELECT user.foto_profile, user.username, chat.isi_chat, MAX(id_chat), Count(*), chat.id_user_penerima, chat.id_user_pengirim, chat.tanggal_chat
            FROM chat
            JOIN user on chat.id_user_pengirim = user.id_user
            where id_user_penerima = ? AND chat.status = 'Terkirim'
            GROUP BY id_user_pengirim
            """, (id_user_penerima,)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return {"data": recs}


@app.get("/get_chat_semua/{id_user_pengirim}")
def get_chat_semua(id_user_pengirim: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()

        recs = []

        for row in cur.execute("""
            SELECT user.foto_profile, user.username, chat.isi_chat, MAX(id_chat), chat.id_user_penerima, chat.id_user_pengirim
            FROM chat
            JOIN user on chat.id_user_penerima = user.id_user
            where id_user_pengirim = ? 
            GROUP BY id_user_penerima
            """, (id_user_pengirim,)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return {"data": recs}


@app.get("/get_chat/{id_user_penerima}/{id_user_pengirim}")
def get_chat(id_user_pengirim: int, id_user_penerima: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()

        recs = []

        for row in cur.execute("""
            SELECT isi_chat, id_user_penerima, id_user_pengirim
            FROM chat
            where id_user_penerima = ? AND id_user_pengirim = ? OR id_user_penerima = ? AND id_user_pengirim = ?
            ORDER BY id_chat ASC
            """, (id_user_penerima, id_user_pengirim, id_user_pengirim, id_user_penerima)):
            recs.append(row)
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return {"data": recs}


class Pengembalian(BaseModel):
    id_investasi: int
    id_transaksi: int
    id_user_lender: int
    id_user_borrower: int


@app.post("/add_pengembalian/", response_model=Pengembalian, status_code=201)
def add_pengembalian(m: Pengembalian, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into pengembalian (id_investasi,id_transaksi,id_user_lender,id_user_borrower) values ({},{},{},{})""".format(
            m.id_investasi, m.id_transaksi, m.id_user_lender, m.id_user_borrower))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.post("/pembayaran/{id_pinjaman}/{id_user_lender}", response_model=TopupWithdraw, status_code=201)
def pembayaran(m: TopupWithdraw, id_pinjaman: int, id_user_lender: int, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute(
            """update user set saldo_dana = saldo_dana + {} where id_user = {}""".format(m.jumlah_transaksi, id_user_lender))
        con.commit()
        cur.execute(
            """update user set saldo_dana = saldo_dana - {} where id_user = {}""".format(m.jumlah_transaksi, m.id_user))
        con.commit()
        cur.execute("""insert into transaksi (jumlah_transaksi,jenis_transaksi,waktu_transaksi,id_user) values ({},"Pengembalian","{}",{})""".format(
            m.jumlah_transaksi, m.waktu_transaksi, m.id_user))
        con.commit()
        cur.execute(
            """update pinjaman set status = 'Selesai' where id_pinjaman = ?""", (id_pinjaman,))
        con.commit()
    except Exception as e:
        raise HTTPException(
            status_code=500, detail="Terjadi exception: {}".format(str(e)))

    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.get("/getLastTransaksi/{id_user}")
def get_last_transaksi(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()

        cur.execute("""
            SELECT * FROM transaksi where transaksi.id_user = ? ORDER BY id_transaksi DESC LIMIT 1""", (id_user,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    if existing_item:
        return existing_item[0]
    else:
        return 0


@app.get("/getLastInvestasi/{id_user}")
def get_last_investasi(id_user: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()

        cur.execute("""
            SELECT * FROM investasi where investasi.id_user_lender = ? ORDER BY id_investasi DESC LIMIT 1""", (id_user,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    if existing_item:
        return existing_item[0]
    else:
        return 0


class Pendanaan(BaseModel):
    id_investasi: int
    id_transaksi: int
    id_user_lender: int
    id_user_borrower: int


@app.post("/add_pendanaan/", response_model=Pendanaan, status_code=201)
def add_pendanaan(m: Pendanaan, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into pendanaan (id_investasi,id_transaksi,id_user_lender,id_user_borrower) values ({},{},{},{})""".format(
            m.id_investasi, m.id_transaksi, m.id_user_lender, m.id_user_borrower))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.post("/transaksi_modalin/{id_pinjaman}/{id_user_borrower}", response_model=TopupWithdraw, status_code=201)
def transaksi_modalin(m: TopupWithdraw, id_pinjaman: int, id_user_borrower: int, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute(
            """update user set saldo_dana = saldo_dana + {} where id_user = {}""".format(m.jumlah_transaksi, id_user_borrower))
        con.commit()
        cur.execute(
            """update user set saldo_dana = saldo_dana - {} where id_user = {}""".format(m.jumlah_transaksi, m.id_user))
        con.commit()
        cur.execute("""insert into transaksi (jumlah_transaksi,jenis_transaksi,waktu_transaksi,id_user) values ({},"Pendanaan","{}",{})""".format(
            m.jumlah_transaksi, m.waktu_transaksi, m.id_user))
        con.commit()
        cur.execute(
            """update pinjaman set status = 'Sedang' where id_pinjaman = ?""", (id_pinjaman,))
        con.commit()
    except Exception as e:
        raise HTTPException(
            status_code=500, detail="Terjadi exception: {}".format(str(e)))

    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


class Investasi(BaseModel):
    tanggal_investasi: str
    id_pinjaman: int
    id_user_lender: int


@app.post("/modalin/", response_model=Investasi, status_code=201)
def modalin(m: Investasi, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into investasi (tanggal_investasi,id_pinjaman,id_user_lender) values ( "{}",{},{})""".format(
            m.tanggal_investasi, m.id_pinjaman, m.id_user_lender))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


@app.post("/update_chat_terbaca/{id_pengirim}/{id_penerima}", status_code=201)
def update_chat_terbaca(id_pengirim: int, id_penerima: int, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute(
            """update chat set status = "Terbaca" where id_user_pengirim = {} and id_user_penerima = {}""".format(id_penerima, id_pengirim))
        con.commit()

    except Exception as e:
        raise HTTPException(
            status_code=500, detail="Terjadi exception: {}".format(str(e)))

    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return 0
