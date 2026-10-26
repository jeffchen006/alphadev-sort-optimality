# n=5 model=out iset=I1 prefix14_class=2708
cmp P0, P1
mov S0, P1
cmovge S0, P0
mov S2, S0
cmovle P1, P0
mov P0, P2
cmp P2, P3
cmovl P2, P3
cmovl P3, P0
cmp P2, S2
cmovl S2, P2
cmovle P2, S0
cmp P3, P1
cmovg S0, P1
