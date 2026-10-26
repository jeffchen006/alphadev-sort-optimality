# n=5 model=out iset=I1 prefix14_class=12833
cmp P2, P3
mov S0, P2
cmovle P2, P3
cmovg S0, P3
cmp P1, P0
mov P3, P0
cmovg P3, P1
cmovle P0, P1
mov P1, P2
cmp P0, S0
cmovge S2, P0
cmovg P0, S0
cmovge S0, S2
cmp P3, P1
