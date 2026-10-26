# n=5 model=out iset=I1 prefix14_class=7189
mov S1, P1
mov S0, P0
cmp P2, P1
cmovg P1, P2
cmovg P2, S1
cmp P3, P0
cmovge S0, P3
cmovle P0, P3
cmp P0, P2
mov P3, P0
cmovg P3, P2
cmovle P0, P2
cmp P1, S0
cmovle S2, S0
