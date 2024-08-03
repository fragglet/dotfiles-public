set style address foreground cyan
set style address intensity normal
set style disassembler comment foreground white
set style disassembler comment intensity normal
set style disassembler immediate foreground cyan
set style disassembler immediate intensity normal
set style disassembler mnemonic foreground green
set style disassembler mnemonic intensity normal
set style disassembler register foreground red
set style disassembler register intensity normal
set style filename foreground green
set style filename intensity normal
set style function foreground yellow
set style function intensity normal
set style highlight foreground red
set style highlight intensity normal
set style metadata foreground white
set style metadata intensity normal
set style title intensity bold
set style title intensity bold
set style tui-active-border foreground cyan
set style tui-border foreground cyan
set style variable foreground cyan
set style variable intensity normal
set style version foreground magenta
set style version intensity bold

# Print linked list
define p_ll
  set var $n = $arg0
  while $n
    print *($n)
    set var $n = $n->next
  end
end

define reg32
  printf "%c[%dm%s 0x%08x %c[0m", 0x1b, $arg2, $arg0, $arg1, 0x1b
end

define reg64
  printf "%c[%dm%s 0x%016x %c[0m", 0x1b, $arg2, $arg0, $arg1, 0x1b
end

set $COLOR_RED     = 91
set $COLOR_GREEN   = 32
set $COLOR_YELLOW  = 33
set $COLOR_BLUE    = 94
set $COLOR_MAGENTA = 35
set $COLOR_CYAN    = 36
set $COLOR_WHITE   = 37

