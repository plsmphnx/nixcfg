#include <stdlib.h>
#include <linux/vt.h>
#include <sys/ioctl.h>

int main(int argc, char *argv[]) {
    return ioctl(0, VT_WAITACTIVE, atoi(argv[1]));
}
