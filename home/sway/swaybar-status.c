#include <sys/time.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

int main() {
	char buf[64] = {0};
	int batfd = open("/sys/class/power_supply/BAT1/capacity", O_RDONLY | O_CLOEXEC);
	struct timeval tp = {0};
	struct tm *tm = localtime(&tp.tv_sec);

	for (;;) {

		ssize_t len1_ = pread(batfd, buf, sizeof buf - 3, 0) - 1;
		size_t len1;
		if (len1_ > 0) {
			len1 = len1_ + 4;
			buf[len1_ + 0] = '%';
			buf[len1_ + 1] = ' ';
			buf[len1_ + 2] = '|';
			buf[len1_ + 3] = ' ';
		} else {
			len1 = 0;
		}

		gettimeofday(&tp, NULL);
		localtime(&tp.tv_sec);
		size_t len2 = strftime(
			buf + len1,
			sizeof buf - len1,
			"%H:%M:%S | %b %d, %Y \n",
			tm
		);

		write(1, buf, len1 + len2);
		usleep(1000 * 1000 - tp.tv_usec);
	}
}
