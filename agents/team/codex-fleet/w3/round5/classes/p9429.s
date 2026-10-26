# n=5 model=out iset=I1 prefix14_class=9429
cmp P0, P1
mov S0, P3
mov S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P2, S0
cmovle S0, P2
cmovg P3, P2
cmp S0, P1
cmovge S2, P1
cmovg P1, S0
mov S1, P3
cmovge S0, S2
mov P2, P1
