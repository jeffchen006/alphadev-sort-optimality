# n=5 model=out iset=I1 prefix14_class=6370
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovg P1, S1
cmp P3, P2
cmovle S2, P3
mov S0, P1
cmovge S2, P2
cmovg P2, P3
cmp P2, S0
cmovg P1, P2
mov P1, S2
cmovle S0, P2
mov P2, S0
