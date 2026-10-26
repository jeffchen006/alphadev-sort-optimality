# n=5 model=out iset=I1 prefix14_class=4759
cmp P3, P0
mov S0, P3
cmovge S0, P0
cmovle P3, P0
cmp P1, P2
mov P0, P1
cmovg P0, P2
mov S1, P0
cmovle P1, P2
cmp S0, P0
cmovg S1, S0
cmovge S0, P0
mov S0, P1
cmp P1, P3
