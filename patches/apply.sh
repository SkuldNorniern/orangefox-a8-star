#!/bin/bash
# Source patches on top of OrangeFox fox_12.1 for astarqlte.
# Re-runnable: restores the touched files from git first, then patches.
set -e
SRC=${1:-~/fox_12.1}
R=$SRC/bootable/recovery
git -C "$R" checkout -- libpixelflinger/scanline.cpp libpixelflinger/codeflinger/CodeCache.cpp \
    gui/theme/portrait_hdpi/images/Default/About/maintainer.png

# pixelflinger code cache: on Samsung kernels mmap(PROT_EXEC) on an ashmem
# fd can fail with EACCES, and recovery aborts right after the splash.
# Use an anonymous mapping, and fall back to the generic scanline if RWX
# memory is refused.
python3 - "$R" <<'PY'
import sys
r = sys.argv[1]

# 1. CodeCache: anonymous RWX mapping instead of an ashmem fd.
p = r + '/libpixelflinger/codeflinger/CodeCache.cpp'
s = open(p).read()
old = """        int fd = ashmem_create_region("CodeFlinger code cache",
                                      kMaxCodeCacheCapacity);
        LOG_ALWAYS_FATAL_IF(fd < 0,
                            "Creating code cache, ashmem_create_region "
                            "failed with error '%s'", strerror(errno));
        gExecutableStore = mmap(NULL, kMaxCodeCacheCapacity,
                                PROT_READ | PROT_WRITE | PROT_EXEC,
                                MAP_PRIVATE, fd, 0);
        LOG_ALWAYS_FATAL_IF(gExecutableStore == MAP_FAILED,
                            "Creating code cache, mmap failed with error "
                            "'%s'", strerror(errno));
        close(fd);"""
new = """        // HackOS: anonymous mapping; PROT_EXEC on an ashmem fd is refused
        // by the Samsung SM-G885S kernel.
        gExecutableStore = mmap(NULL, kMaxCodeCacheCapacity,
                                PROT_READ | PROT_WRITE | PROT_EXEC,
                                MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        LOG_ALWAYS_FATAL_IF(gExecutableStore == MAP_FAILED,
                            "Creating code cache, mmap failed with error "
                            "'%s'", strerror(errno));"""
assert old in s, 'CodeCache.cpp layout changed'
open(p, 'w').write(s.replace(old, new))

# 2. scanline: if even anonymous RWX memory is refused, keep the generic
# pipeline instead of reaching the (fatal) code cache.
p = r + '/libpixelflinger/scanline.cpp'
s = open(p).read()
s = s.replace('#include <string.h>\n', '#include <string.h>\n#include <sys/mman.h>\n', 1)
helper = """
// HackOS: probe once whether the kernel allows RWX anonymous memory.
static bool codegen_allowed()
{
    static int allowed = -1;
    if (allowed < 0) {
        void* p = mmap(NULL, 4096, PROT_READ | PROT_WRITE | PROT_EXEC,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        allowed = (p != MAP_FAILED);
        if (allowed)
            munmap(p, 4096);
        else
            ALOGW("pixelflinger: RWX memory refused, using generic scanline");
    }
    return allowed;
}
"""
anchor = 'static void pick_scanline(context_t* c)\n'
assert s.count(anchor) == 1
s = s.replace(anchor, helper + '\n' + anchor, 1)
old = """    c->init_y = init_y;
    c->step_y = step_y__generic;

#if ANDROID_ARM_CODEGEN
    // we're going to have to generate some code..."""
new = """    c->init_y = init_y;
    c->step_y = step_y__generic;

#if ANDROID_ARM_CODEGEN
    if (!codegen_allowed()) {
        c->scanline = scanline;
        return;
    }
    // we're going to have to generate some code..."""
assert old in s, 'scanline.cpp layout changed'
open(p, 'w').write(s.replace(old, new, 1))
PY
grep -c 'HackOS' "$R/libpixelflinger/codeflinger/CodeCache.cpp" "$R/libpixelflinger/scanline.cpp"

# Maintainer picture on the About page (Eira, GitHub avatar, 192x192 RGBA).
cp "$(dirname "$0")/assets/maintainer.png" "$R/gui/theme/portrait_hdpi/images/Default/About/maintainer.png"
