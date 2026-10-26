# n=5 model=out iset=I1 prefix14_class=8357
cmp P3, P1
cmovle S0, P1
cmovg S0, P3
cmovle P1, P3
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
mov S1, P1
cmovg P2, S2
cmp P0, S1
mov P3, S0
cmovg S1, P0
cmovg P0, P1
mov P0, S1
