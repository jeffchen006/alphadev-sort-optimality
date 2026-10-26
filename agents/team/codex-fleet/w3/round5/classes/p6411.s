# n=5 model=out iset=I1 prefix14_class=6411
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P0, P2
mov S1, P2
cmovge S1, P0
cmovle P2, P0
cmovle P0, S1
cmp P3, S1
cmovg P0, P3
cmovle S1, P3
cmp P1, P2
mov P3, S1
