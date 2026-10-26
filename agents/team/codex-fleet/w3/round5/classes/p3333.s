# n=5 model=out iset=I1 prefix14_class=3333
mov S0, P0
mov S2, P2
cmp P2, P1
cmovg P2, P1
cmovge P1, S2
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmp P2, S0
cmovg S1, P2
cmovge P2, S0
mov P0, P3
cmovle S1, S0
cmovge S0, S1