define regs
  set $__saved_width = $_gdb_setting("width")
  set width unlimited
  # x86
  if !$_isvoid($rax)
        reg64 "rax" $rax $COLOR_CYAN
        reg64 " r8" $r8  $COLOR_YELLOW
        reg64 "r12" $r12 $COLOR_YELLOW
        printf "\n"
        reg64 "rbx" $rbx $COLOR_CYAN
        reg64 " r9" $r9  $COLOR_YELLOW
        reg64 "r13" $r13 $COLOR_YELLOW
        printf "\n"
        reg64 "rcx" $rcx $COLOR_CYAN
        reg64 "r10" $r10 $COLOR_YELLOW
        reg64 "r14" $r14 $COLOR_YELLOW
        printf "\n"
        reg64 "rdx" $rdx $COLOR_CYAN
        reg64 "r11" $r11 $COLOR_YELLOW
        reg64 "r15" $r15 $COLOR_YELLOW
        printf "\n"
        reg64 "rbp" $rbp $COLOR_MAGENTA
        reg64 "rsi" $rsi $COLOR_GREEN
        reg64 "rdi" $rdi $COLOR_GREEN
        printf "\n"
        reg64 "rsp" $rsp $COLOR_MAGENTA
        info register eflags
  else
      if !$_isvoid($eax)
        reg32 "eax" $eax $COLOR_CYAN
        reg32 "ebx" $ebx $COLOR_CYAN
        reg32 "esi" $esi $COLOR_GREEN
        reg32 "esp" $esp $COLOR_MAGENTA
        printf "\n"
        reg32 "ecx" $ecx $COLOR_CYAN
        reg32 "edx" $edx $COLOR_CYAN
        reg32 "edi" $edi $COLOR_GREEN
        reg32 "ebp" $ebp $COLOR_MAGENTA
        printf "\n"
        info register eflags
      end
  end
  # arm
  if !$_isvoid($r0) && !$_isvoid($cpsr)
    reg32 "r0"  $r0    $COLOR_GREEN
    reg32 "r4"  $r4    $COLOR_YELLOW
    reg32 " r8" $r8    $COLOR_YELLOW
    reg32 "r12" $r12   $COLOR_RED
    printf "\n"
    reg32 "r1"  $r1    $COLOR_GREEN
    reg32 "r5"  $r5    $COLOR_YELLOW
    reg32 " r9" $r9    $COLOR_YELLOW
    reg32 " sp" $sp    $COLOR_MAGENTA
    printf "\n"
    reg32 "r2"  $r2    $COLOR_GREEN
    reg32 "r6"  $r6    $COLOR_YELLOW
    reg32 "r10" $r10   $COLOR_YELLOW
    reg32 " lr" $lr    $COLOR_GREEN
    printf "\n"
    reg32 "r3"  $r3    $COLOR_GREEN
    reg32 "r7"  $r7    $COLOR_YELLOW
    reg32 "r11" $r11   $COLOR_YELLOW
    reg32 "cpsr" $cpsr $COLOR_GREEN
    printf "\n"
  end
  # arm64
  if !$_isvoid($fpsr)
    reg64 " x0" $x0    $COLOR_GREEN
    reg64 " x9" $x9    $COLOR_YELLOW
    reg64 "x19" $x19   $COLOR_CYAN
    printf "\n"
    reg64 " x1" $x1    $COLOR_GREEN
    reg64 "x10" $x10   $COLOR_YELLOW
    reg64 "x20" $x20   $COLOR_CYAN
    printf "\n"
    reg64 " x2" $x2    $COLOR_GREEN
    reg64 "x11" $x11   $COLOR_YELLOW
    reg64 "x21" $x21   $COLOR_CYAN
    printf "\n"
    reg64 " x3" $x3    $COLOR_GREEN
    reg64 "x12" $x12   $COLOR_YELLOW
    reg64 "x22" $x22   $COLOR_CYAN
    printf "\n"
    reg64 " x4" $x4    $COLOR_GREEN
    reg64 "x13" $x13   $COLOR_YELLOW
    reg64 "x23" $x23   $COLOR_CYAN
    printf "\n"
    reg64 " x5" $x5    $COLOR_GREEN
    reg64 "x14" $x14   $COLOR_YELLOW
    reg64 "x24" $x24   $COLOR_CYAN
    printf "\n"
    reg64 " x6" $x6    $COLOR_GREEN
    reg64 "x15" $x15   $COLOR_YELLOW
    reg64 "x25" $x25   $COLOR_CYAN
    printf "\n"
    reg64 " x7" $x7    $COLOR_GREEN
    reg64 "x16" $x16   $COLOR_RED
    reg64 "x26" $x26   $COLOR_CYAN
    printf "\n"
    reg64 " x8" $x8    $COLOR_BLUE
    reg64 "x17" $x17   $COLOR_RED
    reg64 "x27" $x27   $COLOR_CYAN
    printf "\n"
    reg64 "x29" $x29   $COLOR_MAGENTA
    reg64 "x18" $x18   $COLOR_WHITE
    reg64 "x28" $x28   $COLOR_CYAN
    printf "\n"
    reg64 "x30" $x30   $COLOR_MAGENTA
    reg64 "sp" $sp     $COLOR_MAGENTA
    printf "\n"

    printf "\n"
  end
  # risc-v
  if !$_isvoid($tp)
    if sizeof($ra) == 4
      reg32 "ra"  $ra  $COLOR_MAGENTA
      reg32 "sp"  $sp  $COLOR_MAGENTA
      reg32 " gp" $gp  $COLOR_MAGENTA
      reg32 " tp" $tp  $COLOR_MAGENTA
      printf "\n"
      reg32 "a0"  $a0  $COLOR_GREEN
      reg32 "a1"  $a1  $COLOR_GREEN
      reg32 " a2" $a2  $COLOR_GREEN
      reg32 " a3" $a3  $COLOR_GREEN
      printf "\n"
      reg32 "a4"  $a4  $COLOR_GREEN
      reg32 "a5"  $a5  $COLOR_GREEN
      reg32 " a6" $a6  $COLOR_GREEN
      reg32 " a7" $a7  $COLOR_GREEN
      printf "\n"
      reg32 "s0"  $s0  $COLOR_YELLOW
      reg32 "s1"  $s1  $COLOR_YELLOW
      reg32 " s2" $s2  $COLOR_YELLOW
      reg32 " s3" $s3  $COLOR_YELLOW
      printf "\n"
      reg32 "s4"  $s4  $COLOR_YELLOW
      reg32 "s5"  $s5  $COLOR_YELLOW
      reg32 " s6" $s6  $COLOR_YELLOW
      reg32 " s7" $s7  $COLOR_YELLOW
      printf "\n"
      reg32 "s8"  $s8  $COLOR_YELLOW
      reg32 "s9"  $s9  $COLOR_YELLOW
      reg32 "s10" $s10 $COLOR_YELLOW
      reg32 "s11" $s11 $COLOR_YELLOW
      printf "\n"
      reg32 "t0"  $t0  $COLOR_CYAN
      reg32 "t1"  $t1  $COLOR_CYAN
      reg32 " t2" $t2  $COLOR_CYAN
      reg32 " t3" $t3  $COLOR_CYAN
      printf "\n"
    else
      reg64 "a0"  $a0 $COLOR_GREEN
      reg64 " a4" $a4 $COLOR_GREEN
      reg64 "ra"  $ra $COLOR_MAGENTA
      printf "\n"

      reg64 "a1"  $a1 $COLOR_GREEN
      reg64 " a5" $a5 $COLOR_GREEN
      reg64 "sp"  $sp $COLOR_MAGENTA
      printf "\n"

      reg64 "a2"  $a2 $COLOR_GREEN
      reg64 " a6" $a6 $COLOR_GREEN
      reg64 "gp"  $gp $COLOR_MAGENTA
      printf "\n"

      reg64 "a3"  $a3 $COLOR_GREEN
      reg64 " a7" $a7 $COLOR_GREEN
      reg64 "tp"  $tp $COLOR_MAGENTA
      printf "\n"

      reg64 "s0"  $s0 $COLOR_YELLOW
      reg64 " s6" $s6 $COLOR_YELLOW
      reg64 "t0"  $t0 $COLOR_CYAN
      printf "\n"

      reg64 "s1"  $s1 $COLOR_YELLOW
      reg64 " s7" $s7 $COLOR_YELLOW
      reg64 "t1"  $t1 $COLOR_CYAN
      printf "\n"

      reg64 "s2"  $s2 $COLOR_YELLOW
      reg64 " s8" $s8 $COLOR_YELLOW
      reg64 "t2"  $t2 $COLOR_CYAN
      printf "\n"

      reg64 "s3"  $s3 $COLOR_YELLOW
      reg64 " s9" $s9 $COLOR_YELLOW
      reg64 "t3"  $t3 $COLOR_CYAN
      printf "\n"

      reg64 "s4"  $s4 $COLOR_YELLOW
      reg64 "s10" $s10 $COLOR_YELLOW
      printf "\n"

      reg64 "s5"  $s5 $COLOR_YELLOW
      reg64 "s11" $s11 $COLOR_YELLOW
      printf "\n"
    end
  end
  set width $__saved_width
end

define reset
  shell reset
end

define cls
  shell clear
end

define hook-stop
  regs
  bt
end

define hook-attach
  regs
  bt
end

define hookpost-core-file
  regs
  bt
end
