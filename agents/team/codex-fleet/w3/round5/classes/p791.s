# n=5 model=out iset=I1 prefix14_class=791
mov S0, P3
cmp P1, P2
cmovg S1, P1
cmovge P1, P2
cmovle S1, P2
cmp P3, P0
cmovg P3, P0
cmovg P0, S0
mov S0, P0
cmp S0, S1
cmovge P0, S1
mov P2, P1
cmovg S1, S0
mov S1, P0
