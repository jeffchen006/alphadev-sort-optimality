# n=5 model=out iset=I1 prefix14_class=8043
cmp P3, P1
mov S1, P0
cmovg S0, P3
cmovg P3, P1
cmovg P1, S0
cmp P2, P0
cmovg P0, P2
cmovg P2, S1
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovge S2, P3
cmp P1, P0
mov S2, P1
