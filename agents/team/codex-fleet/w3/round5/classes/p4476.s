# n=5 model=out iset=I1 prefix14_class=4476
mov S0, P3
cmp P3, P2
mov S2, P0
cmovg P3, P2
cmovle S0, P2
cmp P1, S2
cmovle P0, P1
cmovle P1, S2
cmp P1, S0
cmovge S2, P1
mov P2, P3
cmovg P1, S0
cmovg S0, S2
cmp P2, P0
