#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

const char *const ppc = "powerprofilesctl";
const int arg_bat = 1;
const int arg_current = 2;

int main(int argc, char **argv) {
	if (!(argc > arg_bat)) {
		fprintf(stderr, "no battery specified\n");
		return 4;
	}
	char *bat = argv[arg_bat];

	char *current = NULL;
	if (argc > arg_current) {
		current = argv[arg_current];
		// fprintf(stderr, "current profile %s\n", current);
	}

	char buf[16] = {0};
	int batfd = open(bat, O_RDONLY | O_CLOEXEC);
	if (batfd == -1) {
		int err = errno;
		fprintf(stderr, "unable to open battery (%m)\n");
		return err;
	}

	ssize_t len = pread(batfd, buf, sizeof buf - 1, 0);
	if (len == -1) {
		int err = errno;
		fprintf(stderr, "unable to read battery (%m)\n");
		return err;
	}

	char *end = buf;
	int battery = strtoul(buf, &end, 10);
	if (end - buf != len - 1) {
		fprintf(stderr, "read illegal battery value\n");
		return 3;
	}

	char *target = battery > 50 ? "balanced" : "power-saver";

	if (current != NULL && strcmp(current, target) == 0) {
		fprintf(stderr, "profile already set to %s\n", target);
		return 1;
	}

	// fprintf(stderr, "setting profile to %s\n", target);
	execlp(ppc, ppc, "set", target, NULL);

	int err = errno;
	fprintf(stderr, "failed to run powerprofilesctl (%m)\n");
	return err;
}
