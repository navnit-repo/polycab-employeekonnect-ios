//
//  antireverse.h
//  XMWClient
//
//  Created by Pradeep Singh on 26/12/20.
//  Copyright © 2020 dotvik. All rights reserved.
//

#ifndef antireverse_h
#define antireverse_h

// For debugger_ptrace. Ref: https://www.theiphonewiki.com/wiki/Bugging_Debuggers
#import <dlfcn.h>
#import <sys/types.h>

// For debugger_sysctl
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>
#include <stdlib.h>

// For ioctl
#include <termios.h>
#include <sys/ioctl.h>

// For task_get_exception_ports
#include <mach/task.h>
#include <mach/mach_init.h>




typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);


#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif  // !defined(PT_DENY_ATTACH)


void debugger_ptrace();
bool debugger_sysctl(void);

#endif /* antireverse_h */
