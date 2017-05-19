# FeBug

FeBug hanya dapat berjalan di OS Linux, karena FeBug dibangun dengan bash-linux. Untuk saat ini, FeBug hanya dapat meng-*compile* bahasa c++11.

## Cara Install
1. Download febug.sh
2. Kemudian taruh di sebuah directory, anggap saja sekarang berada di ```/home/user/febug```
3. Masuk ke terminal dan edit file ```.bashrc``` dengan cara:
  ```$ gedit .bashrc```
4. Kemudian tambahkan ```alias febug=~/febug/febug.sh``` pada bagian paling akhir file. Lalu simpan
5. Lakukan command ```chmod a+x ~/febug/febug.sh``` agar dapat dijalankan
6. Selesai

## Cara Menjalankan
1. Masuk ke directory file
2. Kemudian ketikkan ```febug <NAMA FILE> <MODE>```
    > Untuk mengetahui mode yang tersedia, anda cukup mengetikkan ```febug```
    > MODE
      - **Normal**
        Jika <MODE> kosong, maka FeBug akan memakai mode ini secara default. Input berasal dari FILE, bukan keyboard. Gunakan ```-n``` untuk mode ini. Susunan file yang dibutuhkan:
         ```
         code.cpp
         code.in
         ```
      - **Interaktif**
        Mode ini adalah mode interaktif. Gunakan ```-i``` untuk mode ini. Susunan file yang dibutuhkan:
         ```
         code.cpp
         code.judge.cpp
         code.in
         ```
      - **Compile and run only**
        Tidak ada yang spesial dalam mode ini. FeBug hanya meng-*compile* source code saja dan menjalankan seperti biasa. Sehingga menggunakan standart input atau masukan keyboard. Gunakan ```-c``` untuk mode ini. Susunan file yang dibutuhkan:
        ```code.cpp```
     > Untuk contoh dapat dilihat pada ```examples```
3. FeBug telah berjalan.
