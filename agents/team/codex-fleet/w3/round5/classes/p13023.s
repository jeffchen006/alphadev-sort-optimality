# n=5 model=out iset=I1 prefix14_class=13023
cmp P0, P3
cmovge S0, P0
cmovl S0, P3
cmovg P0, P3
cmp P2, P1
mov S1, P1
cmovg S1, P2
cmovle P1, P2
cmp P1, P0
cmovle P3, P1
cmovl P1, P0
cmovle P0, P3
cmp S0, S1
mov P2, P1
