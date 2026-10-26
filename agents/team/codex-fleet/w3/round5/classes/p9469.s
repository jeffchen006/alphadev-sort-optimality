# n=5 model=out iset=I1 prefix14_class=9469
mov S0, P3
cmp P1, P2
cmovle S1, P2
cmovge S1, P1
cmovl P2, P1
cmp S0, P0
cmovg S0, P0
cmovge P0, P3
cmp S0, P2
cmovle P3, P2
cmovl P2, S0
cmovl S0, P3
cmp P0, S1
mov P2, P0
