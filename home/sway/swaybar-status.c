#include <sys/time.h>
#include <time.h>
#include <unistd.h>

int main() {
	struct timeval tp = {0};
	struct tm *tm = localtime(&tp.tv_sec);
	for (;;) {
		gettimeofday(&tp, NULL);
		localtime(&tp.tv_sec);

		char buf[128];
		size_t len = strftime(buf, sizeof buf, "%H:%M:%S | %b %d, %Y \n", tm);
		write(1, buf, len);

		usleep(1000 * 1000 - tp.tv_usec);
	}
}
