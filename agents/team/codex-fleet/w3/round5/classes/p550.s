# n=5 model=out iset=I1 prefix14_class=550
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovg P3, S0
mov S1, P1
cmp P1, P2
cmovl P1, P2
cmovge S1, P2
mov S2, S1
cmp P0, S2
cmovge S2, P0
cmovle S1, P0
cmp P3, P1
mov P2, S2
