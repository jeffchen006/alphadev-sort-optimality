# n=5 model=out iset=I1 prefix14_class=803
mov S0, P0
cmp S0, P1
mov S2, P3
cmovle S0, P1
cmovge P0, P1
cmp P3, P2
cmovge P3, P2
cmovge P2, S2
cmp P2, S0
cmovg S1, P2
cmovg P2, S0
cmovg S0, S1
mov P1, P3
cmp P3, P0
