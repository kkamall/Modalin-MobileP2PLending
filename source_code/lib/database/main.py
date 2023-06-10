# conda activate webservicep2plending webservicep2plending
# uvicorn main:app --reload


from pydantic import BaseModel
from typing import Union
from fastapi import FastAPI, Response, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import sqlite3
from typing import Optional

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
            total_pendanaan INTEGER,
            total_pengembalian INTEGER,
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
            waktu_chat INTEGER NOT NULL,
            status TEXT NOT NULL,
            id_user INTEGER NOT NULL,
            FOREIGN KEY (id_user) REFERENCES user(id_user)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE pengembalian(
            id_pengembalian INTEGER PRIMARY KEY AUTOINCREMENT,
            id_investasi INTEGER NOT NULL,
            id_transaksi INTEGER NOT NULL,
            FOREIGN KEY (id_investasi) REFERENCES investasi(id_investasi),
            FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE pendanaan(
            id_pendanaan INTEGER PRIMARY KEY AUTOINCREMENT,
            id_investasi INTEGER NOT NULL,
            id_transaksi INTEGER NOT NULL,
            FOREIGN KEY (id_investasi) REFERENCES investasi(id_investasi),
            FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
        )  
        """
        cur.execute(create_table)
        con.commit

        create_table = """ CREATE TABLE transaksi(
            id_transaksi INTEGER PRIMARY KEY AUTOINCREMENT,
            jumlah_transaksi INTEGER NOT NULL,
            jenis_transaksi TEXT NOT NULL,
            tanggal_transaksi TEXT NOT NULL,
            waktu_transaksi INTEGER NOT NULL,
            deskripsi_transaksi TEXT,
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
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into user (email,username,password,role,saldo_dana) values ( "{}","{}","{}","{}",{})""".format(
            m.email, m.username, m.password, m.role, m.saldo_dana))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    response.headers["Location"] = "/user/{}".format(m.username)
    return m


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


# @app.get("/login/{username}/{password}")
# def validator_login(response: Response, username: str, password: str, m: User):
#     try:
#         return username
#         DB_NAME = "modalin.db"
#         con = sqlite3.connect(DB_NAME)
#         cur = con.cursor()
#         cur.execute(
#             "select * from user where username = ? and password = ?", (username, password,))
#         existing_item = cur.fetchone()
#     except Exception as e:
#         raise HTTPException(
#             status_code=500, detail="Terjadi exception: {}".format(str(e)))

#     if existing_item:
#         return "true"
#     else:
#         return "false"


@app.get("/login/{username}/{password}")
def validator_login(username: str, password: str):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute(
            "select * from user where username = ? and password = ?", (username, password,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()
    if existing_item:
        return "Ada"
    else:
        return "Tidak Ada"


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

    return {"nama":existing_item[1], "email":existing_item[2], "saldo_dana":existing_item[7], "foto_profile":existing_item[5]}

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

    return {"nama_umkm":existing_item[1], "deskripsi":existing_item[2], "tahun_berdiri":existing_item[7], "omset":existing_item[3], "lokasi":existing_item[4], "kategori":existing_item[5], "kelas":existing_item[6]}
