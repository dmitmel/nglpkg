// Kacol Porting System
#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <stdint.h>
#define MAKESTRING(nt) #nt
#define MAKESTRING2(nt) MAKESTRING(nt)
#define CHECK_FN(fn) \
	if (pointers_close(fn, here))\
		puts("-- The function '" #fn "' was inlined. There may be binding issues on your system.");

int pointers_close(void * a, void * b) {
	int64_t dist = (int64_t) (a - b);
	if (dist < 0)
		dist = -dist;
	return dist < 0x10000;
}
void main() {
	struct stat sz;
	struct dirent de;
	void * here = (void *) main;
	CHECK_FN(opendir);
	CHECK_FN(readdir);
	CHECK_FN(closedir);
	CHECK_FN(stat); // This one triggers on Linux; Kacol has special handling.
	CHECK_FN(unlink);
	CHECK_FN(rmdir);
	void * a = &sz;
	void * b = &(sz.st_mode);
	void * c = &de;
	void * d = &(de.d_name);
	puts("-- Kacol Filesystem Configuration Information --");
	puts("{");
	printf(" stat_st_mode_ofs = %i,\n", (int) (b - a));
	printf(" stat_st_mode_size = %i,\n", (int) sizeof(sz.st_mode));
	printf(" stat_size = %i,\n", (int) sizeof(sz));
	printf(" dirent_d_name_ofs = %i,\n", (int) (d - c));
	printf(" dirent_d_name_size = %i,\n", (int) sizeof(de.d_name));
	puts("}");
}

