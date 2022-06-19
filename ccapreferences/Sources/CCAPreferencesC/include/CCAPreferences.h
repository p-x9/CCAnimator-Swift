@import Foundation;
#import <spawn.h>

static void easy_spawn(const char* args[]) {
    pid_t pid;
    int status;
    posix_spawn(&pid, args[0], NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}

static void respring() {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/sbreload"]) {
        easy_spawn((const char *[]){"/usr/bin/sbreload", NULL});
    } else {
        easy_spawn((const char *[]){"/usr/bin/killall", "backboardd", NULL});
    }
}
