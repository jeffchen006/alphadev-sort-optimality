# n=5 model=out iset=I1 prefix14_class=834
cmp P1, P3
mov S2, P1
cmovle S2, P3
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
mov S0, P2
cmovg S0, P0
cmovge P0, P2
cmp P0, S2
cmovle S2, P0
mov P2, S0
cmovg P3, P0
cmovg P0, S2
