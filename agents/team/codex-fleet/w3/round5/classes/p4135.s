# n=5 model=out iset=I1 prefix14_class=4135
mov S0, P2
cmp P1, P2
cmovle S0, P1
cmovge P2, P1
cmp P0, P3
mov S2, P3
cmovle S2, P0
cmovge P3, P0
mov S1, S2
cmp S0, S2
cmovg S1, S0
cmovg S0, S2
cmp P2, P3
cmovg P0, P2
