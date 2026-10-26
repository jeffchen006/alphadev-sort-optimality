# n=5 model=out iset=I1 prefix14_class=12782
cmp P0, P1
cmovg S2, P0
cmovg P0, P1
cmovg P1, S2
mov S1, P0
mov S0, P3
cmp P2, S0
cmovle S0, P2
cmovle P2, P3
cmp P0, S0
cmovge S1, S0
mov S1, P2
cmovg S0, P0
cmp P2, P1
