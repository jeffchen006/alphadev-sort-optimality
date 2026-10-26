# n=5 model=out iset=I1 prefix14_class=800
mov S0, P2
cmp S0, P1
cmovge P2, P1
cmovle S0, P1
mov S2, P0
cmp P0, P3
cmovge P0, P3
cmovg P3, S2
cmp P3, S0
cmovg S1, P3
cmovge P3, S0
mov P1, P0
cmovg S0, S1
cmp P0, P2
