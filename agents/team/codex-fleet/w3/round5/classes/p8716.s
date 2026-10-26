# n=5 model=out iset=I1 prefix14_class=8716
cmp P0, P1
cmovge S1, P1
mov S0, P2
cmovg P1, P0
cmovg P0, S1
cmp S0, P3
cmovge S0, P3
cmovl P2, P3
mov S2, P1
cmp P2, S2
cmovle P1, P2
cmovg S2, P2
mov P3, P1
mov S2, P0
