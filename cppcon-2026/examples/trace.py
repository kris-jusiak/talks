from bcc import BPF
from collections import defaultdict
import subprocess

BPF_PROGRAM = r"""
#include <uapi/linux/ptrace.h>

struct event_t {
    u64 ip;
    u64 pid;
    u64 arg0;
    u64 arg1;
    u64 arg2;
    u64 arg3;
    u64 arg4;
    u64 arg5;
};

BPF_PERF_OUTPUT(events);

int trace_function(struct pt_regs *ctx)
{
    struct event_t e = {};

    e.ip   = PT_REGS_IP(ctx);
    e.pid  = bpf_get_current_pid_tgid() >> 32;

    e.arg0 = PT_REGS_PARM1(ctx);
    e.arg1 = PT_REGS_PARM2(ctx);
    e.arg2 = PT_REGS_PARM3(ctx);
    e.arg3 = PT_REGS_PARM4(ctx);
    e.arg4 = PT_REGS_PARM5(ctx);
    e.arg5 = PT_REGS_PARM6(ctx);

    events.perf_submit(ctx, &e, sizeof(e));

    return 0;
}
"""

BINARY = "./trace.out"

b = BPF(text=BPF_PROGRAM)

# Attach to every function/symbol in the binary.
b.attach_uprobe(
    name=BINARY,
    sym="steady",
    fn_name="trace_function",
)


def print_event(cpu, data, size):
    e = b["events"].event(data)

    # Resolve the instruction pointer back to the binary symbol.
    try:
        sym = b.ksym(e.ip)
    except Exception:
        sym = b.sym(e.ip, e.pid)

    print(
        f"{sym.decode(errors='replace')}: "
        f"arg0=0x{e.arg0:x} "
        f"arg1=0x{e.arg1:x} "
        f"arg2=0x{e.arg2:x} "
        f"arg3=0x{e.arg3:x} "
        f"arg4=0x{e.arg4:x} "
        f"arg5=0x{e.arg5:x}"
    )


b["events"].open_perf_buffer(print_event)

print(f"Tracing all functions in {BINARY}... Ctrl-C to exit")

while True:
    try:
        b.perf_buffer_poll()
    except KeyboardInterrupt:
        break
