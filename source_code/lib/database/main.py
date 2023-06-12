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
        cur.execute("""insert into user (email,username,password,role,saldo_dana,foto_profile,token_validasi) values ("{}","{}","{}","{}",{},"formal.png",{})""".format(
            m.email, m.username, m.password, m.role, m.saldo_dana, random_string))
        con.commit()
        cur.execute("""SELECT * FROM user ORDER BY id_user DESC LIMIT 1""")
        con.commit()
        existing_item = cur.fetchone()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return existing_item[0]

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

    return {"nama":existing_item[1], "email":existing_item[2], "saldo_dana":existing_item[7]}

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

class TopupWithdraw(BaseModel):
    saldo_dana: int
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
        cur.execute("""update user set saldo_dana = saldo_dana + {} where id_user = {}""".format(m.saldo_dana, m.id_user))
        con.commit()
        cur.execute("""insert into transaksi (jumlah_transaksi,jenis_transaksi,waktu_transaksi,id_user) values ({},"Top Up","{}",{})""".format(m.jumlah_transaksi, m.waktu_transaksi, m.id_user))
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
        cur.execute("""update user set saldo_dana = saldo_dana - {} where id_user = {}""".format(m.saldo_dana, m.id_user))
        con.commit()
        cur.execute("""insert into transaksi (jumlah_transaksi,jenis_transaksi,waktu_transaksi,id_user) values ({},"Withdraw","{}",{})""".format(m.jumlah_transaksi, m.waktu_transaksi, m.id_user))
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
            m.judul_pinjaman, m.link_vidio, m.jumlah_pinjaman, m.return_keuntungan, m.lama_pinjaman, m.status, m.tanggal_pengajuan,m.id_umkm, m.id_user_borrower))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m


# @app.get("/get_user_umkm/{id_user}")
# def get_user_umkm(id_user: int):
#     try:
#         DB_NAME = "modalin.db"
#         con = sqlite3.connect(DB_NAME)
#         cur = con.cursor()

#         # Join the 'user' and 'umkm' tables based on the 'id_user' column
#         cur.execute("""
#             SELECT user.nama, user.email, user.saldo_dana, umkm.nama_umkm, umkm.deskripsi, umkm.tahun_berdiri, umkm.omset, umkm.lokasi, umkm.kategori, umkm.kelas
#             FROM user
#             JOIN umkm ON user.id_user = umkm.id_user_borrower
#             WHERE user.id_user = ?
#         """, (id_user,))

#         existing_item = cur.fetchone()
#     except:
#         return ({"status": "terjadi error"})
#     finally:
#         con.close()

#     return {
#         "nama": existing_item[0],
#         "email": existing_item[1],
#         "saldo_dana": existing_item[2],
#         "nama_umkm": existing_item[3],
#         "deskripsi": existing_item[4],
#         "tahun_berdiri": existing_item[5],
#         "omset": existing_item[6],
#         "lokasi": existing_item[7],
#         "kategori": existing_item[8],
#         "kelas": existing_item[9]
#     }

# history / aktivitas

@app.get("/get_history_pendanaan/{id_user}")
def get_list_pendanaan(id_user: int):
   try:
       DB_NAME = "modalin.db"
       con = sqlite3.connect(DB_NAME)
       cur = con.cursor()
       recs = []
       for row in cur.execute("""
            SELECT transaksi.jumlah_transaksi, transaksi.waktu_transaksi, pinjaman.judul_pinjaman, 
            pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, pinjaman.lama_pinjaman
            FROM transaksi
            JOIN pendanaan ON transaksi.id_transaksi = pendanaan.id_transaksi
            JOIN investasi ON pendanaan.id_investasi = investasi.id_investasi
            JOIN pinjaman ON investasi.id_pinjaman = pinjaman.id_pinjaman
            WHERE transaksi.id_user = ? AND transaksi.jenis_transaksi = "pendanaan"
        """, (id_user,)):
           recs.append(row)
   except:
       return ({"status":"terjadi error"})   
   finally:  	 
       con.close()
   return {"data":recs}

@app.get("/get_history_pengembalian/{id_user}")
def get_list_pengembalian(id_user: int):
   try:
       DB_NAME = "modalin.db"
       con = sqlite3.connect(DB_NAME)
       cur = con.cursor()
       recs = []
       for row in cur.execute("""
            SELECT transaksi.jumlah_transaksi, transaksi.waktu_transaksi, pinjaman.judul_pinjaman, 
            pinjaman.jumlah_pinjaman, pinjaman.return_keuntungan, pinjaman.lama_pinjaman
            FROM transaksi
            JOIN pengembalian ON transaksi.id_transaksi = pengembalian.id_transaksi
            JOIN investasi ON pengembalian.id_investasi = investasi.id_investasi
            JOIN pinjaman ON investasi.id_pinjaman = pinjaman.id_pinjaman
            WHERE transaksi.id_user = ? AND transaksi.jenis_transaksi = "pengembalian"
        """, (id_user,)):
           recs.append(row)
   except:
       return ({"status":"terjadi error"})   
   finally:  	 
       con.close()
   return {"data":recs}

@app.get("/get_list_pinjaman/")
def get_list_pinjaman():
   try:
       DB_NAME = "modalin.db"
       con = sqlite3.connect(DB_NAME)
       cur = con.cursor()
       recs = []
       for row in cur.execute("""
            SELECT * 
            FROM pinjaman
            JOIN user ON pinjaman.id_user_borrower = user.id_user
            JOIN umkm ON umkm.id_umkm = umkm.id_umkm
            WHERE pinjaman.status = "belum"
        """):
           recs.append(row)
   except:
       return ({"status":"terjadi error"})   
   finally:  	 
       con.close()
   return {"data":recs}

@app.get("/get_pinjaman/{id_pinjaman}")
def get_pinjaman(id_pinjaman: int):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        cur.execute("""
            select * from pinjaman JOIN user ON pinjaman.id_user_borrower = user.id_user
            JOIN umkm ON umkm.id_umkm = umkm.id_umkm where id_pinjaman = ?""", (id_pinjaman,))
        existing_item = cur.fetchone()
    except:
        return ({"status": "terjadi error"})
    finally:
        con.close()

    return existing_item


class Investasi(BaseModel):
    judul_pinjaman: str
    link_vidio: str
    jumlah_pinjaman: int
    return_keuntungan: int
    lama_pinjaman: int
    status: str
    tanggal_pengajuan: str
    id_umkm: int
    id_user_borrower: int

@app.post("/add_investasi/", response_model=Pinjaman, status_code=201)
def tambah_pinjaman(m: Pinjaman, response: Response, request: Request):
    try:
        DB_NAME = "modalin.db"
        con = sqlite3.connect(DB_NAME)
        cur = con.cursor()
        # hanya untuk test, rawal sql injecttion, gunakan spt SQLAlchemy
        cur.execute("""insert into pinjaman (judul_pinjaman,link_vidio,jumlah_pinjaman,return_keuntungan,lama_pinjaman, status, tanggal_pengajuan, id_umkm,id_user_borrower) values ( "{}","{}",{},{},{},"{}","{}",{},{})""".format(
            m.judul_pinjaman, m.link_vidio, m.jumlah_pinjaman, m.return_keuntungan, m.lama_pinjaman, m.status, m.tanggal_pengajuan,m.id_umkm, m.id_user_borrower))
        con.commit()
    except:
        print("oioi error")
        return ({"status": "terjadi error"})
    finally:
        con.close()
    # response.headers["Location"] = "/user/{}".format(m.username)
    return m