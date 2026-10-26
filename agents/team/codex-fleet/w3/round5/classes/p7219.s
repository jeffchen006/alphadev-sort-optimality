# n=5 model=out iset=I1 prefix14_class=7219
cmp P2, P1
cmovg S1, P2
cmovge P2, P1
mov S0, P0
cmovg P1, S1
cmp P3, S0
cmovge P0, P3
cmovge P3, S0
cmp P3, P2
cmovge S2, P2
cmovle S2, P3
cmovle P3, P2
mov S0, P0
mov S2, P3
