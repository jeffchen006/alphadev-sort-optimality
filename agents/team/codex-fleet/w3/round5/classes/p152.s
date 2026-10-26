# n=5 model=out iset=I1 prefix14_class=152
cmp P1, P3
mov S1, P1
cmovle P1, P3
cmovg S1, P3
cmp P2, P0
mov S2, P0
cmovle P0, P2
cmovg S2, P2
cmovl P2, S2
cmp S1, P0
mov S0, P0
cmovge S0, S1
cmovge S1, P0
cmovge P0, S0
