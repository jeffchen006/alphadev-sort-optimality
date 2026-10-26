# n=5 model=out iset=I1 prefix14_class=2654
mov S2, P3
cmp P2, S2
cmovge S2, P2
mov S1, P1
cmovl P3, P2
cmp P1, P0
cmovg S1, P0
cmovl P1, P0
cmovle P0, S1
cmp S2, P1
cmovle S0, P1
cmovle P1, S2
cmovl S2, S0
mov P2, P1
