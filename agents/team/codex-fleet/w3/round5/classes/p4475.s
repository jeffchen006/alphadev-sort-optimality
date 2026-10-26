# n=5 model=out iset=I1 prefix14_class=4475
mov S0, P3
cmp P3, P0
mov S2, P2
cmovg P3, P0
cmovle S0, P0
cmp P1, S2
cmovle P2, P1
cmovle P1, S2
cmp P1, S0
cmovge S2, P1
cmovg P1, S0
mov P0, P3
cmovg S0, S2
cmp P0, P2
