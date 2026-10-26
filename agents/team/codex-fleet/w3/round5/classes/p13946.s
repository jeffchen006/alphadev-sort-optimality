# n=5 model=out iset=I1 prefix14_class=13946
cmp P1, P3
mov S2, P1
cmovle P1, P3
cmovge S2, P3
cmp P2, P0
cmovle S1, P0
cmovg S1, P2
cmovle P0, P2
cmp S1, P1
cmovle S0, P1
cmovl P1, S1
cmovl S1, S0
mov P3, P1
mov P2, S2
