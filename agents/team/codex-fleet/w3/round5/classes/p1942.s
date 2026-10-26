# n=5 model=out iset=I1 prefix14_class=1942
cmp P0, P2
mov S0, P0
cmovle P0, P2
cmovge S0, P2
cmp P3, P1
mov S1, P1
cmovle S1, P3
cmovg P1, P3
mov S2, P1
cmp P0, S2
cmovl P1, P0
cmovge S2, P0
cmp S1, S0
mov P3, P1
