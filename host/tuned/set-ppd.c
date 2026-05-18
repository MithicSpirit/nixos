#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

const char *const ppc = "powerprofilesctl";

int main(int argc, char **argv) {
	char *bat;
	if (argc > 1) {
		bat = argv[1];
	} else {
		fprintf(stderr, "no battery specified\n");
	}

	char *current = NULL;
	if (argc > 2) {
		current = argv[2];
		fprintf(stderr, "current profile %s\n", current);
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

	char *target;
	if (battery > 70)
		target = "performance";
	else if (battery > 30)
		target = "balanced";
	else
		target = "power-saver";

	if (current != NULL && strcmp(current, target) == 0) {
		fprintf(stderr, "profile already set to %s\n", target);
		return 1;
	}

	fprintf(stderr, "setting profile to %s\n", target);
	execlp(ppc, ppc, "set", target, NULL);

	int err = errno;
	fprintf(stderr, "failed to run powerprofilesctl (%m)\n");
	return err;
}
