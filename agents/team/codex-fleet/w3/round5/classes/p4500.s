# n=5 model=out iset=I1 prefix14_class=4500
mov S1, P2
cmp P1, P2
cmovg S1, P1
mov S0, P0
cmovg P1, P2
cmp P0, P3
cmovle P0, P3
cmovg S0, P3
mov P3, P0
cmp P0, S1
cmovg P0, S1
cmovge S1, P3
cmp S0, P1
cmovge S1, S0
