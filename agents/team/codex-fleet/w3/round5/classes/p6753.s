# n=5 model=out iset=I1 prefix14_class=6753
cmp P1, P0
mov S0, P2
cmovg S2, P1
cmovg P1, P0
cmovle S2, P0
cmp S0, P3
cmovge P2, P3
cmovle S0, P3
cmp S2, S0
cmovge P3, S2
cmovg S2, S0
cmovg S0, P3
cmp P1, P2
mov P0, S2
