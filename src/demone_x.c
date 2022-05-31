#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <syslog.h>
#include "mylib.h"
#include <dlfcn.h>

void sig_handler(int signum){

  void *handle;
  int (*num)(void);
  char *error;
  printf("prova a caricare\n");
  handle = dlopen ("libmylib.so", RTLD_LAZY);
  if (!handle) {
    fputs (dlerror(), stderr);
    exit(1);
  }

  num = dlsym(handle, "write_to_shmem");
  if ((error = dlerror()) != NULL)  {
    fputs(error, stderr);
    exit(1);
  }

  if ((*num)() == 0) {
    syslog (LOG_NOTICE, "SIGNAL SENT (alessio)");
  }

  dlclose(handle);
}


static void skeleton_daemon()
{
  pid_t pid;

  /* Fork off the parent process */
  pid = fork();

  /* An error occurred */
  if (pid < 0)
    exit(EXIT_FAILURE);

  /* Success: Let the parent terminate */
  if (pid > 0)
    exit(EXIT_SUCCESS);

  /* On success: The child process becomes session leader */
  if (setsid() < 0)
    exit(EXIT_FAILURE);

  /* Catch, ignore and handle signals */
  //TODO: Implement a working signal handler */
  signal(SIGCHLD, SIG_IGN);
  signal(SIGHUP, SIG_IGN);

  /* Fork off for the second time*/
  pid = fork();

  /* An error occurred */
  if (pid < 0)
    exit(EXIT_FAILURE);

  /* Success: Let the parent terminate */
  if (pid > 0)
    exit(EXIT_SUCCESS);

  /* Set new file permissions */
  umask(0);

  /* Change the working directory to the root directory */
  /* or another appropriated directory */
  chdir("/");

  /* Close all open file descriptors */
  int x;
  for (x = sysconf(_SC_OPEN_MAX); x>=0; x--) {
    close (x);
  }

  /* Open the log file */
  openlog ("DEMONE_X", LOG_PID, LOG_DAEMON);
}


int main()
{
  skeleton_daemon();
  syslog (LOG_NOTICE, "DEMONE_X AVVIATO (alessio)");
  signal(SIGUSR1, sig_handler);

  sleep(60);
  syslog (LOG_NOTICE, "DEMONE_X TERMINATO (alessio)");
  closelog();

  return EXIT_SUCCESS;
}
