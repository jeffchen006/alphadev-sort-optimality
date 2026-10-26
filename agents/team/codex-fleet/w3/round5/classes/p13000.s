# n=5 model=out iset=I1 prefix14_class=13000
mov S2, P0
cmp P2, P0
cmovle S2, P2
mov S0, P3
cmovg P0, P2
cmp P1, P3
cmovle S0, P1
cmovg P3, P1
cmp S2, S0
mov S1, P0
cmovge P2, S0
cmovg S0, S2
cmovge S2, P2
cmp P3, S1
