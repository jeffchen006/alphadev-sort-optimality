# n=5 model=out iset=I1 prefix14_class=7019
cmp P3, P0
cmovg S2, P3
cmovg P3, P0
cmovle S2, P0
mov S0, P1
cmp S0, P2
cmovg P1, P2
cmovle S0, P2
cmp P3, P1
cmovge P0, P3
cmovge P3, P1
cmovge P1, P0
mov P2, S0
cmp S0, S2
